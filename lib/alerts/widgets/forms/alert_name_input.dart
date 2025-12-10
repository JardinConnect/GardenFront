import 'package:flutter/material.dart';

/// Widget de saisie du nom d'une alerte
/// Permet à l'utilisateur de nommer son alerte avec validation
class AlertNameInput extends StatelessWidget {
  /// Valeur initiale du champ
  final String? initialValue;

  /// Callback appelé lors du changement de valeur
  final ValueChanged<String>? onChanged;

  /// Fonction de validation personnalisée
  final String? Function(String?)? validator;

  /// Contrôleur pour gérer le texte
  final TextEditingController? controller;

  const AlertNameInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      onChanged: onChanged,
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Nom de votre alerte',
        border: OutlineInputBorder(),
        hintText: 'Ex: Alerte température serre 1',
      ),
      maxLength: 50,
    );
  }
}
