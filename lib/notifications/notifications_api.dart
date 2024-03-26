import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

// TODO: uncomment this to receive data payload
@pragma('vm:entry-point')
Future<void> handleMessage(RemoteMessage firebaseRemoteMessage) async {
  final Map<String, dynamic> data = firebaseRemoteMessage.data;
  NotificationsApi._triggerNotification(
    firebaseRemoteMessage.hashCode,
    data['title'],
    data['body'],
    payload: data['payload'],
  );
}

// TODO: uncomment this to receive notification payload
// @pragma('vm:entry-point')
// Future<void> handleMessage(RemoteMessage firebaseRemoteMessage) async {
//   final RemoteNotification? data = firebaseRemoteMessage.notification;
//   if(data == null) return;
//   NotificationsApi._triggerNotification(
//     firebaseRemoteMessage.hashCode,
//     data.title!,
//     data.body!,
//     payload: null,
//   );
// }

class NotificationsApi {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final StreamController<String> notificationStream = StreamController<String>();
  static void onTapNotification(NotificationResponse response) => notificationStream.add(response.payload!);

  static Future<void> initNotifications() async {
    final String? FCMToken = await _firebaseMessaging.getToken();
    print('Token: $FCMToken');
    _initLocalNotifications();
    _initFCMNotifications();
  }

  static Future<void> _initFCMNotifications() async {
    FirebaseMessaging.onBackgroundMessage(handleMessage);
    FirebaseMessaging.onMessage.listen(handleMessage);
  }

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

  static Future<bool> _checkNotificationsPermission() async {
    if (Platform.isAndroid && await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      if (status.isDenied) {
        Fluttertoast.showToast(msg: 'You have to accept push notifications permission');
        return false;
      }
    }
    return true;
  }
}
