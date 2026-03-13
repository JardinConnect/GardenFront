import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../models/alert_models.dart';

/// Composant pour la section du tableau de sélection des cellules
class AlertTableSection extends StatefulWidget {
  final List<CellItem> cells;
  final List<String>? selectedCellIds;
  final ValueChanged<List<String>>? onSelectionChanged;

  const AlertTableSection({
    super.key,
    required this.cells,
    this.selectedCellIds,
    this.onSelectionChanged,
  });

  @override
  State<AlertTableSection> createState() => _AlertTableSectionState();
}

class _AlertTableSectionState extends State<AlertTableSection> {
  bool _selectAll = false;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _applyInitialSelections();
  }

  void _applyInitialSelections() {
    if (widget.selectedCellIds != null) {
      _selectedIds.addAll(widget.selectedCellIds!);
    }
    _updateSelectAllState();
  }

  void _updateSelectAllState() {
    _selectAll =
        widget.cells.isNotEmpty &&
        widget.cells.every((cell) => _selectedIds.contains(cell.id));
  }

  void _notifySelectionChanged() {
    widget.onSelectionChanged?.call(_selectedIds.toList());
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      if (_selectAll) {
        _selectedIds.addAll(widget.cells.map((cell) => cell.id));
      } else {
        _selectedIds.clear();
      }
    });
    _notifySelectionChanged();
  }

  void _toggleCellSelection(CellItem cell) {
    setState(() {
      if (_selectedIds.contains(cell.id)) {
        _selectedIds.remove(cell.id);
      } else {
        _selectedIds.add(cell.id);
      }
      _updateSelectAllState();
    });
    _notifySelectionChanged();
  }

  static const double _colGap = 16;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTableHeader(),
          SizedBox(height: GardenSpace.gapXs),
          Expanded(
            child: ListView.separated(
              itemCount: widget.cells.length,
              separatorBuilder: (_, __) => SizedBox(height: GardenSpace.gapXs),
              itemBuilder: (_, index) => _buildCellRow(widget.cells[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingSm, vertical: GardenSpace.paddingSm),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: GardenRadius.radiusSm,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 20,
            child: Checkbox(
              value: _selectAll,
              onChanged: _toggleSelectAll,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: _colGap),
          Expanded(flex: 2, child: _headerCell('Cellule')),
          const SizedBox(width: _colGap),
          Expanded(flex: 3, child: _headerCell('Localisation')),
          const SizedBox(width: _colGap),
          Text(
            '${_selectedIds.length}/${widget.cells.length}',
            style: GardenTypography.bodyMd.copyWith(
              color: GardenColors.typography.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String label) {
    return Text(
      label,
      style: GardenTypography.bodyMd.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildCellRow(CellItem cell) {
    final isSelected = _selectedIds.contains(cell.id);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _toggleCellSelection(cell),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: GardenSpace.paddingSm),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: GardenRadius.radiusSm,
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleCellSelection(cell),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: _colGap),
              Expanded(
                flex: 2,
                child: Text(
                  cell.name,
                  style: GardenTypography.bodyMd.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: _colGap),
              Expanded(
                flex: 3,
                child: Text(
                  cell.location.isNotEmpty ? cell.location : '—',
                  style: GardenTypography.bodyMd.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: _colGap),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
