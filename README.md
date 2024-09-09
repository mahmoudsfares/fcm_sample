# fcm_sample

Send a notification to both Android and iOS.

## Getting Started

* follow the numbered todos for a step-by-step guidance.. there are ones in AndroidManifest.xml, AppDelegate.swift & info.plist but might not show up in the todos tab.. make sure to check them out.
* the app contains 3 screens: home, second, and notification data
* home: can work as a first screen with the ability to navigate to the second one via a button and can work as a splash screen.. follow the TODOs without numbers to change the purpose
* second: the screen that shows after home
* notification data: shows only when a notification is tapped to display the payload data
* the sample is designed to receive the notification payload as follows:
```json
{
  "message": {
    "token": "FCM_TOKEN",
    "notification": {
      "title": "Goal!",
      "body": "Leicester 1 - 0 Coventry"
    },
    "data": {
      "text": "Jamie Vardy, 81",
      "keysAndValues": "{\"key1\": \"value1\", \"key2\": 123}"
    }
  }
}
```
* the notification is rigid and can't be changed it must have the value of sound as default, the title and body values can be changed but not the keys
* data is a map of string, if you have a nested JSON  you need to expect an escaped characters as implemented for "keysAndValues", you can parse it later in your flutter app to remove the escape characters by using
```dart
yourNestedJsonString.replaceAll(r'\"', '"');
```
* data can be changed to suit the required payload data but the notification data screen should be changed according to the structure of data
* follow the FCM documentations to setup firebase and FCM correctly, pay attention specifically to apple developer account settings
* notifications don't work on iOS simulators and aren't stable on Android emulators.. better test on real devices
* old android versions might not show a banner
* follow this to see the various methods for sending a test notification.. but make sure to stick to the structure mentioned above: https://apoorv487.medium.com/testing-fcm-push-notification-through-postman-terminal-part-1-5c2df94e6c8d (This is a legacy FCM APIs you need to migrate to HTTP v1 as mentioned below)


## Migrate from legacy FCM APIs to HTTP v1 Guide

### Why you need to Migrate?
* FCM will start a gradual shutdown of deprecated APIs around July 22nd, 2024. After this date, deprecated services will be subject to a "flickering" process in which increasing numbers of requests will return error responses.

### Steps
* Instead of a POST request to https://fcm.googleapis.com/fcm/send, make a POST request to https://fcm.googleapis.com/v1/projects/myproject-ID/messages:send This myproject-ID is available in the General project settings tab of the Firebase console.
* Server key is removed from firebase console, you don't need to send it in Authorization header as [Authorization : key = <server_key>] anymore
* Instead of Server key, you need to send OAuth 2.0 token as [Authorization: Bearer <valid Oauth 2.0 token>], It needs to be generated continuously because it continuously expires.
* To generate this OAuth 2.0 token, Postman manages its integration, After adding the above url to a POST request, go to Authorization section and choose Firebase cloud messaging API then click on the Authorize button
* Or to generate this OAuth 2.0 token using flutter [not required], you can follow the 5 Migration TODOs steps in the migrate-legacy-fcm-apis-to-http-v1 branch

For more info check https://firebase.google.com/docs/cloud-messaging/migrate-v1

