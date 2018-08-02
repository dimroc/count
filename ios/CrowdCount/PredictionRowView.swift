//
//  PredictionRowView.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 8/2/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PredictionRowView: UIStackView {
    required init(viewModel: PredictionRowViewModel) {
        super.init(frame: CGRect.zero)

        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        spacing = 0

        let classificationLabel = UILabel()
        classificationLabel.h3().centerTextAlignment().dark()
        classificationLabel.text = viewModel.classification
        addArrangedSubview(classificationLabel)

        let probabilityLabel = UILabel()
        probabilityLabel.h3().centerTextAlignment().dark()
        probabilityLabel.text = String(format: "%.1f%% likely", viewModel.probability * 100)
        addArrangedSubview(probabilityLabel)

        let countLabel = UILabel()
        countLabel.h3().centerTextAlignment().dark()
        countLabel.text = String(format: "%.1f people", viewModel.count)
        addArrangedSubview(countLabel)

        let durationLabel = UILabel()
        durationLabel.h4().centerTextAlignment().dark()
        durationLabel.text = "\(String(format: "%.1f", viewModel.duration)) secs"
        addArrangedSubview(durationLabel)

        let imageView = UIImageView()
        imageView.image = viewModel.insight
        addArrangedSubview(imageView)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
