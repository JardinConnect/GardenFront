import 'package:flutter/material.dart';

/// Composant pour saisir le nom d'une alerte
class AlertNameInput extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
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
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'Nom de votre alerte',
        border: OutlineInputBorder(),
        hintText: 'Entrez le nom de votre alerte',
      ),
    );
  }
}
