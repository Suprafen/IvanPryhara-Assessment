# IvanPryhara-Assessment

Code in this repository represents an implementation of technical assessment by leveraging corresponding VideoAPI.

## Architecture

In order to avoid complexity and take advantage of latest Apple's technologies Observation framework was employed, to 
ensure effective view redraws and avoid writing boilerplate(which was required to write when ObservableObject protocol was used).

The main idea in this architecture to rely on a different states that are changed in response to callbacks inside of implementation of `VideoManager`.
Even though this approach is not usually considered as scalable, it remains a good choice in case of need to implement fast POC, such as this assessment.

## App structure
The main business logic is implemented inside `VideoManager`. As well as the changes to the state, which UI depends on.

### UI
App consists of one main screen – `StartScreen`, which shows user different states of the app. And `VideoCallView` – the view that has Your video stream and the(optional) stream of participant of the call, 
in addition to control buttons: video enabled/disable, audio muted/unmuted, disconnect from the session.
  

## Minimal requriements
- Minimal deployment target is iOS 26, however it can be downgraded to iOS 17.

The only thing that prevents us from using iOS 15 as minimal deployment target is usage of `Observation` framework. The same effect could be achieved by using `ObservableObject` which would allow to use iOS 15.
- Application was built using Xcode 26.1

## How to test the app?

- Open Video API playground and connect to the session.

- Provide app id, session id and token inside `VideoManager`.

- Build the project.

- Specify, by toggling, whether You want Your audio and video to be enabled and select `Start a call` button.

App should start connecting to the session. Depending on whether participant from Video API playground started the stream, you will see Your video stream(or a placeholder in case of video is disabled) and(optionally) Your participant stream.
