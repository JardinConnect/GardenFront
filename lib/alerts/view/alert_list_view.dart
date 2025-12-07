import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../models/alert_models.dart';
import '../data/alert_repository.dart';
import '../widgets/sensor_icons_row.dart';

/// Composant pour l'affichage en liste des alertes
class AlertListView extends StatefulWidget {
  const AlertListView({super.key});

  @override
  State<AlertListView> createState() => _AlertListViewState();
}

class _AlertListViewState extends State<AlertListView> {
  final AlertRepository _alertRepository = AlertRepository();
  List<Alert> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    try {
      final alerts = await _alertRepository.getAlertsForListView();
      setState(() {
        _alerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement des alertes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleAlertStatus(Alert alert, bool newStatus) async {
    try {
      await _alertRepository.updateAlertStatus(alert.id, newStatus);
      // Mise à jour locale de l'état
      setState(() {
        final index = _alerts.indexWhere((a) => a.id == alert.id);
        if (index >= 0) {
          _alerts[index] = Alert(
            id: alert.id,
            title: alert.title,
            description: alert.description,
            isActive: newStatus,
            sensorTypes: alert.sensorTypes,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_alerts.isEmpty) {
      return const Center(child: Text('Aucune alerte disponible'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
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
                onChanged: (value) => _toggleAlertStatus(alert, value),
              ),
            ],
          ),
        );
      },
    );
  }
}