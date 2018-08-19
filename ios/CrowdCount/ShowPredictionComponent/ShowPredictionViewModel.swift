//
//  ShowPredictionViewModel.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/1/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Promises
import CrowdCountApi
import RealmSwift
import FirebaseStorage

class ShowPredictionViewModel {
    let image: UIImage
    let predictor = FriendlyPredictor()
    var analysisId: String!
    var cachedPredictions: [PredictionRowViewModel]!

    private let predictionsSubject = ReplaySubject<PredictionRowViewModel>.createUnbounded()
    var predictions: Driver<PredictionRowViewModel> {
        return predictionsSubject.asDriver(onErrorJustReturn: PredictionRowViewModel.empty)
    }

    private let thumbnailSubject = ReplaySubject<UIImage>.createUnbounded()
    var thumbnail: Driver<UIImage> {
        return thumbnailSubject.asDriver(onErrorJustReturn: UIImage())
    }

    init(image: UIImage) {
        self.image = image
    }

    init(analysis: PredictionAnalysisModel) {
        analysisId = analysis.id
        image = analysis.image(for: .original)!
        let predictions: [PredictionRowViewModel?] = analysis.predictions.map { pm in
            guard let label = PredictionAnalysisModel.ImageLabel(rawValue: pm.classification) else {
                print("Unable generate prediction to retrieve label for \(pm.classification) on \(analysis.id)")
                return nil
            }
            let insight = analysis.image(for: label)
            return PredictionRowViewModel.from(realm: pm, insight: insight)
        }

        generateThumbnail()
        cachedPredictions = predictions.filter { $0 != nil } as! [PredictionRowViewModel]
        cachedPredictions.forEach { predictionsSubject.onNext($0) }
        predictionsSubject.onCompleted()
    }

    func calculate() {
        generateThumbnail()

        let classificationPromise = Promise<FriendlyClassification> {
            self.predictor.classify(image: self.image)
        }

        let predictionPromises = all(on: DispatchQueue.global(qos: .utility), [
            predictor.predictPromise(image: image, strategy: SinglesPredictionStrategy()),
            predictor.predictPromise(image: image, strategy: TensPredictionStrategy()),
            predictor.predictPromise(image: image, strategy: HundredsPredictionStrategy())
        ])

        all(on: DispatchQueue.global(qos: .utility), classificationPromise, predictionPromises).then { (tuple) in
            let (cl, ps) = tuple
            let predictionMap = Dictionary(uniqueKeysWithValues: ps.map { ($0.name, $0)})
            self.publishPredictions(cl, predictionMap)
        }
    }

    private func publishPredictions(_ classification: FriendlyClassification, _ predictionMap: [String: FriendlyPrediction]) {
        let sortedPredictions: [PredictionRowViewModel?] = classification.observations.map { obs in
            guard let prediction = predictionMap[obs.identifier] else {
                return nil
            }

            return PredictionRowViewModel.from(prediction, obs.confidence)
        }

        cachedPredictions = sortedPredictions.filter { $0 != nil } as! [PredictionRowViewModel]
        cachedPredictions.forEach { predictionsSubject.onNext($0) }
        predictionsSubject.onCompleted()
        savePredictions(cachedPredictions)
    }

    private func savePredictions(_ predictions: [PredictionRowViewModel]) {
        let predictionModel = PredictionAnalysisModel.from(image, predictions: predictions)
        analysisId = predictionModel.id
        let realm = try! Realm()
        print("Saving prediction model to realm")
        try! realm.write {
            realm.add(predictionModel)
        }
    }

    func upload() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(analysisId!)/")

        uploadImage(storageRef, "Original", image)
        cachedPredictions.forEach { $0.upload(storageRef) }
    }

    func uploadImage(_ storageRef: StorageReference, _ label: String, _ image: UIImage) {
        let imageRef = storageRef.child("\(label).jpg")

        guard let data = image.jpegData(compressionQuality: 1) else {
            print("Unable to retrieve image data for upload")
            return
        }

        _ = imageRef.putData(data, metadata: nil) { (_, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Unable to retrieve image download url", error)
                    return
                }
                print("Image uploaded to \(downloadURL)")
            }
        }
    }

    private func generateThumbnail() {
        DispatchQueue.global().async {
            guard let thumbnail = self.image.resizeImageFit(StyleGuide.thumbnailSize) else {
                print("Unable to generate thumbnail")
                self.thumbnailSubject.onError(CCError.runtimeError("Unable to generate thumbnail"))
                return
            }

            self.thumbnailSubject.onNext(thumbnail)
            self.thumbnailSubject.onCompleted()
        }
    }
}
