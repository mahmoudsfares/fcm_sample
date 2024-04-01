# fcm_sample

Send a notification to both Android and iOS.

## Getting Started

* follow the numbered todos for a step-by-step guidance.. there are ones in AndroidManifest.xml, AppDelegate.swift & info.plist but might not show up in the todos tab.. make sure to check them out.
* the app contains 3 screens: home, second, and notification data
* home: can work as a first screen with the ability to navigate to the second one via a button and can work as a splash screen.. follow the TODOs without numbers to change the purpose
* second: the screen that shows after home
* notification data: shows only when a notification is tapped to display the payload data
* the sample is designed to receive the notification payload as follows:
{
  "to": "FCM_TOKEN",
  "notification": {
    "sound": "default",
    "title": "Goal!",
    "body": "Leicester 1 - 0 Coventry"
  },
  "data": {
    "text": "Jamie Vardy, 81"
  }
}
* the notification is rigid and can't be changed it must have the value of sound as default, the title and body values can be changed but not the keys
* data is a map and can be changed to suit the required payload data but the notification data screen should be changed according to the structure of data
* follow the FCM documentations to setup firebase and FCM correctly, pay attention specifically to apple developer account settings
* notifications don't work on iOS simulators and aren't stable on Android emulators.. better test on real devices
* old android versions might not show a banner
* follow this to see the various methods for sending a test notification.. but make sure to stick to the structure mentioned above: https://apoorv487.medium.com/testing-fcm-push-notification-through-postman-terminal-part-1-5c2df94e6c8d



