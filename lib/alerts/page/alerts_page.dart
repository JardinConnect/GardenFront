import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alert_bloc.dart';
import '../widgets/button/tab_menu.dart';
import '../widgets/button/display_mode_button.dart';
import '../widgets/button/add_alert_button.dart';
import '../widgets/common/snackbar.dart' as custom_snackbar;
import '../view/alert_list_view.dart';
import '../view/alert_card_view.dart';
import '../view/alert_history_view.dart';
import '../view/alert_add_view.dart';
import '../view/alert_edit_view.dart';

/// Mode d'affichage des alertes
enum DisplayMode {
  list,
  card,
}

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlertBloc(),
      child: const AlertsPageView(),
    );
  }
}

class AlertsPageView extends StatelessWidget {
  const AlertsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlertBloc, AlertState>(
      listener: (context, state) {
        if (state is AlertError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is AlertLoaded && state.successMessage != null) {
          custom_snackbar.showSnackBarSucces(context, state.successMessage!);
          // Nettoyer le message après l'affichage
          Future.delayed(Duration.zero, () {
            if (context.mounted) {
              context.read<AlertBloc>().add(AlertClearSuccessMessage());
            }
          });
        }
      },
      builder: (context, state) {
        // Afficher la vue d'ajout d'alerte
        if (state is AlertLoaded && state.isShowingAddView) {
          return const AlertAddView();
        }
        
        // Afficher la vue d'édition d'alerte
        if (state is AlertLoaded && state.isShowingEditView && state.editingAlertId != null) {
          return AlertEditView(alertId: state.editingAlertId!);
        }

        return Padding(
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
                        if (state is AlertLoaded && state.selectedTab == AlertTabType.alerts) ...[
                          DisplayModeButton(
                            isListMode: state.displayMode == DisplayMode.list,
                            onToggle: () {
                              context.read<AlertBloc>().add(
                                AlertChangeDisplayMode(
                                  displayMode: state.displayMode == DisplayMode.list
                                      ? DisplayMode.card
                                      : DisplayMode.list,
                                ),
                              );
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
              if (state is AlertLoaded)
                AlertTabMenu(
                  selectedTab: state.selectedTab,
                  onTabSelected: (tab) {
                    context.read<AlertBloc>().add(AlertChangeTab(tabType: tab));
                  },
                ),
              const SizedBox(height: 16),
              // Contenu de l'onglet sélectionné
              Expanded(
                child: _buildTabContent(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Construit le contenu selon l'onglet sélectionné
  Widget _buildTabContent(BuildContext context, AlertState state) {
    if (state is! AlertLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (state.selectedTab) {
      case AlertTabType.alerts:
        return _buildAlertsContent(state);
      case AlertTabType.history:
        return AlertHistoryView(alertEvents: state.alertEvents);
    }
  }

  /// Construit le contenu des alertes selon le mode d'affichage
  Widget _buildAlertsContent(AlertLoaded state) {
    switch (state.displayMode) {
      case DisplayMode.list:
        return AlertListView(alerts: state.alerts);
      case DisplayMode.card:
        return AlertCardView(sensorAlerts: state.sensorAlerts);
    }
  }

  /// Gère l'action d'ajout d'une nouvelle alerte
  void _handleAddAlert(BuildContext context) {
    context.read<AlertBloc>().add(AlertShowAddView());
  }
}