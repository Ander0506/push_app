import 'package:flutter_local_notifications/flutter_local_notifications.dart'; 

class LocalNotidications {

  static Future<void> requestPermissionLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> initializeLocalNotifications() async {

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    //TODO ios configuration

    const initializationSetting = InitializationSettings(
      android: initializationSettingsAndroid
      //TODO ios configuration setting
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting
    );

  }

  static void showLocalNotificaion({
    required int id,
    String? title,
    String? body,
    String? data,
  }){

    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      //TODO IOS
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails, payload: data);
  }
}