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
    let uploadButton = UIButton(type: UIButton.ButtonType.system)
    let thumbnailImageView = UIImageView()
    let topStackView = UIStackView()
    let loadingView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        uploadButton.setTitle("Upload", for: UIControl.State.normal)
        uploadButton.isUserInteractionEnabled = true

        thumbnailImageView.contentMode = .scaleAspectFit

        loadingView.hidesWhenStopped = true
        loadingView.backgroundColor = .white

        topStackView.axis = .vertical
        topStackView.alignment = .center
        topStackView.distribution = .fillProportionally
        topStackView.spacing = 10

        let title = UILabel()
        title.text = "Prediction Analysis"
        title.h1().centerTextAlignment()

        topStackView.addArrangedSubview(title)
        topStackView.addArrangedSubview(thumbnailImageView)

        let scrollView = UIScrollView()
        scrollView.addSubview(uploadButton)
        scrollView.addSubview(topStackView)

        view.addSubview(loadingView)
        view.addSubview(scrollView)

        loadingView.constrainToSuperviewEdges()
        scrollView.constrainToSuperviewEdges()

        constrain(topStackView, scrollView) { stack, scroll in
            stack.edges == scroll.edges
            stack.width == scroll.width
        }

        constrain(uploadButton) { b in
            b.trailing == b.superview!.safeAreaLayoutGuide.trailing - 10
            b.top == b.superview!.safeAreaLayoutGuide.top - 4
        }
    }

    func predict(_ image: UIImage) {
        topStackView.removeAllArrangedSubviews(from: 2)
        let vm = ShowPredictionViewModel(image: image)
        drive(vm)
        vm.calculate()
    }

    func hydrate(_ analysis: PredictionAnalysisModel) {
        topStackView.removeAllArrangedSubviews(from: 2)
        let vm = ShowPredictionViewModel(analysis: analysis)
        drive(vm)
    }

    func showLoading() {
        loadingView.startAnimating()
        topStackView.isHidden = true
        uploadButton.isHidden = true
    }

    private func drive(_ vm: ShowPredictionViewModel) {
        vm.thumbnail.drive(thumbnailImageView.rx.image).disposed(by: disposeBag)
        vm.predictions.drive(rx.predictions).disposed(by: disposeBag)
        vm.predictions.drive(onCompleted: {
            self.uploadButton.isHidden = false
            self.topStackView.isHidden = false
            self.loadingView.stopAnimating()
        }).disposed(by: disposeBag)
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
