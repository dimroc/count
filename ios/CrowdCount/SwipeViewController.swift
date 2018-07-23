//
//  PageViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/14/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit

class SwipeViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "sbCamera"),
                self.newVc(viewController: "sbPredictionsIndex")]
    }()

    // MARK: - View Loading
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        makePageControlTransparent()
        super.viewDidLayoutSubviews()
    }

    func makePageControlTransparent() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }

    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
             return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
             return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }

}
