import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/alert_bloc.dart';

/// Widget pour l'en-tête de la page d'ajout d'alerte
/// Affiche le bouton retour et le titre
class AlertAddHeader extends StatelessWidget {
  const AlertAddHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bouton retour
        _buildBackButton(context),

        const SizedBox(height: 16),

        // Titre de la page
        _buildTitle(context),
      ],
    );
  }

  /// Construit le bouton retour
  Widget _buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () => _handleBack(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios, size: 16),
          SizedBox(width: 4),
          Text(
            'Retour',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le titre
  Widget _buildTitle(BuildContext context) {
    return Text(
      'Ajouter une alerte',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

  /// Gère le retour à la vue précédente
  void _handleBack(BuildContext context) {
    context.read<AlertBloc>().add(AlertHideAddView());
  }
}

