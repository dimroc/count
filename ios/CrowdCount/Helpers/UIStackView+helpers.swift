//
//  UIStackView+helpers.swift
//  CrowdCount
//
//  https://gist.github.com/Deub27/5eadbf1b77ce28abd9b630eadb95c1e2
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews(from: Int = 0) {
        var count = 0
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            defer { count += 1 }
            if count >= from {
                self.removeArrangedSubview(subview)
                return allSubviews + [subview]
            }
            return allSubviews
        }

        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
