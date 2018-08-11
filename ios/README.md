# Overview

The Apple CoreML can be divided into two implementations:

1. macOS Prediction Playground
2. iOS Crowd Counting Application

## macOS Prediction Playground

![MacOS Prediction Playground](readmeimages/CountPlayground.jpg)

Ability to drag and drop an image to see the results of different prediction strategies.

## iOS Crowd Counting

![iOS Development](readmeimages/CountiOsDevelopment.jpg)

![iOS App In Action](readmeimages/CrowdCountiOS.gif)

### iOS todo

- [x] pause frame extraction when swiping off the camera VC
- [x] Make image frame extractor for simulator
- [x] Make video frame extractor for simulator
- [x] send correct orientation. I hardcode to .portrait
- [x] add swiftlinter and run autolint
- [x] Redo Duration to be thread safe
- [x] Add duration to the classification and count labels
- [x] Have previous classification and count to the left in gray to show that it’s working over time. (Just have a second set of labels in gray to the left)
- [x] clean up **FriendlyPredictor** to only use Apple VN libraries instead of hand rolled image manipulators (look for speed increase) (**VNCoreMLFeatureValueObservation**)
- [x] Have to stop initializing predictors in strategies every prediction as optimization
- [x] Investigate why classification causes camera jitters (Contention for GPU. Thanks Create ML?)
- [x] ability to take photo to trigger prediction and segue to show page (WITH BUTTON)
- [x] ability to see list of predictions (using realm)
- [x] Upload photo/prediction if it was wrong
- [x] Add some tests
- [x] Release v0.1
- [ ] Allow users to select correct classification to help model training
- [ ] Ability to select a photo from the library and segue to show page
- [ ] Have previous prediction preview and count “roll” to the left to imply that it’s working over time. (ANIMATION)

## Setup

1. Use Xcode 10+ for Swift 4.2, and macOS Mojave for Core ML 2 and Create ML.
2. Install carthage.
3. `carthage update --platform ios,macos` or `carthage bootstrap`.
4. Build CrowdCount. For Prediction.playground, explicitly build the libraries CrowdCountApi and CrowdCountApiMac.
5. For iOS app, use [Google Firebase](https://firebase.google.com/) to create a standard bare bones `GoogleService-Info.plist`
or just delete the file `GoogleService-Info.plist` from Xcode. Used for image upload on request.
