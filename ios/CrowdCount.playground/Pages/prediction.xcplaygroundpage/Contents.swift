//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import CrowdCountApi

class MyViewController : UIViewController {
    override func loadView() {
        let predictor = FriendlyPredictor()
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        let imagePath = Bundle.main.path(forResource: "CrowdCount", ofType: "jpg")!
        let image = UIImage(contentsOfFile: imagePath)!
        let prediction = predictor.predict(image: image)
        label.text = "Hello World!" + String(format:"%f", prediction)
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
