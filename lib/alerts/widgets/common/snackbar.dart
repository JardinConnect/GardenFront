import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'dart:math' as math;

/// Gestionnaire de toasts empilables (max 3 simultanés)
class _ToastManager {
  static final _ToastManager instance = _ToastManager._();
  _ToastManager._();

  final List<OverlayEntry> _entries = [];
  static const int _maxToasts = 3;
  static const double _toastHeight = 80.0;
  static const double _gap = 8.0;
  static const double _bottomBase = 20.0;

  void show(BuildContext context, Widget toast, Duration duration) {
    // Si on a déjà 3 toasts, on supprime le plus ancien
    if (_entries.length >= _maxToasts) {
      _removeAt(0);
    }

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder:
          (_) => _PositionedToast(
            index: _entries.indexOf(entry),
            toastHeight: _toastHeight,
            gap: _gap,
            bottomBase: _bottomBase,
            child: toast,
          ),
    );

    _entries.add(entry);
    Overlay.of(context).insert(entry);

    // Recalculer les positions
    _rebuildAll();

    Future.delayed(duration, () => _remove(entry));
  }

  void _remove(OverlayEntry entry) {
    if (_entries.contains(entry)) {
      _entries.remove(entry);
      entry.remove();
      _rebuildAll();
    }
  }

  void _removeAt(int index) {
    if (index < _entries.length) {
      final entry = _entries[index];
      _entries.removeAt(index);
      entry.remove();
    }
  }

  void _rebuildAll() {
    for (final e in _entries) {
      e.markNeedsBuild();
    }
  }
}

class _PositionedToast extends StatelessWidget {
  final int index;
  final double toastHeight;
  final double gap;
  final double bottomBase;
  final Widget child;

  const _PositionedToast({
    required this.index,
    required this.toastHeight,
    required this.gap,
    required this.bottomBase,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetWidth = math.min(360.0, screenWidth * 0.4);
    final rightMargin = 20.0;
    final bottom = bottomBase + index * (toastHeight + gap);

    return Positioned(
      bottom: bottom,
      right: rightMargin,
      width: targetWidth,
      child: Material(color: Colors.transparent, child: child),
    );
  }
}

/// Affiche un message de succès dans une notification toast
void showSnackBarSucces(BuildContext context, String message) {
  _ToastManager.instance.show(
    context,
    NotificationToast(
      title: 'Succès',
      message: message,
      size: NotificationSize.md,
      severity: NotificationSeverity.success,
    ),
    const Duration(seconds: 4),
  );
}

/// Affiche un message d'erreur dans une notification toast
void showSnackBarError(BuildContext context, String message) {
  _ToastManager.instance.show(
    context,
    NotificationToast(
      title: 'Erreur',
      message: message,
      size: NotificationSize.md,
      severity: NotificationSeverity.warning,
    ),
    const Duration(seconds: 5),
  );
}
