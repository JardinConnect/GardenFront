import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Dialogue générique avec une bannière header colorée
class StyledDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final double widthFactor;
  final bool dismissible;
  final String? imagePath;
  final List<Widget>? actions;
  final Color? headerColor;
  final Color? headerForegroundColor;

  const StyledDialog({
    super.key,
    required this.title,
    required this.content,
    this.widthFactor = 1,
    this.dismissible = true,
    this.imagePath,
    this.actions,
    this.headerColor,
    this.headerForegroundColor,
  });

  /// Affiche la dialog de manière statique.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    double widthFactor = 0.65,
    bool dismissible = true,
    String? imagePath,
    List<Widget>? actions,
    Color? headerColor,
    Color? headerForegroundColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => StyledDialog(
        title: title,
        content: content,
        widthFactor: widthFactor,
        dismissible: dismissible,
        imagePath: imagePath,
        actions: actions,
        headerColor: headerColor,
        headerForegroundColor: headerForegroundColor,
      ),
    );
  }

  Widget _buildImage(double maxWidth) {
    final isSvg = imagePath!.toLowerCase().endsWith('.svg');
    final double height = maxWidth * 0.55;
    if (isSvg) {
      return SizedBox(
        width: maxWidth,
        height: height,
        child: SvgPicture.asset(
          imagePath!,
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        ),
      );
    }
    return SizedBox(
      width: maxWidth,
      height: height,
      child: Image.asset(
        imagePath!,
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dialogMaxWidth = MediaQuery.of(context).size.width * widthFactor;
    final dialogMaxHeight = MediaQuery.of(context).size.height * 0.65;

    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Material(
        color: Colors.transparent,
        borderRadius: GardenRadius.radiusLg,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: dialogMaxWidth, maxHeight: dialogMaxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                color: headerColor ?? colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: headerForegroundColor ?? colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (dismissible)
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: headerForegroundColor ?? colorScheme.onPrimary,
                        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                      ),
                  ],
                ),
              ),
              // Body
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    color: colorScheme.surface,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            top: 14,
                            right: 14,
                          ),
                          child: content,
                        ),
                        if (imagePath != null)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final w = constraints.maxWidth.isFinite
                                  ? constraints.maxWidth
                                  : dialogMaxWidth;
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                child: _buildImage(w - 28),
                              );
                            },
                          ),
                        if (imagePath == null)
                          const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),
              if (actions != null)
                Container(
                  color: colorScheme.surface,
                  padding: const EdgeInsets.all(14),
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: GardenSpace.gapSm,
                      children: actions!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

