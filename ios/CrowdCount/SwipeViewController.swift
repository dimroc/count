//
//  PageViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/14/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit

class SwipeViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var showPredictionVC: ShowPredictionViewController!
    let showPredictionIndex = 2
    var currentIndex = 0

    lazy var orderedViewControllers: [UIViewController] = {
        return [
            newVc(viewController: "sbCamera"),
            newVc(viewController: "sbPredictionsIndex"),
            showPredictionVC
        ]
    }()

    // MARK: - View Loading
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        showPredictionVC = (newVc(viewController: "sbShowPrediction") as! ShowPredictionViewController)
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }

        NotificationCenter.default.addObserver(forName: .navigateToShowPrediction, object: nil, queue: OperationQueue.main, using: navigateToShowPrediction)
    }

    private func navigateToShowPrediction(notification: Notification) {
        guard let image = notification.object as? UIImage else {
            print("Unable to navigate to show prediction page with object", notification.object ?? "nil")
            return
        }

        currentIndex = showPredictionIndex
        showPredictionVC.showLoading()
        setViewControllers([showPredictionVC],
                           direction: .forward,
                           animated: true,
                           completion: { _ in
            self.showPredictionVC.predict(image)
        })
    }

    override func viewDidLayoutSubviews() {
        makePageControlTransparent()
        super.viewDidLayoutSubviews()
    }

    private func makePageControlTransparent() {
        let contentView = self.view!
        var scrollView: UIScrollView?
        var pageControl: UIPageControl?
        for subView in contentView.subviews {
            if subView is UIScrollView {
                scrollView = subView as? UIScrollView
            } else if subView is UIPageControl {
                pageControl = subView as? UIPageControl
            }
        }

        if scrollView != nil {
            scrollView!.frame = self.view.bounds
        }
        if pageControl != nil {
            contentView.bringSubviewToFront(pageControl!)
        }
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }

    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }

    // MARK: Delegate functions.
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let newIndex = orderedViewControllers.index(of: pageViewController) else {
            return
        }
        currentIndex = newIndex
    }

    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
             return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        guard nextIndex < orderedViewControllers.count else {
             return nil
        }

        return orderedViewControllers[nextIndex]
    }
}
