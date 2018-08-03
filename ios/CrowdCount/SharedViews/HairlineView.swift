//
//  HairlineView.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/2/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import Cartography

class HairlineView: UIView {
    let borderLayer = CALayer()
    let color = UIColor.darkGray

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let lineWidth = CGFloat(1.0)
        path.lineWidth = (1.0 / UIScreen.main.scale) / 2.0
        color.setStroke()
        path.move(to: CGPoint(x: 0, y: bounds.height - lineWidth / 2))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - lineWidth / 2))
        path.stroke()
    }

    func constrainToSuperview() {
        constrain(self) { s in
            s.width == s.superview!.safeAreaLayoutGuide.width - 140
            s.height == 10
        }
    }
}
