import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'dart:math' as math;

/// Gestionnaire de toasts empilables (max 3 simultanés)
class _ToastManager {
  static final _ToastManager instance = _ToastManager._();
  _ToastManager._();

  // Chaque entrée stocke l'OverlayEntry et un ValueNotifier pour son index
  final List<({OverlayEntry entry, ValueNotifier<int> indexNotifier})> _toasts = [];
  static const int _maxToasts = 3;
  static const double _toastHeight = 80.0;
  static const double _gap = 8.0;
  static const double _bottomBase = 20.0;

  void show(BuildContext context, Widget toast, Duration duration) {
    // Supprime le plus ancien si on dépasse le max
    if (_toasts.length >= _maxToasts) {
      _removeAt(0);
    }

    final indexNotifier = ValueNotifier<int>(_toasts.length);

    final entry = OverlayEntry(
      builder: (_) => _PositionedToast(
        indexNotifier: indexNotifier,
        toastHeight: _toastHeight,
        gap: _gap,
        bottomBase: _bottomBase,
        child: toast,
      ),
    );

    _toasts.add((entry: entry, indexNotifier: indexNotifier));
    Overlay.of(context).insert(entry);

    // Met à jour les index sans markNeedsBuild
    _updateIndexes();

    Future.delayed(duration, () => _remove(entry));
  }

  void _remove(OverlayEntry entry) {
    final idx = _toasts.indexWhere((t) => t.entry == entry);
    if (idx != -1) {
      _toasts[idx].indexNotifier.dispose();
      _toasts.removeAt(idx);
      entry.remove();
      _updateIndexes();
    }
  }

  void _removeAt(int index) {
    if (index < _toasts.length) {
      final t = _toasts[index];
      _toasts.removeAt(index);
      t.indexNotifier.dispose();
      t.entry.remove();
    }
  }

  // Met à jour les ValueNotifiers sans forcer un rebuild de l'OverlayEntry
  void _updateIndexes() {
    for (var i = 0; i < _toasts.length; i++) {
      _toasts[i].indexNotifier.value = i;
    }
  }
}

class _PositionedToast extends StatelessWidget {
  final ValueNotifier<int> indexNotifier;
  final double toastHeight;
  final double gap;
  final double bottomBase;
  final Widget child;

  const _PositionedToast({
    required this.indexNotifier,
    required this.toastHeight,
    required this.gap,
    required this.bottomBase,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetWidth = math.min(360.0, screenWidth * 0.4);
    const rightMargin = 20.0;

    // ValueListenableBuilder réagit aux changements d'index sans rebuild de l'OverlayEntry
    return ValueListenableBuilder<int>(
      valueListenable: indexNotifier,
      builder: (_, index, __) {
        final bottom = bottomBase + index * (toastHeight + gap);
        return Positioned(
          bottom: bottom,
          right: rightMargin,
          width: targetWidth,
          child: Material(color: Colors.transparent, child: child),
        );
      },
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
