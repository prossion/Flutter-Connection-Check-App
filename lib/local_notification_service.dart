import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNoticeService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // Singleton of the LocalNoticeService
  static final LocalNoticeService _notificationService =
      LocalNoticeService._internal();

  Future<void> setup() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = DarwinInitializationSettings();

    // #2
    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    // #3
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  factory LocalNoticeService() {
    return _notificationService;
  }
  LocalNoticeService._internal();

  Future<void> addNotification(
    String title,
    String body, {
    String sound = '',
    String channel = 'default',
  }) async {
    // #1

// #2
    final androidDetail = AndroidNotificationDetails(
        channel, // channel Id
        channel // channel Name
        );

    const iosDetail = DarwinNotificationDetails();

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: AndroidNotificationDetails(
        channel,
        title,
        icon: "@mipmap/ic_launcher",
        priority: Priority.max,
        importance: Importance.max,
        enableVibration: true,
      ),
    );

// #3
    const id = 0;

// #4
    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      noticeDetail,
    );
  }

  void cancelAllNotification() {
    _localNotificationsPlugin.cancelAll();
  }
}
