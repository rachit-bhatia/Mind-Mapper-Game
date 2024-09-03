# Mind-Mapper-Game
An iOS Swift Playgrounds app that features the detection of actions performed by the user, in the fashion of a twisted memory game where users memorize a set of hand poses and perform them. In each level, users are given a set of emojis, each of which symbolises a particular hand pose. The difficulty gets harder as the levels progress since the users need to memorise a jumbled set of emojis to show the correct hand poses. 
- SwiftUI and UIKit have been used to make the UI of the entire application
- A live camera feed has been setup using AVFoundation to capture user inputs
- Utilised the [Vision framework's](https://developer.apple.com/documentation/vision/) VNDetectHumanHandPoseRequest and VNRecognizedPoint for hand pose detection. Implemented logic to verify the difference between finger points to a set threshold, in order to recognize hand poses.

## App Samples:
<div style={{display: "flex", flexDirection: "row"}}>
<img src="https://github.com/rachit-bhatia/Mind-Mapper-Game/blob/main/SS_imgs/howToPlay.jpg" width="300" height="400"/> 
<img src="https://github.com/rachit-bhatia/Mind-Mapper-Game/blob/main/SS_imgs/level1.jpg" width="300" height="400"/> 
<img src="https://github.com/rachit-bhatia/Mind-Mapper-Game/blob/main/SS_imgs/level2.jpg" width="300" height="400"/> 
</div>
