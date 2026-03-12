import 'package:flutter/material.dart';

/// En-tête de page réutilisable avec un titre optionnel et des boutons d'action optionnels.
///
/// Inclut un padding vertical (top: 16, bottom: 24) intégré.
/// Affiche un titre à gauche (si fourni) et une liste de widgets d'action à droite,
/// séparés par un espacement de 8px.
class PageHeader extends StatelessWidget {
  /// Le titre affiché à gauche de l'en-tête (optionnel).
  final String? title;

  /// Liste optionnelle de widgets d'action affichés à droite (boutons, icônes, etc.).
  final List<Widget> actions;

  const PageHeader({
    super.key,
    this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null)
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          if (actions.isNotEmpty)
            Row(
              spacing: 8,
              children: actions,
            ),
        ],
      ),
    );
  }
}
