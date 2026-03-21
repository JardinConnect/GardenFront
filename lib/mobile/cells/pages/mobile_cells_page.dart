import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/cells/bloc/cell_bloc.dart';
import 'package:garden_connect/cells/widgets/cells_cards_widget.dart';
import 'package:garden_connect/mobile/cells/widgets/mobile_cells_list_widget.dart';
import 'package:garden_connect/mobile/common/widgets/mobile_header.dart';
import 'package:garden_ui/ui/design_system.dart';

class MobileCellsPage extends StatelessWidget {
  const MobileCellsPage({super.key});

  _onToggleListFormat(BuildContext context) {
    context.read<CellBloc>().add(ToggleCellsDisplayMode());
  }

  _onRefresh(BuildContext context) {
    context.read<CellBloc>().add(RefreshCells());
  }

  _onSearch(BuildContext context, String text) {
    context.read<CellBloc>().add(SearchCells(search: text));
  }

  _onCellPressed(BuildContext context, String id) {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CellBloc, CellState>(
      builder: (context, cellsState) {
        if (cellsState is CellInitial || cellsState is CellsShimmer) {
          return const Center(child: CircularProgressIndicator());
        } else if (cellsState is CellError) {
          return Center(child: Text('Erreur: ${cellsState.message}'));
        } else if (cellsState is CellsLoaded) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: GardenSpace.paddingLg,
                  vertical: GardenSpace.paddingMd,
                ),
                child: Column(
                  spacing: GardenSpace.gapMd,
                  children: [
                    MobileHeader(
                      actionsButtons: [
                        IconButton(
                          onPressed: () => _onToggleListFormat(context),
                          icon: Icon(
                            cellsState.isList ? Icons.grid_view : Icons.list,
                            color: GardenColors.primary.shade500,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
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
                        IconButton(
                          onPressed: () => _onRefresh(context),
                          icon: Icon(
                            Icons.refresh,
                            color: GardenColors.primary.shade500,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Vos Cellules",
                          style: GardenTypography.bodyLg.copyWith(
                            fontWeight: FontWeight.w600,
                            color: GardenTypography.caption.color,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child:
                          cellsState.isList
                              ? MobileCellsListWidget(
                                cells: cellsState.filteredCells,
                                onPressed: _onCellPressed,
                              )
                              : SingleChildScrollView(
                                child: CellsCardsWidget(
                                  cells: cellsState.filteredCells,
                                  filter: cellsState.filter,
                                  onPressed: _onCellPressed,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('Erreur'));
        }
      },
    );
  }
}
