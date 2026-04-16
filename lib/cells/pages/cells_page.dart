import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/analytics/models/analytics.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/cells/widgets/cells_cards_widget.dart';
import 'package:garden_connect/cells/widgets/cells_filter_widget.dart';
import 'package:garden_connect/cells/widgets/cells_list_widget.dart';
import 'package:garden_connect/common/widgets/page_header.dart';
import 'package:garden_connect/common/widgets/page_shimmers.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class CellsPage extends StatelessWidget {
  const CellsPage({super.key});

  _onToggleListFormat(BuildContext context) {
    context.read<CellBloc>().add(ToggleCellsDisplayMode());
  }

  _onRefresh(BuildContext context) {
    context.read<CellBloc>().add(RefreshCells());
  }

  _onFilterChanged(BuildContext context, AnalyticType? newFilter) {
    context.read<CellBloc>().add(FilterCellsChanged(filter: newFilter));
  }

  _onSearch(BuildContext context, String text) {
    context.read<CellBloc>().add(SearchCells(search: text));
  }

  _onCellPressed(BuildContext context, String id) {
    context.go('/cells/$id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CellBloc, CellState>(
        builder: (context, cellsState) {
          if (cellsState is CellInitial || cellsState is CellsShimmer) {
            return const CellsPageShimmer();
          } else if (cellsState is CellError) {
            return Center(child: Text('Erreur: ${cellsState.message}'));
          } else if (cellsState is CellsLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: GardenSpace.paddingMd,
                horizontal: GardenSpace.paddingLg,
              ),
              child: SingleChildScrollView(
                child: Column(
                  spacing: GardenSpace.gapLg,
                  children: [
                    PageHeader(
                      title: "Vos cellules",
                      actions: [
                        IconButton.filled(
                          onPressed: () => _onToggleListFormat(context),
                          icon: Icon(
                            cellsState.isList ? Icons.grid_view : Icons.list,
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () => _onRefresh(context),
                          icon: Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: GardenSpace.gapSm,
                      children: [
                        if (!cellsState.isList)
                          Expanded(
                            flex: 1,
                            child: CellsFilterWidget(
                              filter: cellsState.filter,
                              onChanged:
                                  (newFilter) =>
                                      _onFilterChanged(context, newFilter),
                            ),
                          ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            onChanged: (text) => _onSearch(context, text),
                            decoration: InputDecoration(
                              hintText: 'Rechercher',
                              prefixIcon: Icon(Icons.search),
                              hintStyle: GardenTypography.bodyLg.copyWith(
                                color: GardenColors.typography.shade200,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (cellsState.isList)
                      CellsListWidget(
                        cells: cellsState.filteredCells,
                        onPressed: _onCellPressed,
                      )
                    else
                      CellsCardsWidget(
                        cells: cellsState.filteredCells,
                        filter: cellsState.filter,
                        onPressed: _onCellPressed,
                      ),
                  ],
                ),
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
