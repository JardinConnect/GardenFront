import 'package:flutter/material.dart';
import '../models/alert_models.dart';
import '../data/alert_repository.dart';
import '../widgets/sensor_alert_carousel.dart';

/// Composant pour l'affichage en cartes des alertes
class AlertCardView extends StatefulWidget {
  const AlertCardView({super.key});

  @override
  State<AlertCardView> createState() => _AlertCardViewState();
}

class _AlertCardViewState extends State<AlertCardView> {
  final AlertRepository _alertRepository = AlertRepository();
  List<SensorAlertData> _sensorAlerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSensorAlerts();
  }

  Future<void> _loadSensorAlerts() async {
    try {
      final sensorAlerts = await _alertRepository.getSensorAlertsForCardView();
      setState(() {
        _sensorAlerts = sensorAlerts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement des capteurs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSensorStatus(String sensorId, bool isEnabled) async {
    try {
      await _alertRepository.updateAlertStatus(sensorId, isEnabled);
      // Mise à jour locale de l'état
      setState(() {
        final index = _sensorAlerts.indexWhere((alert) => alert.id == sensorId);
        if (index >= 0) {
          _sensorAlerts[index] = _sensorAlerts[index].copyWith(isEnabled: isEnabled);
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

    if (_sensorAlerts.isEmpty) {
      return const Center(child: Text('Aucune donnée de capteur disponible'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          // Première carte avec les 2 premiers capteurs
          SizedBox(
            width: 400,
            child: SensorAlertCarousel(
              sensors: _sensorAlerts.take(2).toList(),
              onToggle: _toggleSensorStatus,
            ),
          ),
          // Deuxième carte avec les 2 suivants
          SizedBox(
            width: 400,
            child: SensorAlertCarousel(
              sensors: _sensorAlerts.skip(2).take(2).toList(),
              onToggle: _toggleSensorStatus,
            ),
          ),
          // Troisième carte avec le dernier capteur
          SizedBox(
            width: 400,
            child: SensorAlertCarousel(
              sensors: _sensorAlerts.skip(4).toList(),
              onToggle: _toggleSensorStatus,
            ),
          ),
        ],
      ),
    );
  }
}