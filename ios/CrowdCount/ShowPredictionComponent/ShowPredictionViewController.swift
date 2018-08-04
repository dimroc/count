//
//  ShowPredictionViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/1/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa

class ShowPredictionViewController: UIViewController {
    var vm: ShowPredictionViewModel!

    let thumbnailImageView = UIImageView()
    let topStackView = UIStackView()
    let loadingView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        thumbnailImageView.contentMode = .scaleAspectFit

        loadingView.hidesWhenStopped = true
        loadingView.backgroundColor = .white

        topStackView.axis = .vertical
        topStackView.alignment = .center
        topStackView.distribution = .fillProportionally
        topStackView.spacing = 10
        topStackView.isHidden = true

        let navBar = createNavBar()
        topStackView.addArrangedSubview(navBar)
        topStackView.addArrangedSubview(thumbnailImageView)

        let scrollView = UIScrollView()
        scrollView.addSubview(topStackView)

        view.addSubview(loadingView)
        view.addSubview(scrollView)

        loadingView.constrainToSuperviewEdges()
        scrollView.constrainToSuperviewEdges()

        constrain(navBar) { nb in
            nb.width == nb.superview!.width
        }

        constrain(topStackView, scrollView) { stack, scroll in
            stack.edges == scroll.edges
            stack.width == scroll.width
        }
    }

    func predict(_ image: UIImage) {
        topStackView.removeAllArrangedSubviews(from: 2)
        vm = ShowPredictionViewModel(image: image)
        drive(vm)
        vm.calculate()
    }

    func hydrate(_ analysis: PredictionAnalysisModel) {
        topStackView.removeAllArrangedSubviews(from: 2)
        vm = ShowPredictionViewModel(analysis: analysis)
        drive(vm)
    }

    func showLoading() {
        loadingView.startAnimating()
        topStackView.isHidden = true
    }

    func showUploadRequest() {
        let alert = UIAlertController(
            title: "Upload Analysis",
            message: "Is the count wrong? Help us improve by uploading incorrect predictions so we may better train our models.",
            preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let upload = UIAlertAction(title: "Upload", style: .default, handler: { _ in
            DispatchQueue.global().async {
                self.vm?.upload()
            }
        })

        alert.addAction(upload)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    private func drive(_ vm: ShowPredictionViewModel) {
        vm.thumbnail.drive(thumbnailImageView.rx.image).disposed(by: disposeBag)
        vm.predictions.drive(rx.predictions).disposed(by: disposeBag)
        vm.predictions.drive(onCompleted: {
            self.topStackView.isHidden = false
            self.loadingView.stopAnimating()
        }).disposed(by: disposeBag)
    }

    private func createNavBar() -> UIView {
        let navView = UIView()

        let title = UILabel()
        title.text = "Prediction Analysis"
        title.h1().centerTextAlignment()

        let uploadButton = UIButton(type: UIButton.ButtonType.system)
        uploadButton.setTitle("It's wrong!", for: UIControl.State.normal)
        uploadButton.isUserInteractionEnabled = true
        uploadButton.rx.tap.bind { [unowned self] in
            self.showUploadRequest()
        }.disposed(by: disposeBag)

        navView.addSubview(title)
        navView.addSubview(uploadButton)

        constrain(title) { t in
            t.center == t.superview!.center
        }

        constrain(uploadButton) { up in
            up.trailing == up.superview!.trailingMargin
            up.centerY == up.superview!.centerY
        }

        constrain(navView) { n in
            n.height == 40
        }

        return navView
    }
}

extension Reactive where Base: ShowPredictionViewController {
    var predictions: Binder<PredictionRowViewModel> {
        return Binder(base) { vc, rowVM in
            let row = PredictionRowView(viewModel: rowVM)
            let separator = HairlineView()
            vc.topStackView.addArrangedSubview(row)
            vc.topStackView.addArrangedSubview(separator)
            separator.constrainToSuperview()
        }
    }
}
