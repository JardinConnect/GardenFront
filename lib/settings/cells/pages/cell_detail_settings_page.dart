import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/bloc/area_bloc.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/common/widgets/back_text_button.dart';
import 'package:garden_connect/common/widgets/danger_zone.dart';
import 'package:garden_connect/common/widgets/info_card.dart';
import 'package:garden_connect/common/widgets/base_item_edit_form_card.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class CellDetailSettingsPage extends StatelessWidget {
  final String id;
  final bool isViewMode;

  const CellDetailSettingsPage({
    super.key,
    required this.id,
    this.isViewMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CellBloc()..add(LoadCellDetail(id: id)),
        ),
        BlocProvider(create: (context) => AreaBloc()..add(LoadAreas())),
      ],
      child: Scaffold(
        body: Builder(
          builder: (context) {
            final cellsState = context.watch<CellBloc>().state;
            final areasState = context.watch<AreaBloc>().state;

            if (cellsState is! CellDetailLoaded || areasState is! AreasLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final cell = cellsState.cell;
            final areas = areasState.areas;

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(GardenSpace.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackTextButton(backFunction: () => context.pop()),
                    SizedBox(height: GardenSpace.gapLg),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 10,
                            child: BaseItemEditFormCard(
                              item: cell,
                              availableParents: areas,
                              initialParent: areas.cast<Area?>().firstWhere(
                                (area) => area!.id == cell.parentId,
                                orElse: () => null,
                              ),
                              isViewMode: isViewMode,
                              icon: Icons.sensors,
                              onSave: (name, parentArea) {
                                context.read<CellBloc>().add(
                                  UpdateCell(
                                    id: cell.id,
                                    name: name,
                                    isTracked: cell.isTracked!,
                                    parentId: parentArea?.id,
                                  ),
                                );
                                context.go('/settings/cells');
                              },
                              onCancel: () => context.go('/settings/cells'),
                              infoText:
                                  'Cette action impactera la structure globale et repositionnera tous les éléments dépendants selon la nouvelle hiérarchie définie.',
                            ),
                          ),
                          SizedBox(width: GardenSpace.gapLg),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InfoCard(
                                  leadingIcon: Icons.sensors,
                                  sections: const [
                                    InfoSectionData(
                                      icon: Icons.person_add_outlined,
                                      label: 'Création',
                                      name: 'Alexandre LEFAY',
                                      date: '15 janvier 2025',
                                    ),
                                    InfoSectionData(
                                      icon: Icons.edit_outlined,
                                      label: 'Dernière modification',
                                      name: 'Benjamin COUET',
                                      date: '20 janvier 2025',
                                    ),
                                  ],
                                ),
                                SizedBox(height: GardenSpace.gapLg),
                                DangerZone(
                                  title: 'Zone de danger',
                                  description:
                                      'Actions irréversibles sur l\'ensemble des comptes de la ferme.',
                                  deleteButtonLabel: 'Supprimer la cellule',
                                  onDelete: () {
                                    context.read<CellBloc>().add(
                                      DeleteCell(id: cell.id),
                                    );
                                    context.go('/settings/cells');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
