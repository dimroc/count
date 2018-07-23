//
//  ImageFrameExtractor.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/21/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class ImageFrameExtractor: FrameExtractor {
    var frames: Observable<UIImage> {
        return subject
    }
    var orientation: AVCaptureVideoOrientation = AVCaptureVideoOrientation.landscapeLeft
    var isEnabled: Bool = true

    private let subject = PublishSubject<UIImage>()
    private let disposeBag = DisposeBag()

    private let availableImages = [
        "audience-crowd-fans",
        "bavaria-beer-fest"
    ]

    init() {
        startPushingImage(availableImages[0])
    }

    private func startPushingImage(_ imageName: String) {
        let image = UIImage(named: imageName, in: Bundle.main, compatibleWith: nil)!
        Observable<Int>
            .interval(1, scheduler: SerialDispatchQueueScheduler(qos: .utility))
            .subscribe { _ in self.subject.onNext(image) }
            .disposed(by: self.disposeBag)
    }
}
