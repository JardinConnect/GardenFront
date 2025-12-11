import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/components.dart';
import 'dart:math' as math;

void showSnackBarSucces(BuildContext context, String message) {
  final media = MediaQuery.of(context).size;
  final screenWidth = media.width;
  final screenHeight = media.height;

  final double targetWidth = math.min(360.0, screenWidth * 0.4);
  final double rightMargin = 20.0;
  final double left = math.max(16.0, screenWidth - targetWidth - rightMargin);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: NotificationToast(
        title: 'Succès',
        message: message,
        size: NotificationSize.md,
        severity: NotificationSeverity.success,
      ),
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: 20,
        right: rightMargin,
        left: left,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
