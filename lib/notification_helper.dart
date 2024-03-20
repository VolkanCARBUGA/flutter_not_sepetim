import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  var flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  

  initNotification()async{
    var initializationSettingsAndroid=AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS=DarwinInitializationSettings();
  
    var initializationSettings=InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS,macOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }
   Future<void> showNotification({ required  String title, required String body}) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
     0, // notification id
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
  
  
}