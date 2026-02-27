import 'package:flutter/material.dart';
import 'package:garden_connect/common/widgets/back_text_button.dart';
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
  const CellConfigureView({super.key});

  @override
  State<CellConfigureView> createState() => _CellConfigureViewState();
}

class _CellConfigureViewState extends State<CellConfigureView> {
  final TextEditingController _cellNameController = TextEditingController();

  String? _selectedAction;

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
      const SizedBox(height: 16),
      Text(
        'Cette cellule était active jusqu\'au 23/06/2025',
        style: GardenTypography.bodyMd.copyWith(
          color: GardenColors.typography.shade800,
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 24),
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
      const SizedBox(height: 24),
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
                    const SizedBox(width: 16),
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
            const SizedBox(width: 32),
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
                    const SizedBox(width: 16),
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
  Widget build(BuildContext context) {
    //TODO Get areas from AreaBloc
    // final List<Area> areas = Area.getAllAreasFlattened(areas);

    final List<Area> areas = [
      Area(
        id: '1',
        name: 'Parcelle',
        level: 1,
        color: Colors.red,
        analytics: Analytics(),
      ),
      Area(
        id: '2',
        name: 'Planche',
        level: 2,
        color: Colors.red,
        analytics: Analytics(),
      ),
    ];

    final List<Alert> alerts = [
      Alert(
        id: "1",
        title: 'Alerte #1',
        description: 'Description de l\'alerte #1',
        isActive: true,
        sensorTypes: [],
      ),
      Alert(
        id: "2",
        title: 'Alerte #2',
        description: 'Description de l\'alerte #2',
        isActive: false,
        sensorTypes: [],
      ),
    ];

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
              BackTextButton(backFunction: () => context.pop()),
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
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  controller: _cellNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Cellule #4-1',
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
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 68),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<Area>(
                              label: const Text('Espaces'),
                              hintText: 'Sélectionner un espace',
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                filled: true,
                              ),
                              dropdownMenuEntries:
                                  areas.map((area) {
                                    return DropdownMenuEntry<Area>(
                                      value: area,
                                      label: area.name,
                                      leadingIcon: LevelIndicator(
                                        level: area.level,
                                        size: LevelIndicatorSize.sm,
                                      ),
                                      trailingIcon: Text(
                                        'Niveau ${area.level}',
                                        style: GardenTypography.bodyLg,
                                      ),
                                    );
                                  }).toList(),
                              onSelected: (Area? newValue) {},
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: DropdownMenu<Alert>(
                              label: const Text('Alertes'),
                              hintText: 'Sélectionner une alerte',
                              expandedInsets: EdgeInsets.zero,
                              inputDecorationTheme: InputDecorationTheme(
                                border: const OutlineInputBorder(),
                                filled: true,
                              ),
                              dropdownMenuEntries:
                                  alerts.map((alert) {
                                    return DropdownMenuEntry<Alert>(
                                      value: alert,
                                      label: alert.title,
                                    );
                                  }).toList(),
                              onSelected: (Alert? newValue) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 68),
                      child: Row(
                        children: [
                          Expanded(
                            child: TooltipWidget(
                              title: 'MP-pico2W-LM',
                              content: 'ID matériel',
                              isReversed: true,
                              isCentered: true,
                            ),
                          ),
                          Expanded(
                            child: TooltipWidget(
                              title: '1.0.0.1',
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
                        onPressed: () {
                          //TODO Handle finish cell configuration
                        },
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
}
