import 'package:flutter/material.dart';
import 'package:garden_connect/common/widgets/back_text_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/bloc/area_bloc.dart';
import 'package:garden_connect/alerts/bloc/alert_bloc.dart';
import 'package:garden_connect/alerts/widgets/common/snackbar.dart'
    as snackbar;
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/cells/models/cell_pairing_payload.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

import '../../../alerts/models/alert_models.dart';
import '../../../analytics/models/analytics.dart';
import '../../../areas/models/area.dart';
import '../../../cells/models/cell.dart';
import '../widgets/title_view_widget.dart';
import '../widgets/tooltip_widget.dart';

class CellConfigureView extends StatefulWidget {
  const CellConfigureView({super.key, this.pairingPayload});

  final CellPairingPayload? pairingPayload;

  @override
  State<CellConfigureView> createState() => _CellConfigureViewState();
}

class _CellConfigureViewState extends State<CellConfigureView> {
  final TextEditingController _cellNameController = TextEditingController();

  String? _selectedAction;
  String? _deviceId;
  String? _firmwareVersion;
  String? _cellId;
  Area? _selectedArea;
  Alert? _selectedAlert;

  Widget _buildCellPreviouslyDisabled(Cell cell) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          'Cellule précédemment désactivée',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      SizedBox(height: GardenSpace.gapMd),
      Text(
        'Cette cellule était active jusqu\'au 23/06/2025',
        style: GardenTypography.bodyMd.copyWith(
          color: GardenColors.typography.shade800,
          fontSize: 14,
        ),
      ),
      SizedBox(height: GardenSpace.gapLg),
      Text(
        '• Nom précédent : ${cell.name}',
        style: GardenTypography.bodyMd.copyWith(
          color: GardenColors.typography.shade800,
        ),
      ),
      Text(
        '• Zone : ${cell.location}',
        style: GardenTypography.bodyMd.copyWith(
          color: GardenColors.typography.shade800,
        ),
      ),
      Text(
        '• Données historiques : -----',
        style: GardenTypography.bodyMd.copyWith(
          color: GardenColors.typography.shade800,
        ),
      ),
      Text(
        '• Nombre de relevés : -----',
        style: GardenTypography.bodyMd.copyWith(
          color: GardenColors.typography.shade800,
        ),
      ),
      const SizedBox(height: 40),
      Center(
        child: Text(
          'Que souhaitez-vous faire avec les anciennes données ?',
          style: GardenTypography.bodyLg.copyWith(
            color: GardenColors.typography.shade800,
          ),
        ),
      ),
      SizedBox(height: GardenSpace.gapLg),
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedAction = 'keep';
                  });
                  //TODO Handle keep data action
                },
                style: OutlinedButton.styleFrom(
                  overlayColor:
                      _selectedAction == 'keep'
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.05)
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.05),
                  padding: const EdgeInsets.all(24),
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                    color:
                        _selectedAction == 'keep'
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.storage,
                      size: 30,
                      color:
                          _selectedAction == 'keep'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(width: GardenSpace.gapMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Réimporter les anciennes données',
                            style: GardenTypography.bodyLg.copyWith(
                              color: GardenColors.typography.shade800,
                            ),
                          ),
                          Text(
                            'Conserve l\'historique complet, les alertes configurées et les paramètres précédents.\nLe capteur reprendra là où il s\'était arrêté.',
                            style: GardenTypography.bodyMd.copyWith(
                              color: GardenColors.typography.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: GardenSpace.gapXl),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedAction = 'delete';
                  });
                  //TODO Handle delete data action
                },
                style: OutlinedButton.styleFrom(
                  overlayColor:
                      _selectedAction == 'delete'
                          ? Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.05)
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.05),
                  padding: const EdgeInsets.all(24),
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                    color:
                        _selectedAction == 'delete'
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurface,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_forever,
                      size: 30,
                      color:
                          _selectedAction == 'delete'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(width: GardenSpace.gapMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Repartir à zéro',
                            style: GardenTypography.bodyLg.copyWith(
                              color: GardenColors.typography.shade800,
                            ),
                          ),
                          Text(
                            'Supprimer définitivement toutes les anciennes données et alertes.\nLa cellule sera configuré comme un nouveau matériel.',
                            style: GardenTypography.bodyMd.copyWith(
                              color: GardenColors.typography.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    final pairing = widget.pairingPayload;
    final cellName = pairing?.cell?.name ?? pairing?.device?.name;
    if (cellName != null && cellName.isNotEmpty) {
      _cellNameController.text = cellName;
    }
    _deviceId = pairing?.device?.deviceId;
    _firmwareVersion = pairing?.device?.firmwareVersion;
    _cellId = pairing?.cell?.id;
  }

  @override
  void dispose() {
    _cellNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areaState = context.watch<AreaBloc>().state;
    final List<Area> areas =
        areaState is AreasLoaded ? areaState.filteredAreas : const [];

    final alertState = context.watch<AlertBloc>().state;
    final List<Alert> alerts =
        alertState is AlertLoaded ? alertState.alerts : const [];

    final Cell lastCell = Cell(
      id: '1',
      name: 'Cellule #4-1',
      location: 'Espace 2 > Serre A > planche 23',
      updatedAt: DateTime.now(),
      isTracked: false,
      analytics: Analytics(),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackTextButton(
                backFunction: () => context.go('/settings/cells/add'),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleViewWidget(
                      title: 'Nouvelle cellule active',
                      content: 'Configurez-là dès maintenant',
                    ),
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.sensors,
                                size: 30,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(width: GardenSpace.gapSm),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  controller: _cellNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nom de la cellule',
                                    labelStyle: GardenTypography.bodyLg,
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Veuillez entrer un nom pour l\'espace';
                                    }
                                    if (value.trim().length < 3) {
                                      return 'Le nom doit contenir au moins 3 caractères';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          BatteryIndicator(batteryPercentage: 96),
                        ],
                      ),
                    ),
                    SizedBox(height: GardenSpace.gapXl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 68),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<Area>(
                              label: const Text('Espaces'),
                              hintText: 'Sélectionner un espace',
                              initialSelection: _selectedArea,
                              textStyle: GardenTypography.bodyLg.copyWith(
                                color: GardenColors.typography.shade800,
                              ),
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                filled: true,
                                hintStyle: GardenTypography.bodyLg.copyWith(
                                  color: GardenColors.typography.shade800,
                                ),
                                labelStyle: GardenTypography.bodyLg.copyWith(
                                  color: GardenColors.typography.shade800,
                                ),
                              ),
                              dropdownMenuEntries:
                                  areas.map((area) {
                                    return DropdownMenuEntry<Area>(
                                      value: area,
                                      label: area.name,
                                      labelWidget: Text(
                                        area.name,
                                        style: GardenTypography.bodyLg.copyWith(
                                          color: GardenColors
                                              .typography
                                              .shade800,
                                        ),
                                      ),
                                      leadingIcon: LevelIndicator(
                                        level: area.level,
                                        size: LevelIndicatorSize.sm,
                                      ),
                                      trailingIcon: Text(
                                        'Niveau ${area.level}',
                                        style: GardenTypography.bodyLg.copyWith(
                                          color: GardenColors
                                              .typography
                                              .shade800,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onSelected: (Area? newValue) {
                                setState(() {
                                  _selectedArea = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: GardenSpace.gapXl),
                          Expanded(
                            child: DropdownMenu<Alert>(
                              label: const Text('Alertes'),
                              hintText: 'Sélectionner une alerte',
                              initialSelection: _selectedAlert,
                              textStyle: GardenTypography.bodyLg.copyWith(
                                color: GardenColors.typography.shade800,
                              ),
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                filled: true,
                                hintStyle: GardenTypography.bodyLg.copyWith(
                                  color: GardenColors.typography.shade800,
                                ),
                                labelStyle: GardenTypography.bodyLg.copyWith(
                                  color: GardenColors.typography.shade800,
                                ),
                              ),
                              dropdownMenuEntries:
                                  alerts.map((alert) {
                                    return DropdownMenuEntry<Alert>(
                                      value: alert,
                                      label: alert.title,
                                      labelWidget: Text(
                                        alert.title,
                                        style: GardenTypography.bodyLg.copyWith(
                                          color: GardenColors
                                              .typography
                                              .shade800,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onSelected: (Alert? newValue) {
                                setState(() {
                                  _selectedAlert = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: GardenSpace.gapXl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 68),
                      child: Row(
                        children: [
                          Expanded(
                            child: TooltipWidget(
                              title: _deviceId ?? '-',
                              content: 'ID matériel',
                              isReversed: true,
                              isCentered: true,
                            ),
                          ),
                          Expanded(
                            child: TooltipWidget(
                              title: _firmwareVersion ?? '-',
                              content: 'Firmware',
                              isReversed: true,
                              isCentered: true,
                            ),
                          ),
                          Expanded(
                            child: TooltipWidget(
                              title: '120dBm',
                              content: 'Signal',
                              isReversed: true,
                              isCentered: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                    _buildCellPreviouslyDisabled(lastCell),
                    const SizedBox(height: 30),
                    Center(
                      child: Button(
                        label: 'Terminer',
                        icon: Icons.check_circle_outline_outlined,
                        onPressed: _handleFinish,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFinish() {
    final cellId = _cellId;
    if (cellId == null) return;
    final name = _cellNameController.text.trim();
    if (name.isEmpty) return;
    context.read<CellBloc>().add(
          UpdateCell(
            id: cellId,
            name: name,
            isTracked: false,
            parentId: _selectedArea?.id,
          ),
        );
    snackbar.showSnackBarSucces(
      context,
      'Cellule mise à jour avec succès',
    );
    context.go('/settings/cells');
  }
}
