//
//  CameraViewController.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/14/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import CrowdCountApi
import UIKit

class CameraViewController: UIViewController, FrameExtractorDelegate {
    var frameExtractor: CameraFrameExtractor!
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor = CameraFrameExtractor()
        frameExtractor.delegate = self
    }
    
    func captured(image: UIImage) {
        imageView.image = image
    }
}
