import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('here i am');
}

class FirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    final String? FCMToken = await _firebaseMessaging.getToken();
    print('Token: $FCMToken');
    initPushNotifications();
    initLocalNotifications();
  }

  static Future initPushNotifications() async {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) {
        return;
      }
      triggerNotification(notification);
    });
  }

  static Future initLocalNotifications() async {
    const ios = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: bg,
    );
  }

  static void bg(NotificationResponse? response) {
    int i = 0;
  }

  static Future<void> triggerNotification(RemoteNotification notification) async {
    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'this channel is used for important notifications',
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

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}
