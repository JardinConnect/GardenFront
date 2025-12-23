import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../../models/alert_models.dart';

/// Composant pour la section du tableau de sélection des espaces
class AlertTableSection extends StatefulWidget {
  final List<Space> spaces;
  final List<String>? selectedSpaceIds;
  final ValueChanged<List<String>>? onSelectionChanged;

  const AlertTableSection({
    super.key,
    required this.spaces,
    this.selectedSpaceIds,
    this.onSelectionChanged,
  });

  @override
  State<AlertTableSection> createState() => _AlertTableSectionState();
}

class _AlertTableSectionState extends State<AlertTableSection> {
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _applyInitialSelections();
  }

  /// Applique les sélections initiales si fournies
  void _applyInitialSelections() {
    if (widget.selectedSpaceIds != null) {
      for (var space in widget.spaces) {
        space.isSelected = widget.selectedSpaceIds!.contains(space.id);
      }
    }
    _updateSelectAllState();
  }

  /// Met à jour l'état "tout sélectionner"
  void _updateSelectAllState() {
    _selectAll = widget.spaces.isNotEmpty && widget.spaces.every((space) => space.isSelected);
  }

  /// Notifie le parent que la sélection a changé
  void _notifySelectionChanged() {
    final selectedIds = widget.spaces
        .where((space) => space.isSelected)
        .map((space) => space.id)
        .toList();
    widget.onSelectionChanged?.call(selectedIds);
  }

  /// Bascule la sélection de tous les espaces
  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var space in widget.spaces) {
        space.isSelected = _selectAll;
      }
    });
    _notifySelectionChanged();
  }

  /// Bascule la sélection d'un espace spécifique
  void _toggleSpaceSelection(Space space, bool? value) {
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
        // Compteur de sélection
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${widget.spaces.where((s) => s.isSelected).length} / ${widget.spaces.length} sélectionnés',
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
            itemCount: widget.spaces.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: _buildSpaceRow(widget.spaces[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Construit l'en-tête du tableau avec la checkbox de sélection globale
  Widget _buildTableHeader() {
    return GardenCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            // Checkbox pour sélectionner/désélectionner tous les espaces
            SizedBox(
              width: 32,
              child: Checkbox(
                value: _selectAll,
                onChanged: _toggleSelectAll,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 12),

            // Colonne : Nom de la cellule
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

            // Colonne : Localisation hiérarchique
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

  /// Construit une ligne du tableau pour un espace donné
  Widget _buildSpaceRow(Space space) {
    return GardenCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        child: Row(
          children: [
            // Checkbox de sélection
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

            // Localisation complète (Serre > Chapelle > Planche)
            Expanded(
              flex: 3,
              child: Text(
                space.fullLocation,
                style: TextStyle(
                  fontSize: 12,
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