import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/alerts/bloc/alert_bloc.dart';
import 'package:garden_connect/mobile/alerts/services/mobile_alert_notification_service.dart';

class MobileAlertSseNotificationsListener extends StatefulWidget {
  final Widget child;

  const MobileAlertSseNotificationsListener({super.key, required this.child});

  @override
  State<MobileAlertSseNotificationsListener> createState() =>
      _MobileAlertSseNotificationsListenerState();
}

class _MobileAlertSseNotificationsListenerState
    extends State<MobileAlertSseNotificationsListener> {
  String? _lastNotifiedEventId;

  @override
  void initState() {
    super.initState();
    MobileAlertNotificationService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlertBloc, AlertState>(
      listenWhen: (previous, current) {
        if (current is! AlertLoaded) return false;
        if (previous is! AlertLoaded) {
          return current.latestSSEAlertEvent != null;
        }

        return current.latestSSEAlertEvent != null &&
            current.latestSSEAlertEvent != previous.latestSSEAlertEvent;
      },
      listener: (context, state) {
        if (state is! AlertLoaded) return;
        final event = state.latestSSEAlertEvent;
        if (event == null) return;

        if (_lastNotifiedEventId == event.id) {
          context.read<AlertBloc>().add(const AlertSSEClearNotification());
          return;
        }

        _lastNotifiedEventId = event.id;
        MobileAlertNotificationService.instance.showAlertEventNotification(
          event,
        );
        context.read<AlertBloc>().add(const AlertSSEClearNotification());
      },
      child: widget.child,
    );
  }
}
