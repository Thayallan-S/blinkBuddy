# BlinkBuddy

## What is BlinkBuddy ?
BlinkBuddy is an iOS Application that allows ALS patients an general users to leverage their ability to blink in order to communicate and do certain things such as send a help message, opening and closing a door and a hybrid morse code communication method.

## Technology
The app uses Apples new ARKit 2 in order to identify blinking specific to either the left eye or right eye. There is a Twilio API integration inorder for users to receive a help message if the patient decides to trigger it. It also has been paired with an Arduino which is programmed to receive commands from the client. The arduino is connected to an LCD display and a servo motor which displays letter the patient blinks out or opens and closes a door.

## Working On
Currently working on improving the morse code detection to identify the blinking better in order to improve the user experience.
