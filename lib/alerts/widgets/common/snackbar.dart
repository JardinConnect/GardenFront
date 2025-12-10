import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

void showSnackBarSucces(BuildContext context, String message) {
  final screenWidth = MediaQuery.of(context).size.width;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: GardenColors.tertiary.shade700, // Personnalise selon ton design
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(
        bottom: 20,
        right: 20,
        left: screenWidth - 320, // SnackBar de 300px de largeur
      ),
    ),
  );
}
