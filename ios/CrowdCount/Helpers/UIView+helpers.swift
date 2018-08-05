//
//  UIView+helpers.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/2/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import Cartography

extension UIView {
    func constrainToSuperviewEdges() {
        constrain(self) { child in
            child.edges == child.superview!.safeAreaLayoutGuide.edges
            child.center == child.superview!.safeAreaLayoutGuide.center
        }
    }
}
