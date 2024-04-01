import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsApi {
  // TODO 8: keep an instance of Firebase messaging and create a getter for the initial message
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // accessed by the first screen to get the message data
  static Future<RemoteMessage?> get initialMessage async => await _firebaseMessaging.getInitialMessage();

  // TODO 9: create an instance of the local notifications plugin.. it is used to initialize and show push notifications on demand
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // TODO 10: create a stream and use it to listen to the newly triggered notifications to pass the payload to it
  static final StreamController<String> notificationStream = StreamController<String>();
  static void onTapNotification(NotificationResponse response) => notificationStream.add(response.payload!);

  // TODO 11: this method will be called on app start to initialize notifications
  static Future<void> initNotifications() async {
    final String? FCMToken = await _firebaseMessaging.getToken();
    print('Token: $FCMToken');
    _initLocalNotifications();
    _initFCMNotifications();
  }

  // TODO 12: initialize local push notifications by defining the settings for each platform
  static Future<void> _initLocalNotifications() async {
    if (!(await _checkNotificationsPermission())) return;
    DarwinInitializationSettings iOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    AndroidInitializationSettings android = const AndroidInitializationSettings('@drawable/ic_launcher');
    InitializationSettings initSettings = InitializationSettings(android: android, iOS: iOS);
    await localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onTapNotification,
      onDidReceiveBackgroundNotificationResponse: onTapNotification,
    );
  }

  // TODO 13: check notification permission to request it if it isn't granted
  static Future<bool> _checkNotificationsPermission() async {
    if (await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      if (status.isDenied) {
        Fluttertoast.showToast(msg: 'You have to accept push notifications permission');
        return false;
      }
    }
    return true;
  }

  // TODO 14: initialize firebase notifications by listening to the foreground ones and defining what to do when a foreground one is received
  static Future<void> _initFCMNotifications() async {
    // this listener is for foreground messages, background messages are created automatically
    FirebaseMessaging.onMessage.listen(handleMessage);
  }

  // TODO 15: this will be invoked when an fcm is received in the foreground
  static Future<void> handleMessage(RemoteMessage firebaseRemoteMessage) async {
    final RemoteNotification? notification = firebaseRemoteMessage.notification;
    if(notification == null) return;
    NotificationsApi._triggerNotification(
      firebaseRemoteMessage.hashCode,
      notification.title!,
      notification.body!,
      payload: jsonEncode(firebaseRemoteMessage.data),
    );
  }

  // TODO 16: define the notification details and trigger it upon request
  static Future<void> _triggerNotification(int id, String title, String body, {String? payload}) async {
    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'this channel is used for important notifications',
      importance: Importance.high,
      icon: '@drawable/ic_launcher',
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      threadIdentifier: 'high_importance_channel',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentList: true,
      presentBanner: true,
    );

    await localNotificationsPlugin.show(
      id,
      title,
      body,
      payload: payload,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}
