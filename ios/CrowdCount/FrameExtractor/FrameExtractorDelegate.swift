//
//  FrameExtractorDelegate.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/17/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import Foundation
import UIKit

protocol FrameExtractorDelegate: class {
    func captured(image: UIImage)
}
