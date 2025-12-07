import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../widgets/tab_menu.dart';
import '../widgets/display_mode_button.dart';
import '../widgets/add_alert_button.dart';
import '../widgets/alert_table.dart';
import '../widgets/sensor_icons_row.dart';
import '../widgets/sensor_alert_carousel.dart';
import '../models/alert_models.dart';

/// Mode d'affichage des alertes
enum DisplayMode {
  list,
  card,
}

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  AlertTabType _selectedTab = AlertTabType.alerts;
  DisplayMode _displayMode = DisplayMode.list;
  List<SensorAlertData> _sensorAlerts = [];

  @override
  void initState() {
    super.initState();
    _sensorAlerts = _getMockSensorAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec titre et boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gestion des alertes',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      // Bouton pour changer le mode d'affichage
                      DisplayModeButton(
                        isListMode: _displayMode == DisplayMode.list,
                        onToggle: () {
                          setState(() {
                            _displayMode = _displayMode == DisplayMode.list
                                ? DisplayMode.card
                                : DisplayMode.list;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // Bouton pour ajouter une alerte
                      AddAlertButton(
                        onPressed: () {
                          _handleAddAlert(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Menu des onglets
            AlertTabMenu(
              selectedTab: _selectedTab,
              onTabSelected: (tab) {
                setState(() {
                  _selectedTab = tab;
                });
              },
            ),
            const SizedBox(height: 16),
            // Contenu de l'onglet sélectionné
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case AlertTabType.alerts:
        return _buildAlertsContent();
      case AlertTabType.history:
        return _buildHistoryContent();
    }
  }

  /// Construit le contenu de l'onglet Alertes
  Widget _buildAlertsContent() {
    if (_displayMode == DisplayMode.list) {
      // Affichage en liste simple comme dans la maquette
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _sensorAlerts.length,
        itemBuilder: (context, index) {
          final alert = _sensorAlerts[index];
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
                      // Description et icônes sur la même ligne
                      Row(
                        children: [
                          Text(
                            'La description de mon alerte',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 24), // Petit espacement entre texte et icônes
                          // Ligne d'icônes de capteurs directement après la description
                          SensorIconsRow(
                            activeSensorTypes: [alert.sensorType],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12), // Espacement avant le toggle
                // Toggle d'activation tout à droite
                Switch(
                  value: alert.isEnabled,
                  onChanged: (value) {
                    setState(() {
                      _sensorAlerts[index] = alert.copyWith(isEnabled: value);
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Affichage en cartes avec grille de SensorAlertCarousel
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
                onToggle: (sensorId, isEnabled) {
                  setState(() {
                    final globalIndex = _sensorAlerts.indexWhere((alert) => alert.id == sensorId);
                    if (globalIndex >= 0) {
                      _sensorAlerts[globalIndex] = _sensorAlerts[globalIndex].copyWith(isEnabled: isEnabled);
                    }
                  });
                },
              ),
            ),
            // Deuxième carte avec les 2 suivants
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: _sensorAlerts.skip(2).take(2).toList(),
                onToggle: (sensorId, isEnabled) {
                  setState(() {
                    final globalIndex = _sensorAlerts.indexWhere((alert) => alert.id == sensorId);
                    if (globalIndex >= 0) {
                      _sensorAlerts[globalIndex] = _sensorAlerts[globalIndex].copyWith(isEnabled: isEnabled);
                    }
                  });
                },
              ),
            ),
            // Troisième carte avec le dernier capteur
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: _sensorAlerts.skip(4).toList(),
                onToggle: (sensorId, isEnabled) {
                  setState(() {
                    final globalIndex = _sensorAlerts.indexWhere((alert) => alert.id == sensorId);
                    if (globalIndex >= 0) {
                      _sensorAlerts[globalIndex] = _sensorAlerts[globalIndex].copyWith(isEnabled: isEnabled);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  /// Construit une petite icône de capteur
  Widget _buildSmallSensorIcon(String iconName, Color color) {
    return Container(
      width: 20,
      height: 20,
      child: GardenIcon(
        iconName: iconName,
        size: GardenIconSize.sm,
        color: color,
      ),
    );
  }

  /// Construit le contenu de l'onglet Historique
  Widget _buildHistoryContent() {
    final events = _getMockAlertEvents();
    
    return SingleChildScrollView(
      child: AlertTable(
        events: events,
        showHeaders: true,
        onDeleteEvent: _handleDeleteEvent,
      ),
    );
  }

  /// Génère des données de test pour les alertes de capteurs
  List<SensorAlertData> _getMockSensorAlerts() {
    return [
      const SensorAlertData(
        id: '1',
        title: 'Alerte 12 spé Temp',
        sensorType: SensorType.temperature,
        threshold: SensorThreshold(
          thresholds: [
            ThresholdValue(
              value: 35,
              unit: '°C',
              label: 'maximale',
              alertType: MenuAlertType.warning,
            ),
            ThresholdValue(
              value: 2,
              unit: '°C',
              label: 'minimale',
              alertType: MenuAlertType.warning,
            ),
          ],
        ),
        isEnabled: true,
      ),
      const SensorAlertData(
        id: '2',
        title: 'Alerte Global',
        sensorType: SensorType.humiditySurface,
        threshold: SensorThreshold(
          thresholds: [
            ThresholdValue(
              value: 90,
              unit: '%',
              label: 'maximale',
              alertType: MenuAlertType.error,
            ),
            ThresholdValue(
              value: 10,
              unit: '%',
              label: 'minimale',
              alertType: MenuAlertType.error,
            ),
          ],
        ),
        isEnabled: true,
      ),
      const SensorAlertData(
        id: '3',
        title: 'Alerte spé température...',
        sensorType: SensorType.humidityDepth,
        threshold: SensorThreshold(
          thresholds: [
            ThresholdValue(
              value: 90,
              unit: '%',
              label: 'maximale',
              alertType: MenuAlertType.error,
            ),
            ThresholdValue(
              value: 10,
              unit: '%',
              label: 'minimale',
              alertType: MenuAlertType.error,
            ),
          ],
        ),
        isEnabled: true,
      ),
      const SensorAlertData(
        id: '4',
        title: 'Alerte température',
        sensorType: SensorType.light,
        threshold: SensorThreshold(
          thresholds: [
            ThresholdValue(
              value: 10000,
              unit: ' lux',
              label: 'maximale',
              alertType: MenuAlertType.error,
            ),
            ThresholdValue(
              value: 5000,
              unit: ' lux',
              label: 'optimale',
              alertType: MenuAlertType.none,
            ),
            ThresholdValue(
              value: 1000,
              unit: ' lux',
              label: 'minimale',
              alertType: MenuAlertType.warning,
            ),
          ],
        ),
        isEnabled: false,
      ),
      const SensorAlertData(
        id: '5',
        title: 'Alerte pluie',
        sensorType: SensorType.rain,
        threshold: SensorThreshold(
          thresholds: [
            ThresholdValue(
              value: 100,
              unit: ' mm',
              label: 'maximale',
              alertType: MenuAlertType.none,
            ),
            ThresholdValue(
              value: 0,
              unit: ' mm',
              label: 'minimale',
              alertType: MenuAlertType.none,
            ),
          ],
        ),
        isEnabled: false,
      ),
    ];
  }

  /// Génère des données de test pour les événements d'alerte
  List<AlertEvent> _getMockAlertEvents() {
    return [
      const AlertEvent(
        id: '1',
        value: '25°C',
        sensorType: SensorType.temperature,
        cellName: 'Cellule 2',
        time: '16h45',
        date: '02/13/2025',
        location: 'Parcelle1 > Serre 2 > Chappelle 5 > planche 19',
      ),
      const AlertEvent(
        id: '2',
        value: '75%',
        sensorType: SensorType.humiditySurface,
        cellName: 'Cellule 5',
        time: '14h30',
        date: '02/13/2025',
        location: 'Parcelle2 > Serre 1 > Chappelle 3 > planche 8',
      ),
      const AlertEvent(
        id: '3',
        value: '1200 lux',
        sensorType: SensorType.light,
        cellName: 'Cellule 1',
        time: '12h15',
        date: '02/12/2025',
        location: 'Parcelle1 > Serre 3 > Chappelle 2 > planche 4',
      ),
    ];
  }

  /// Gère l'action d'ajout d'une nouvelle alerte
  void _handleAddAlert(BuildContext context) {
    // TODO: Implémenter l'ajout d'alerte
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajouter une alerte'),
      ),
    );
  }

  /// Gère l'action de suppression d'un événement d'alerte
  void _handleDeleteEvent(AlertEvent event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Archivage de l\'alerte ${event.value}'),
      ),
    );
  }
}
