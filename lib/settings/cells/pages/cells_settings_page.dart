import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/common/widgets/generic_list_item.dart';
import 'package:garden_connect/settings/cells/bloc/cells_update_frequency_form_bloc.dart';
import 'package:garden_connect/settings/cells/widgets/cells_update_frequency_form/cells_update_frequency_form_widget.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class CellsSettingsPage extends StatelessWidget {
  const CellsSettingsPage({super.key});

  _onSearch(BuildContext context, String text) {
    context.read<CellBloc>().add(SearchCells(search: text));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    if (user == null) {
      return const Text("Utilisateur non connecté");
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CellBloc()..add(LoadCells())),
        BlocProvider(create: (context) => CellsUpdateFrequencyFormBloc()),
      ],
      child: Builder(
        builder: (context) {
          final cellsState = context.watch<CellBloc>().state;

          if (cellsState is CellInitial || cellsState is CellsShimmer) {
            return const Center(child: CircularProgressIndicator());
          } else if (cellsState is CellError) {
            return Center(child: Text('Erreur: ${cellsState.message}'));
          } else if (cellsState is CellsLoaded) {
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: GardenSpace.paddingLg,
                vertical: GardenSpace.paddingLg,
              ),
              child: Column(
                spacing: GardenSpace.gapLg,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bonjour ${user.firstName}",
                        style: GardenTypography.headingXl,
                      ),
                      IconButton.filled(
                        onPressed: () => context.go('/settings/cells/add'),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: GardenSpace.gapXl,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: GardenSpace.gapMd,
                            children: [
                              TextField(
                                onChanged: (text) => _onSearch(context, text),
                                decoration: InputDecoration(
                                  hintText: 'Rechercher',
                                  prefixIcon: Icon(Icons.search),
                                  hintStyle: GardenTypography.bodyLg.copyWith(
                                    color: GardenColors.typography.shade200,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: GardenSpace.paddingXs,
                                  ),
                                  child: SingleChildScrollView(
                                    controller: ScrollController(),
                                    child: GenericListWidget(
                                      items:
                                          cellsState.filteredCells.map((cell) {
                                            return GenericListItem(
                                              label: cell.name,
                                              icon: Icons.edit,
                                              onTap:
                                                  () => context.go(
                                                    '/settings/cells/${cell.id}?pages=true',
                                                  ),
                                              onEdit:
                                                  () => context.go(
                                                    '/settings/cells/${cell.id}',
                                                  ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              CellsUpdateFrequencyFormWidget(
                                cells: cellsState.cells,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Erreur'));
          }
        },
      ),
    );
  }
}
