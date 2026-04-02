import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../models/alert_models.dart';

/// Tableau de sélection des cellules à associer à une alerte.
///
/// Affiche une liste de [CellItem] avec une case à cocher par ligne.
/// Supporte la sélection individuelle et la sélection globale via l'en-tête.
/// Notifie les changements via [onSelectionChanged].
class AlertTableSection extends StatefulWidget {
  /// Liste des cellules disponibles.
  final List<CellItem> cells;

  /// Identifiants des cellules présélectionnées.
  final List<String>? selectedCellIds;

  /// Callback déclenché à chaque changement de sélection.
  final ValueChanged<List<String>>? onSelectionChanged;

  /// Active le mode mobile : scroll libre sans Expanded (hauteur non contrainte).
  final bool isMobile;

  const AlertTableSection({
    super.key,
    required this.cells,
    this.selectedCellIds,
    this.onSelectionChanged,
    this.isMobile = false,
  });

  @override
  State<AlertTableSection> createState() => _AlertTableSectionState();
}

class _AlertTableSectionState extends State<AlertTableSection> {
  bool _selectAll = false;
  final Set<String> _selectedIds = {};

  static const double _colGap = 16;

  @override
  void initState() {
    super.initState();
    _applyInitialSelections();
  }

  /// Initialise les cellules sélectionnées depuis [widget.selectedCellIds].
  void _applyInitialSelections() {
    if (widget.selectedCellIds != null) {
      _selectedIds.addAll(widget.selectedCellIds!);
    }
    _updateSelectAllState();
  }

  /// Met à jour l'état de la case "tout sélectionner" selon la sélection courante.
  void _updateSelectAllState() {
    _selectAll =
        widget.cells.isNotEmpty &&
        widget.cells.every((cell) => _selectedIds.contains(cell.id));
  }

  /// Notifie le parent des identifiants sélectionnés.
  void _notifySelectionChanged() {
    widget.onSelectionChanged?.call(_selectedIds.toList());
  }

  /// Sélectionne ou désélectionne toutes les cellules.
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

  /// Bascule la sélection d'une cellule individuelle.
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GardenSpace.paddingXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTableHeader(),
          SizedBox(height: GardenSpace.gapXs),
          if (widget.isMobile)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.cells.length,
              separatorBuilder: (_, __) => SizedBox(height: GardenSpace.gapXs),
              itemBuilder: (_, index) => _buildCellRow(widget.cells[index]),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.cells.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: GardenSpace.gapXs),
                  itemBuilder: (_, index) => _buildCellRow(widget.cells[index]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GardenSpace.paddingSm,
        vertical: GardenSpace.paddingSm,
      ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerCell('Cellule'),
                _headerCell('Localisation'),
              ],
            ),
          ),
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
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: GardenSpace.paddingSm,
          ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cell.name,
                      style: GardenTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      cell.location.isNotEmpty ? cell.location : '—',
                      style: GardenTypography.bodyMd.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
