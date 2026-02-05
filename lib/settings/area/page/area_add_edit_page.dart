import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/bloc/area_bloc.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:garden_connect/common/widgets/back_text_button.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/info_card.dart';
import '../../../common/widgets/base_item_edit_form_card.dart';
import '../../../common/widgets/danger_zone.dart';

class AreaAddEditPage extends StatelessWidget {
  final int? id;
  final bool isViewMode;

  const AreaAddEditPage({super.key, this.id, this.isViewMode = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AreaBloc()..add(LoadAreas()),
      child: Scaffold(
        body: BlocBuilder<AreaBloc, AreaState>(
          builder: (context, state) {
            if (state is! AreasLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final isEdit = id != null;
            final area =
                isEdit
                    ? Area.getAllAreasFlattened(state.areas)
                        .cast<Area?>()
                        .firstWhere((a) => a?.id == id, orElse: () => null)
                    : null;

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(GardenSpace.paddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackTextButton(
                      backFunction: () => context.go('/settings/areas'),
                    ),
                    SizedBox(height: GardenSpace.gapLg),
                    if (isEdit && area != null)
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 10,
                              child: BaseItemEditFormCard(
                                item: area,
                                availableParents: state.getAvailableParents(area),
                                isViewMode: isViewMode,
                                icon: Icons.hexagon_outlined,
                                onSave: (name, parentArea) {
                                  context.read<AreaBloc>().add(
                                        UpdateArea(
                                          id: area.id,
                                          name: name,
                                          color: area.color,
                                          parentArea: parentArea,
                                        ),
                                      );
                                  context.go('/settings/areas');
                                },
                                onCancel: () => context.go('/settings/areas'),
                                infoText: 'La modification de l\'emplacement de cet élément entraînera automatiquement le déplacement de l\'ensemble des espaces qui lui sont rattachés. Cette action impactera la structure globale et repositionnera tous les éléments dépendants selon la nouvelle hiérarchie définie.',
                              ),
                            ),
                            SizedBox(width: GardenSpace.gapLg),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  InfoCard(
                                    leadingIcon: Icons.hexagon_outlined,
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
                                    description: 'Actions irréversibles sur l\'ensemble des comptes de la ferme.',
                                    deleteButtonLabel: 'Supprimer l\'espace',
                                    onDelete: () {
                                      // TODO: Implémenter la logique de suppression
                                      context.go('/settings/areas');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      BaseItemEditFormCard(
                        item: area,
                        availableParents: state.getAvailableParents(area),
                        icon: Icons.hexagon_outlined,
                        onSave: (name, parentArea) {
                          context.read<AreaBloc>().add(
                                AddArea(
                                  name: name,
                                  color: const Color(0xFFE74C3C),
                                  parentArea: parentArea,
                                ),
                              );
                          context.go('/settings/areas');
                        },
                        onCancel: () => context.go('/settings/areas'),
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
