import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await initialize();
    return await _plugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        true;
  }

  Future<void> show({required int id, required String title, required String body}) async {
    await initialize();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminders',
        'التذكيرات',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(id: id, title: title, body: body, notificationDetails: details);
  }
}
