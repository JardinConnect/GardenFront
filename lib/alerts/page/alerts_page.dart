import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/foundation/padding/space_design_system.dart';

import '../../common/widgets/empty_state_widget.dart';
import '../../common/widgets/page_header.dart';
import '../../common/widgets/page_shimmers.dart';
import '../bloc/alert_bloc.dart';
import '../view/alert_card_view.dart';
import '../view/alert_form_view.dart';
import '../view/alert_history_view.dart';
import '../view/alert_list_view.dart';
import '../widgets/button/add_alert_button.dart';
import '../widgets/button/display_mode_button.dart';
import '../widgets/button/tab_menu.dart';
import '../widgets/common/snackbar.dart' as snackbar;

/// Mode d'affichage des alertes
enum DisplayMode { list, card }

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AlertBloc, AlertState>(
      listenWhen: (prev, curr) {
        if (curr is AlertError) return true;
        if (curr is AlertLoaded && prev is AlertLoaded) {
          return (curr.errorMessage != null &&
                  curr.errorMessage != prev.errorMessage) ||
              (curr.successMessage != null &&
                  curr.successMessage != prev.successMessage);
        }
        return false;
      },
      listener: (context, state) {
        if (state is AlertError) {
          snackbar.showSnackBarError(context, state.message);
        }
        if (state is AlertLoaded) {
          if (state.errorMessage != null) {
            snackbar.showSnackBarError(context, state.errorMessage!);
            Future.microtask(() {
              if (context.mounted) {
                context.read<AlertBloc>().add(const AlertClearErrorMessage());
              }
            });
          }
          if (state.successMessage != null) {
            snackbar.showSnackBarSucces(context, state.successMessage!);
            Future.microtask(() {
              if (context.mounted) {
                context.read<AlertBloc>().add(const AlertClearSuccessMessage());
              }
            });
          }
        }
      },
      builder: (context, state) {
        // Vue de création
        if (state is AlertLoaded && state.isShowingAddView) {
          return AlertFormView();
        }

        // Loader pendant le chargement des données d'édition
        if (state is AlertLoaded &&
            state.isShowingEditView &&
            (state.editingAlert == null || state.alertDetails == null)) {
          return const AlertsPageShimmer();
        }

        // Vue d'édition
        if (state is AlertLoaded &&
            state.isShowingEditView &&
            state.editingAlert != null &&
            state.alertDetails != null) {
          return AlertFormView(
            alert: state.editingAlert,
            alertDetails: state.alertDetails,
          );
        }

        return Padding(
          padding: EdgeInsets.all(GardenSpace.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec titre et boutons d'action
              PageHeader(
                title: 'Gestion des alertes',
                actions: [
                  // Bouton de mode d'affichage (liste/cartes), visible uniquement sur l'onglet alertes
                  if (state is AlertLoaded &&
                      state.selectedTab == AlertTabType.alerts)
                    DisplayModeButton(
                      isListMode: state.displayMode == DisplayMode.list,
                      onToggle:
                          () => context.read<AlertBloc>().add(
                            AlertChangeDisplayMode(
                              displayMode:
                                  state.displayMode == DisplayMode.list
                                      ? DisplayMode.card
                                      : DisplayMode.list,
                            ),
                          ),
                    ),
                  // Bouton pour ajouter une alerte
                  AddAlertButton(
                    onPressed:
                        () => context.read<AlertBloc>().add(AlertShowAddView()),
                  ),
                ],
              ),
              SizedBox(height: GardenSpace.gapMd),
              // Menu des onglets
              if (state is AlertLoaded)
                AlertTabMenu(
                  selectedTab: state.selectedTab,
                  onTabSelected:
                      (tab) => context.read<AlertBloc>().add(
                        AlertChangeTab(tabType: tab),
                      ),
                ),
              SizedBox(height: GardenSpace.gapMd),
              // Contenu de l'onglet sélectionné
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        );
      },
    );
  }

  /// Construit le contenu selon l'onglet sélectionné
  Widget _buildContent(BuildContext context, AlertState state) {
    if (state is AlertLoading) {
      return const AlertsContentShimmer();
    }

    if (state is AlertError) {
      return EmptyStateWidget(
        icon: Icons.error_outline_rounded,
        message: 'Une erreur est survenue',
        subtitle: state.message,
        color: Colors.red.shade300,
      );
    }

    if (state is! AlertLoaded) {
      return const AlertsContentShimmer();
    }

    return switch (state.selectedTab) {
      AlertTabType.alerts => switch (state.displayMode) {
        DisplayMode.list => AlertListView(alerts: state.alerts),
        DisplayMode.card => AlertCardView(alerts: state.alerts),
      },
      AlertTabType.history => AlertHistoryView(alertEvents: state.alertEvents),
    };
  }
}
