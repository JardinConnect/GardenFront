import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../widgets/tab_menu.dart';
import '../widgets/display_mode_button.dart';
import '../widgets/add_alert_button.dart';
import '../widgets/alert_table.dart';
import '../widgets/sensor_icons_row.dart';
import '../models/alert_models.dart';

/// Modèle pour une alerte de capteur
class SensorAlert {
  final String id;
  final String title;
  final SensorType sensorType;
  final SensorThreshold threshold;
  final bool isActive;
  final int currentPage;
  final int totalPages;

  const SensorAlert({
    required this.id,
    required this.title,
    required this.sensorType,
    required this.threshold,
    required this.isActive,
    required this.currentPage,
    required this.totalPages,
  });

  SensorAlert copyWith({
    String? id,
    String? title,
    SensorType? sensorType,
    SensorThreshold? threshold,
    bool? isActive,
    int? currentPage,
    int? totalPages,
  }) {
    return SensorAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      sensorType: sensorType ?? this.sensorType,
      threshold: threshold ?? this.threshold,
      isActive: isActive ?? this.isActive,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

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
  List<SensorAlert> _alerts = [];

  @override
  void initState() {
    super.initState();
    _alerts = _getMockAlerts();
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
                        'Alerte ${index + 1}',
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
                            activeSensorTypes: [
                              SensorType.temperature,
                              SensorType.humiditySurface,
                              SensorType.humidityDepth,
                              SensorType.light,
                              SensorType.rain,
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12), // Espacement avant le toggle
                // Toggle d'activation tout à droite
                Switch(
                  value: alert.isActive,
                  onChanged: (value) {
                    setState(() {
                      _alerts[index] = alert.copyWith(isActive: value);
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Affichage en cartes (mode grille) avec SensorAlertCard
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _alerts.length,
          itemBuilder: (context, index) {
            final alert = _alerts[index];
            return SensorAlertCard(
              sensorType: alert.sensorType,
              threshold: alert.threshold,
              isEnabled: alert.isActive,
              onToggle: (isActive) {
                setState(() {
                  _alerts[index] = alert.copyWith(isActive: isActive);
                });
              },
              totalPages: alert.totalPages,
              currentPage: alert.currentPage,
              onPageChanged: (pageIndex) {
                setState(() {
                  _alerts[index] = alert.copyWith(currentPage: pageIndex);
                });
              },
            );
          },
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
  List<SensorAlert> _getMockAlerts() {
    return [
      const SensorAlert(
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
        isActive: true,
        currentPage: 2,
        totalPages: 5,
      ),
      const SensorAlert(
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
        isActive: true,
        currentPage: 0,
        totalPages: 5,
      ),
      const SensorAlert(
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
        isActive: true,
        currentPage: 1,
        totalPages: 5,
      ),
      const SensorAlert(
        id: '4',
        title: 'Alerte température',
        sensorType: SensorType.temperature,
        threshold: SensorThreshold(
          thresholds: [
            ThresholdValue(
              value: 90,
              unit: '%',
              label: 'maximale',
              alertType: MenuAlertType.warning,
            ),
            ThresholdValue(
              value: 10,
              unit: '%',
              label: 'minimale',
              alertType: MenuAlertType.none,
            ),
          ],
        ),
        isActive: false,
        currentPage: 3,
        totalPages: 5,
      ),
      const SensorAlert(
        id: '5',
        title: 'Alerte température old',
        sensorType: SensorType.light,
        threshold: SensorThreshold(
          thresholds: [
            ThresholdValue(
              value: 90,
              unit: '%',
              label: 'maximale',
              alertType: MenuAlertType.warning,
            ),
            ThresholdValue(
              value: 10,
              unit: '%',
              label: 'minimale',
              alertType: MenuAlertType.warning,
            ),
          ],
        ),
        isActive: false,
        currentPage: 4,
        totalPages: 5,
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
