import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../widgets/tab_menu.dart';
import '../widgets/display_mode_button.dart';
import '../widgets/add_alert_button.dart';
import '../widgets/alert_table.dart';
import '../widgets/sensor_icons_row.dart';
import '../widgets/sensor_alert_carousel.dart';
import '../models/alert_models.dart';
import '../data/alert_repository.dart';

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
  List<Alert> _alerts = [];
  List<AlertEvent> _alertEvents = [];
  final AlertRepository _alertRepository = AlertRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Charge les données depuis le repository selon l'onglet sélectionné
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      switch (_selectedTab) {
        case AlertTabType.alerts:
          if (_displayMode == DisplayMode.list) {
            _alerts = await _alertRepository.getAlertsForListView();
          } else {
            _sensorAlerts = await _alertRepository.getSensorAlertsForCardView();
          }
          break;
        case AlertTabType.history:
          _alertEvents = await _alertRepository.getAlertHistory();
          break;
      }
    } catch (e) {
      // Gestion d'erreur simple pour l'instant
      debugPrint('Erreur lors du chargement des données: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                      if (_selectedTab == AlertTabType.alerts) ...[
                        DisplayModeButton(
                          isListMode: _displayMode == DisplayMode.list,
                          onToggle: () {
                            setState(() {
                              _displayMode = _displayMode == DisplayMode.list
                                  ? DisplayMode.card
                                  : DisplayMode.list;
                            });
                            // Le rechargement se fera automatiquement via _buildAlertsContent
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
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
                // Le rechargement se fera automatiquement via _buildTabContent
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Charger les données si nécessaire selon l'onglet sélectionné
    if (_selectedTab == AlertTabType.alerts) {
      // Vérifier si on a les bonnes données pour le mode courant
      if ((_displayMode == DisplayMode.list && _alerts.isEmpty) ||
          (_displayMode == DisplayMode.card && _sensorAlerts.isEmpty)) {
        _loadData();
        return const Center(child: CircularProgressIndicator());
      }
      return _buildAlertsContent();
    } else {
      // Onglet historique
      if (_alertEvents.isEmpty) {
        _loadData();
        return const Center(child: CircularProgressIndicator());
      }
      return _buildHistoryContent();
    }
  }

  /// Construit le contenu de l'onglet Alertes
  Widget _buildAlertsContent() {
    if (_displayMode == DisplayMode.list) {
      // Affichage en liste simple avec les données Alert
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
                  onChanged: (value) async {
                    try {
                      await _alertRepository.updateAlertStatus(alert.id, value);
                      // Pas de rechargement automatique pour éviter les interruptions
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Affichage en cartes avec grille de SensorAlertCarousel
      if (_sensorAlerts.isEmpty) {
        return const Center(child: Text('Aucune donnée de capteur disponible'));
      }
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Troisième carte avec le dernier capteur
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: _sensorAlerts.skip(4).toList(),
                onToggle: (sensorId, isEnabled) async {
                  try {
                    await _alertRepository.updateAlertStatus(sensorId, isEnabled);
                    // Pas de rechargement automatique
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                },
              ),
            ),
            // Deuxième carte avec les 2 suivants
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: _sensorAlerts.skip(2).take(2).toList(),
                onToggle: (sensorId, isEnabled) async {
                  try {
                    await _alertRepository.updateAlertStatus(sensorId, isEnabled);
                    // Pas de rechargement automatique
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                },
              ),
            ),
            // Troisième carte avec le dernier capteur
            SizedBox(
              width: 400,
              child: SensorAlertCarousel(
                sensors: _sensorAlerts.skip(4).toList(),
                onToggle: (sensorId, isEnabled) async {
                  try {
                    await _alertRepository.updateAlertStatus(sensorId, isEnabled);
                    // Pas de rechargement automatique
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
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
    return SingleChildScrollView(
      child: AlertTable(
        events: _alertEvents,
        showHeaders: true,
        onDeleteEvent: _handleDeleteEvent,
      ),
    );
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
  void _handleDeleteEvent(AlertEvent event) async {
    try {
      await _alertRepository.archiveAlertEvent(event.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Archivage de l\'alerte ${event.value}'),
        ),
      );
      // Pas de rechargement automatique
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'archivage: $e')),
      );
    }
  }
}
