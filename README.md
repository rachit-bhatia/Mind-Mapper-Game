# Mind-Mapper-Game
An iOS Swift Playgrounds app that features the detection of hand actions performed by the user, in the fashion of a twisted memory game where users memorize a set of hand poses and perform them. 

### Features
- In each level, users are given a set of numbers that they need to memorize and show using their hand 
- The difficulty gets harder as the levels progress since the users need to memorize a jumbled set of emojis to show the correct hand poses 

### Technologies Used
- SwiftUI and UIKit have been used to make the UI of the entire application
- A live camera feed has been set up using AVFoundation to capture user inputs
- Utilised the [Vision framework's](https://developer.apple.com/documentation/vision/) VNDetectHumanHandPoseRequest and VNRecognizedPoint for hand pose detection. Implemented logic to verify the difference between finger points to a set threshold, in order to recognize hand poses.

### Running the project
Open the .swiftpm file in Xcode on MacOS and select the target simulator as an iPhone model

## App Samples:
<div style={{display: "flex", flexDirection: "row"}}>
<img src="https://github.com/rachit-bhatia/Mind-Mapper-Game/blob/main/SS_imgs/howToPlay.jpg" width="200" height="300"/> 
<img src="https://github.com/rachit-bhatia/Mind-Mapper-Game/blob/main/SS_imgs/level1.jpg" width="200" height="300"/> 
<img src="https://github.com/rachit-bhatia/Mind-Mapper-Game/blob/main/SS_imgs/level2.jpg" width="200" height="300"/> 
</div>
