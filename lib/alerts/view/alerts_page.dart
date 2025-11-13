import 'package:flutter/material.dart';
import 'package:garden_connect/core/app_assets.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Page des Alertes',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineLarge,
            ),
            const SizedBox(height: 16),

            // Section visible pour tous
            const Text('Contenu visible pour tous les utilisateurs'),

            const SizedBox(height: 16),

            // Section réservée aux admins
            RoleGuard.adminOnly(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Section Admin: Ce texte n\'est visible que pour les administrateurs',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Affichage du rôle actuel
            Text(
              'Votre rôle: ${context.isAdmin
                  ? 'Administrateur'
                  : 'Utilisateur'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}