import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

/// Modèle pour représenter un espace avec sa localisation hiérarchique
class SpaceLocation {
  final String id;
  final String name;
  final String serre;
  final String chapelle;
  final String planche;
  bool isSelected;

  SpaceLocation({
    required this.id,
    required this.name,
    required this.serre,
    required this.chapelle,
    required this.planche,
    this.isSelected = false,
  });

  String get fullLocation => '$serre > $chapelle > $planche';
}

/// Composant pour la section du tableau de sélection des espaces
class AlertTableSection extends StatefulWidget {
  final List<String>? selectedSpaceIds;
  final ValueChanged<List<String>>? onSelectionChanged;

  const AlertTableSection({
    super.key,
    this.selectedSpaceIds,
    this.onSelectionChanged,
  });

  @override
  State<AlertTableSection> createState() => _AlertTableSectionState();
}

class _AlertTableSectionState extends State<AlertTableSection> {
  late List<SpaceLocation> _spaces;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _initializeSpaces();
  }

  void _initializeSpaces() {
    _spaces = [
      SpaceLocation(
        id: '1',
        name: 'Cellule A',
        serre: 'Serre Principale',
        chapelle: 'Chapelle Nord',
        planche: 'Planche 01',
      ),
      SpaceLocation(
        id: '2',
        name: 'Cellule B',
        serre: 'Serre Principale',
        chapelle: 'Chapelle Nord',
        planche: 'Planche 02',
      ),
      SpaceLocation(
        id: '3',
        name: 'Cellule C',
        serre: 'Serre Principale',
        chapelle: 'Chapelle Sud',
        planche: 'Planche 15',
      ),
      SpaceLocation(
        id: '4',
        name: 'Cellule D',
        serre: 'Serre Secondaire',
        chapelle: 'Chapelle Est',
        planche: 'Planche 19',
      ),
      SpaceLocation(
        id: '5',
        name: 'Cellule E',
        serre: 'Serre Secondaire',
        chapelle: 'Chapelle Est',
        planche: 'Planche 20',
      ),
      SpaceLocation(
        id: '6',
        name: 'Cellule F',
        serre: 'Serre Annexe',
        chapelle: 'Chapelle Unique',
        planche: 'Planche 05',
      ),
    ];

    // Appliquer les sélections initiales si fournies
    if (widget.selectedSpaceIds != null) {
      for (var space in _spaces) {
        space.isSelected = widget.selectedSpaceIds!.contains(space.id);
      }
    }
    _updateSelectAllState();
  }

  void _updateSelectAllState() {
    _selectAll = _spaces.every((space) => space.isSelected);
  }

  void _notifySelectionChanged() {
    final selectedIds = _spaces
        .where((space) => space.isSelected)
        .map((space) => space.id)
        .toList();
    widget.onSelectionChanged?.call(selectedIds);
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var space in _spaces) {
        space.isSelected = _selectAll;
      }
    });
    _notifySelectionChanged();
  }

  void _toggleSpaceSelection(SpaceLocation space, bool? value) {
    setState(() {
      space.isSelected = value ?? false;
      _updateSelectAllState();
    });
    _notifySelectionChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${_spaces.where((s) => s.isSelected).length} / ${_spaces.length} sélectionnés',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // En-tête du tableau
        _buildTableHeader(),
        const SizedBox(height: 8),

        // Lignes du tableau
        Expanded(
          child: ListView.builder(
            itemCount: _spaces.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: _buildSpaceRow(_spaces[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return GardenCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            // Checkbox pour sélectionner tout
            SizedBox(
              width: 32,
              child: Checkbox(
                value: _selectAll,
                onChanged: _toggleSelectAll,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 12),
            // En-tête Cellule
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Cellule',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            // En-tête Localisation
            Expanded(
              flex: 3,
              child: Text(
                'Localisation',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaceRow(SpaceLocation space) {
    return GardenCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3), // Réduit de 4 à 3
        child: Row(
          children: [
            // Checkbox
            SizedBox(
              width: 32,
              child: Checkbox(
                value: space.isSelected,
                onChanged: (value) => _toggleSpaceSelection(space, value),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 12),
            // Nom de la cellule
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  space.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Localisation hiérarchique
            Expanded(
              flex: 3,
              child: Text(
                space.fullLocation,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.1,
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
