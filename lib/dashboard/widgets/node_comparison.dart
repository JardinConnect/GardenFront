import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../analytics/models/analytics.dart';
import '../../areas/models/area.dart';
import '../../cells/models/cell.dart';

class NodeComparison extends StatefulWidget {
  const NodeComparison({super.key, required this.areas});

  final List<Area> areas;

  @override
  State<NodeComparison> createState() => _NodeComparisonState();
}

class _NodeComparisonState extends State<NodeComparison> {
  AnalyticType? _selectedAnalyticType;
  String? _selectedAreaId;
  List<Cell> _selectedCells = [];

  List<AnalyticType> get _availableTypes {
    final types = <AnalyticType>{};
    for (final area in Area.getAllAreasFlattened(widget.areas)) {
      for (final type in area.analytics.availableTypes) {
        types.add(type);
      }
    }
    return types.toList();
  }

  List<Area> get _areasWithCells {
    final seen = <String>{};
    return Area.getAllAreasFlattened(
      widget.areas,
    ).where((a) => seen.add(a.id)).toList();
  }

  Area? get _selectedArea =>
      _selectedAreaId == null
          ? null
          : Area.findAreaById(widget.areas, _selectedAreaId!);

  List<Cell> get _availableCells {
    if (_selectedArea == null) return [];
    return _getAllCellsRecursively(_selectedArea!);
  }

  List<Cell> _getAllCellsRecursively(Area area) {
    final cells = <Cell>[...?area.cells];
    for (final subArea in area.areas ?? []) {
      cells.addAll(_getAllCellsRecursively(subArea));
    }
    return cells;
  }

  bool get _isCellFilterEnabled =>
      _selectedAnalyticType != null && _selectedAreaId != null;

  void _autoSelectSingleCellIfNeeded() {
    if (_isCellFilterEnabled && _availableCells.length == 1) {
      _selectedCells = [_availableCells.first];
    }
  }

  void _onAreaChanged(String? areaId) {
    setState(() {
      _selectedAreaId = areaId;
      _selectedCells = [];
      _autoSelectSingleCellIfNeeded();
    });
  }

  void _onAnalyticTypeChanged(AnalyticType? type) {
    setState(() {
      _selectedAnalyticType = type;
      _selectedCells = [];
      _autoSelectSingleCellIfNeeded();
    });
  }

  void _toggleCell(Cell cell) {
    setState(() {
      if (_selectedCells.any((c) => c.id == cell.id)) {
        _selectedCells = _selectedCells.where((c) => c.id != cell.id).toList();
      } else {
        _selectedCells = [..._selectedCells, cell];
      }
    });
  }

  Widget _buildMesureDropdown() {
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AnalyticType>(
          hint: Text('Mesure', style: GardenTypography.bodyMd),
          value: _selectedAnalyticType,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          items: _availableTypes.map((type) {
            return DropdownMenuItem<AnalyticType>(
              value: type,
              child: Row(
                children: [
                  GardenIcon(
                    iconName: type.iconName,
                    color: type.iconColor,
                    size: GardenIconSize.sm,
                  ),
                  const SizedBox(width: 6),
                  Text(type.name, style: GardenTypography.bodyMd),
                ],
              ),
            );
          }).toList(),
          onChanged: _onAnalyticTypeChanged,
        ),
      ),
    );
  }

  Widget _buildAreaDropdown() {
    final areas = _areasWithCells;

    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text('Espace', style: GardenTypography.bodyMd),
          value: _selectedAreaId,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          items: areas.map((area) {
            return DropdownMenuItem<String>(
              value: area.id,
              child: Row(
                children: [
                  LevelIndicator(level: area.level),
                  const SizedBox(width: 8),
                  Text(area.name, style: GardenTypography.bodyMd),
                ],
              ),
            );
          }).toList(),
          onChanged: _onAreaChanged,
        ),
      ),
    );
  }

  Widget _buildMultiCellSelect() {
    final bool enabled = _isCellFilterEnabled;

    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: PopupMenuButton<Cell>(
          tooltip: '',
          offset: const Offset(0, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemBuilder: (context) {
            if (_availableCells.isEmpty) {
              return [
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    'Aucune cellule disponible',
                    style: GardenTypography.bodyMd,
                  ),
                ),
              ];
            }
            return _availableCells.map((cell) {
              return PopupMenuItem<Cell>(
                value: cell,
                padding: EdgeInsets.zero,
                child: _CellCheckboxItem(
                  cell: cell,
                  isChecked: _selectedCells.any((c) => c.id == cell.id),
                  onToggle: () {
                    _toggleCell(cell);
                  },
                ),
              );
            }).toList();
          },
          onSelected: (_) {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedCells.isEmpty
                      ? 'Cellules'
                      : '${_selectedCells.length} cellule(s)',
                  style: GardenTypography.bodyMd,
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNodeRow(BuildContext context, Cell cell) {
    final analytic = cell.analytics.getLastAnalyticByType(_selectedAnalyticType!);
    final value = analytic?.value;

    double barFraction = 0;
    if (value != null && _selectedCells.isNotEmpty) {
      double maxVal = 0;
      for (final c in _selectedCells) {
        final a = c.analytics.getLastAnalyticByType(_selectedAnalyticType!);
        if (a != null && a.value.abs() > maxVal) maxVal = a.value.abs();
      }
      if (maxVal > 0) barFraction = value.abs() / maxVal;
    }

    final color = _selectedAnalyticType?.color ?? Theme.of(context).colorScheme.primary;
    final unit = _selectedAnalyticType?.unit ?? '';
    final displayValue = value != null ? '${value.toStringAsFixed(1)}$unit' : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(cell.name, style: GardenTypography.headingSm),
              SizedBox(width: GardenSpace.paddingXs),
              GestureDetector(
                onTap: () => _toggleCell(cell),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.primary,
                  size: 15,
                ),
              ),
            ],
          ),
          if (cell.location != null)
            Text(cell.location!, style: GardenTypography.bodyMd),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: GardenColors.primary.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: barFraction.clamp(0.0, 1.0),
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: GardenSpace.paddingSm),
              Text(
                displayValue,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMesureDropdown(),
              _buildAreaDropdown(),
              _buildMultiCellSelect(),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedCells.isEmpty && _isCellFilterEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Sélectionnez des cellules pour comparer.',
                style: GardenTypography.bodyMd,
              ),
            ),
          if (!_isCellFilterEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Sélectionnez une mesure et un espace pour activer la comparaison.',
                style: GardenTypography.bodyMd,
              ),
            ),
          ..._selectedCells.map((cell) => _buildNodeRow(context, cell)),
        ],
      ),
    );
  }
}

class _CellCheckboxItem extends StatefulWidget {
  final Cell cell;
  final bool isChecked;
  final VoidCallback onToggle;

  const _CellCheckboxItem({
    required this.cell,
    required this.isChecked,
    required this.onToggle,
  });

  @override
  State<_CellCheckboxItem> createState() => _CellCheckboxItemState();
}

class _CellCheckboxItemState extends State<_CellCheckboxItem> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.isChecked;
  }

  @override
  void didUpdateWidget(_CellCheckboxItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      _checked = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _checked ? GardenColors.base.shade200 : Colors.transparent,
      child: CheckboxListTile(
        value: _checked,
        dense: true,
        title: Text(
          widget.cell.name,
          style: GardenTypography.bodyMd,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (_) {
          setState(() {
            _checked = !_checked;
          });
          widget.onToggle();
        },
      ),
    );
  }
}