import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/cells/models/analytic_metric.dart';
import 'package:garden_connect/cells/widgets/cells_grid.dart';
import 'package:garden_ui/ui/design_system.dart';

class CellsPage extends StatelessWidget {
  const CellsPage({super.key});

  _onToggleListFormat(BuildContext context) {
    context.read<CellBloc>().add(ToggleCellsDisplayMode());
  }

  _onRefresh(BuildContext context) {
    context.read<CellBloc>().add(RefreshCells());
  }

  _onFilterChanged(BuildContext context, AnalyticMetric? newFilter) {
    context.read<CellBloc>().add(FilterCellsChanged(filter: newFilter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CellBloc()..add(LoadCells())),
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
                padding: EdgeInsets.symmetric(
                  horizontal: GardenSpace.paddingLg,
                  vertical: GardenSpace.paddingLg,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: GardenSpace.gapLg,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: GardenSpace.gapSm,
                              children: [
                                DropdownButtonFormField<AnalyticMetric>(
                                  decoration: const InputDecoration(
                                    hintText: "Filtre",
                                  ),
                                  dropdownColor: GardenColors.base.shade50,
                                  style: GardenTypography.bodyMd.copyWith(
                                    color: GardenColors.typography.shade900,
                                  ),
                                  initialValue: cellsState.filter,
                                  isExpanded: true,
                                  items: [
                                    DropdownMenuItem(
                                      value: null,
                                      child: Text(
                                        "Aucun filtre",
                                        style: GardenTypography.bodyMd.copyWith(
                                          color:
                                              GardenColors.typography.shade900,
                                        ),
                                      ),
                                    ),
                                    ...AnalyticMetric.values.map(
                                      (metric) => DropdownMenuItem(
                                        value: metric,
                                        child: Text(
                                          metric.label,
                                          style:
                                              GardenTypography.bodyMd.copyWith(
                                            color: GardenColors
                                                .typography.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged:
                                      (newFilter) =>
                                          _onFilterChanged(context, newFilter),
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Rechercher',
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            spacing: GardenSpace.gapSm,
                            children: [
                              IconButton.filled(
                                onPressed: () => _onToggleListFormat(context),
                                icon: Icon(Icons.list),
                              ),
                              IconButton.filled(
                                onPressed: () => _onRefresh(context),
                                icon: Icon(Icons.refresh),
                              ),
                            ],
                          ),
                        ],
                      ),

                      if (cellsState.isList)
                        Text("List")
                      else
                        CellsGrid(
                          cells: cellsState.cells,
                          filter: cellsState.filter,
                        ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Erreur'),
              );
            }
          },
        ),
      ),
    );
  }
}
