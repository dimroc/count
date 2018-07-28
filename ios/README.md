# Overview

The Apple CoreML can be divided into two implementations:

1. macOS Prediction Playground
2. iOS Crowd Counting Application

## macOS Prediction Playground

![MacOS Prediction Playground](readmeimages/CountPlayground.jpg)

Ability to drag and drop an image to see the results of different prediction strategies.

## iOS Crowd Counting

Coming soon.

![iOS Development](readmeimages/CountiOsDevelopment.jpg)

### iOS todo

- [x] pause frame extraction when swiping off the camera VC
- [x] Make image frame extractor for simulator
- [x] Make video frame extractor for simulator
- [x] send correct orientation. I hardcode to .portrait
- [x] add swiftlinter and run autolint
- [x] Redo Duration to be thread safe
- [x] Add duration to the classification and count labels
- [x] Have previous classification and count to the left in gray to show that it’s working over time. (Just have a second set of labels in gray to the left)
- [x] clean up **FriendlyPredictor** to only use Apple VN libraries instead of hand rolled image manipulators (look for speed increase) (**VNCoreMLFeatureRequest**)
- [x] Have to stop initializing predictors in strategies every prediction as optimization
- [ ] Investigate why classification causes camera jitters (Thanks Create ML?)
- [ ] ability to take photo, trigger prediction and segue to show page (WITH BUTTON)
- [ ] ability to see list of predictions
- [ ] Upload photo/prediction if it was wrong
- [x] Add some tests
- [ ] Release v0.1?
- [ ] Ability to select a photo from the library and segue to show page
- [ ] Have previous prediction preview and count “roll” to the left to imply that it’s working over time. (ANIMATION)

## Setup

1. Use Xcode 10+
2. Install carthage
3. carthage bootstrap
4. Build every target, including CrowdCountApi and CrowdCountApiMac
