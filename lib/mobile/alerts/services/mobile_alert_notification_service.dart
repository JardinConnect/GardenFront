import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garden_connect/alerts/models/alert_models.dart';

class MobileAlertNotificationService {
  MobileAlertNotificationService._();

  static final MobileAlertNotificationService instance =
      MobileAlertNotificationService._();

  static const String _androidChannelId = 'garden_alert_events';
  static const String _androidChannelName = 'Alertes capteurs';
  static const String _androidChannelDescription =
      'Notifications temps reel des alertes';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  int _nextNotificationId = 0;

  Future<void> init() async {
    if (_initialized || kIsWeb) return;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
        defaultPresentBanner: true,
        defaultPresentList: true,
      ),
    );

    await _plugin.initialize(settings);

    final androidImplementation =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> showAlertEventNotification(AlertEvent event) async {
    await init();

    final isCritical = event.severity == 'critical';
    final title = isCritical ? 'Alerte critique' : 'Avertissement';
    final body = '${event.cellName} - ${event.alertTitle}';

    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      category: AndroidNotificationCategory.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    await _plugin.show(
      _consumeNotificationId(),
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: event.id,
    );
  }

  int _consumeNotificationId() {
    _nextNotificationId = (_nextNotificationId + 1) % 2147483647;
    return _nextNotificationId;
  }
}
