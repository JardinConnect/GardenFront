import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/alerts/alerts.dart';
import 'package:garden_connect/common/widgets/empty_state_widget.dart';
import 'package:garden_connect/mobile/alerts/widgets/mobile_alert_history_widget.dart';
import 'package:garden_connect/mobile/alerts/widgets/mobile_alert_tab_bar.dart';
import 'package:garden_connect/mobile/alerts/widgets/mobile_alerts_card_widget.dart';
import 'package:garden_connect/mobile/alerts/widgets/mobile_alerts_list_widget.dart';
import 'package:garden_connect/mobile/common/widgets/mobile_header.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

import '../../../alerts/widgets/button/tab_menu.dart';

/// Page principale de la liste des alertes en version mobile.
///
/// Affiche les alertes sous forme de liste ou de cartes selon le mode d'affichage
/// sélectionné, et permet la recherche, la création et l'édition d'une alerte.
class MobileAlertsPageContent extends StatefulWidget {
  const MobileAlertsPageContent({super.key});

  @override
  State<MobileAlertsPageContent> createState() =>
      _MobileAlertsPageContentState();
}

class _MobileAlertsPageContentState extends State<MobileAlertsPageContent> {
  String _searchQuery = '';

  /// Bascule entre le mode liste et le mode carte.
  void _onToggleDisplayMode(BuildContext context, DisplayMode current) {
    context.read<AlertBloc>().add(
      AlertChangeDisplayMode(
        displayMode:
            current == DisplayMode.list ? DisplayMode.card : DisplayMode.list,
      ),
    );
  }

  /// Filtre les alertes affichées selon la saisie de l'utilisateur.
  void _onSearch(BuildContext context, String text) {
    setState(() => _searchQuery = text.toLowerCase().trim());
  }

  /// Navigue vers le formulaire de création d'une nouvelle alerte.
  void _onAddAlert(BuildContext context) {
    context.push('/m/alerts/add');
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertBloc, AlertState>(
      builder: (context, state) {
        if (state is AlertInitial || state is AlertLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AlertError) {
          return Scaffold(
            appBar: MobileHeader(actionsButtons: const []),
            body: EmptyStateWidget(
              icon: Icons.error_outline_rounded,
              message: 'Une erreur est survenue',
              subtitle: state.message,
              color: Colors.red.shade300,
            ),
          );
        }

        if (state is AlertLoaded) {

          final isList = state.displayMode == DisplayMode.list;

          final filteredAlerts = _searchQuery.isEmpty
              ? state.alerts
              : state.alerts
                  .where((a) =>
                      a.title.toLowerCase().contains(_searchQuery))
                  .toList();

          return Scaffold(
            appBar: MobileHeader(
              actionsButtons: [
                if (state.selectedTab == AlertTabType.alerts)
                  IconButton(
                    onPressed: () =>
                        _onToggleDisplayMode(context, state.displayMode),
                    icon: Icon(
                      isList ? Icons.grid_view : Icons.list,
                      color: GardenColors.primary.shade500,
                      size: 32,
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: GardenSpace.paddingLg,
                  vertical: GardenSpace.paddingMd,
                ),
                child: Column(
                  spacing: GardenSpace.gapMd,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (text) => _onSearch(context, text),
                            decoration: InputDecoration(
                              hintText: 'Rechercher',
                              prefixIcon: const Icon(Icons.search),
                              hintStyle: GardenTypography.bodyLg.copyWith(
                                color: GardenColors.typography.shade200,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: GardenSpace.gapMd),
                        GestureDetector(
                          onTap: () => _onAddAlert(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: GardenColors.primary.shade500,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: GardenColors.primary.shade500,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Onglets Alertes / Historique
                    Row(
                      children: AlertTabType.values.map((tab) {
                        final isSelected = state.selectedTab == tab;
                        return AlertTabItem(
                          label: tab.label,
                          icon: tab == AlertTabType.alerts
                              ? Icons.thunderstorm_outlined
                              : Icons.history_rounded,
                          isSelected: isSelected,
                          onTap: () => context.read<AlertBloc>().add(
                            AlertChangeTab(tabType: tab),
                          ),
                        );
                      }).toList(),
                    ),
                    Expanded(
                      child: state.selectedTab == AlertTabType.alerts
                          ? (isList
                              ? MobileAlertsListWidget(alerts: filteredAlerts)
                              : MobileAlertsCardWidget(alerts: filteredAlerts))
                          : MobileAlertHistoryWidget(
                              alertEvents: state.alertEvents,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: EmptyStateWidget(
            icon: Icons.thunderstorm_outlined,
            message: 'Impossible de charger les alertes',
            subtitle: 'Veuillez réessayer.',
          ),
        );
      },
    );
  }
}

