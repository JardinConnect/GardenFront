import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../widgets/tab_menu.dart';
import '../widgets/display_mode_button.dart';
import '../widgets/add_alert_button.dart';
import 'alert_list_view.dart';
import 'alert_card_view.dart';
import 'alert_history_view.dart';

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
        return const AlertHistoryView();
    }
  }

  /// Construit le contenu de l'onglet Alertes
  Widget _buildAlertsContent() {
    if (_displayMode == DisplayMode.list) {
      return const AlertListView();
    } else {
      return const AlertCardView();
    }
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
}
