import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNoticeService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final LocalNoticeService _notificationService =
      LocalNoticeService._internal();

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = DarwinInitializationSettings();

    const initSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

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

    const id = 0;

    await _localNotificationsPlugin.show(id, title, body, noticeDetail,
        payload: 'Default_Sound');
  }

  void cancelAllNotification() {
    _localNotificationsPlugin.cancelAll();
  }
}
