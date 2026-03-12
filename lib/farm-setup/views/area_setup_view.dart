import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/bloc/area_bloc.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:go_router/go_router.dart';

import '../../areas/widgets/tab_zones_widget.dart';
import '../../common/widgets/base_item_edit_form_card.dart';

class AreaSetupView extends StatelessWidget {
  final List<Area> areas;

  const AreaSetupView({
    super.key,
    required this.areas
  });

  @override
  Widget build(BuildContext context) {
    Area? selectedArea;
    return BlocBuilder<AreaBloc,AreaState>(
      builder: (context, state) {
        if (state is AreasLoaded) {
          return Column(
            children: [
              TabZonesWidget(title: "test", areas: areas, displayDetailsPanel: false,selectedArea: selectedArea, ),
              BaseItemEditFormCard(
                item: selectedArea,
                availableParents: state.getAvailableParents(
                  selectedArea,
                ),
                initialParent: state.areas
                    .cast<Area?>()
                    .firstWhere(
                      (area) => area!.id == area.parentId,
                  orElse: () => null,
                ),
                isViewMode: false,
                icon: Icons.hexagon_outlined,
                onSave: (name, parentArea) {
                  context.read<AreaBloc>().add(
                    UpdateArea(
                      id: selectedArea!.id,
                      name: name,
                      color: selectedArea.color,
                      parentId: parentArea?.id,
                    ),
                  );
                  context.go('/settings/areas');
                },
                onCancel: () => context.go('/settings/areas'),
                infoText:
                'La modification de l\'emplacement de cet élément entraînera automatiquement le déplacement de l\'ensemble des espaces qui lui sont rattachés. Cette action impactera la structure globale et repositionnera tous les éléments dépendants selon la nouvelle hiérarchie définie.',
              )

            ],
          );
        }else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}