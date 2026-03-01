import 'package:flutter/material.dart';

/// Dialogue générique avec une bannière header colorée
class StyledDialog extends StatelessWidget {
  /// Titre affiché dans la bannière
  final String title;

  /// Contenu affiché sous la bannière
  final Widget content;

  /// Largeur maximale de la dialog (en fraction de l'écran, ex: 0.5)
  final double widthFactor;

  /// Hauteur maximale de la dialog (en fraction de l'écran). Null = automatique.
  final double? heightFactor;

  /// Affiche ou non le bouton de fermeture dans la bannière
  final bool dismissible;

  /// Padding interne de la zone contenu
  final EdgeInsets contentPadding;

  const StyledDialog({
    super.key,
    required this.title,
    required this.content,
    this.widthFactor = 0.5,
    this.heightFactor,
    this.dismissible = true,
    this.contentPadding = const EdgeInsets.all(16),
  });

  /// Affiche la dialog de manière statique.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    double widthFactor = 0.5,
    double? heightFactor,
    bool dismissible = true,
    EdgeInsets contentPadding = const EdgeInsets.all(16),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => StyledDialog(
        title: title,
        content: content,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        dismissible: dismissible,
        contentPadding: contentPadding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [content],
    );

    if (heightFactor != null) {
      body = SizedBox(
        height: MediaQuery.of(context).size.height * heightFactor!,
        child: body,
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      title: Container(
        color: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (dismissible)
              IconButton(
                icon: const Icon(Icons.close_rounded),
                color: colorScheme.onPrimary,
                onPressed: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
      content: Padding(
        padding: contentPadding,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * widthFactor,
          child: body,
        ),
      ),
    );
  }
}

