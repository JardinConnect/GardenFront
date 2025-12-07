import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alert_bloc.dart';
import '../models/alert_models.dart';
import '../widgets/sensor_icons_row.dart';

/// Composant pour l'affichage en liste des alertes
class AlertListView extends StatelessWidget {
  final List<Alert> alerts;

  const AlertListView({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const Center(child: Text('Aucune alerte disponible'));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Contenu principal de l'alerte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Description et icônes alignées en colonnes
                    Row(
                      children: [
                        // Description avec largeur fixe pour alignement
                        SizedBox(
                          width: 300, // Largeur fixe pour aligner les icônes
                          child: Text(
                            alert.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        // Icônes alignées en colonne
                        SensorIconsRow(
                          activeSensorTypes: alert.sensorTypes,
                        ),
                        // Spacer pour pousser vers la gauche
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              // Switch d'activation
              Switch(
                value: alert.isActive,
                onChanged: (value) {
                  context.read<AlertBloc>().add(
                    AlertToggleStatus(
                      alertId: alert.id,
                      isActive: value,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}