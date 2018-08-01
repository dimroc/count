//
//  ShutterButton.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/29/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import Cartography

class ShutterButton: UIButton {
    private var dimension: CGFloat = 60

    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))

        backgroundColor = UIColor.normalState
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = CGFloat(dimension / 2)
        layer.borderWidth = 5
        layer.borderColor = UIColor.borderNormalState

        constrain(self) { sb in
            sb.width == dimension
            sb.height == dimension
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func animateUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = UIColor.normalState
            self.layer.borderColor = UIColor.borderNormalState
        })
    }

    func animateDown() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = UIColor.takePhotoState
            self.layer.borderColor = UIColor.borderTakePhotoState
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateUp()
        super.touchesEnded(touches, with: event)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateDown()
        super.touchesBegan(touches, with: event)
    }
}

fileprivate extension UIColor {
    class var normalState: UIColor {
        return UIColor(white: 1.0, alpha: 0.65)
    }

    class var takePhotoState: UIColor {
        return UIColor.lightGray.withAlphaComponent(0.65)
    }

    class var borderNormalState: CGColor {
        return UIColor.gray.cgColor
    }

    class var borderTakePhotoState: CGColor {
        return UIColor.darkGray.cgColor
    }
}
