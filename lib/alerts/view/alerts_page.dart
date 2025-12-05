import 'package:flutter/material.dart';
import '../widgets/tab_menu.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  AlertTabType _selectedTab = AlertTabType.alerts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestion des alertes',
              style: Theme.of(context).textTheme.headlineLarge,
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
        return const Center(
          child: Text(
            'Contenu des Alertes',
            style: TextStyle(fontSize: 18),
          ),
        );
      case AlertTabType.history:
        return const Center(
          child: Text(
            'Contenu de l\'Historique',
            style: TextStyle(fontSize: 18),
          ),
        );
    }
  }
}
