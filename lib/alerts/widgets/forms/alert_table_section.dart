import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';

/// Composant pour la section du tableau de sélection des espaces
class AlertTableSection extends StatefulWidget {
  final List<Map<String, dynamic>> spaces;
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
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _applyInitialSelections();
  }

  /// Applique les sélections initiales si fournies
  void _applyInitialSelections() {
    if (widget.selectedSpaceIds != null) {
      _selectedIds.addAll(widget.selectedSpaceIds!);
    }
    _updateSelectAllState();
  }

  /// Met à jour l'état "tout sélectionner"
  void _updateSelectAllState() {
    _selectAll = widget.spaces.isNotEmpty && 
                 widget.spaces.every((space) => _selectedIds.contains(space['id']));
  }

  /// Notifie le parent que la sélection a changé
  void _notifySelectionChanged() {
    widget.onSelectionChanged?.call(_selectedIds.toList());
  }

  /// Bascule la sélection de tous les espaces
  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      if (_selectAll) {
        _selectedIds.addAll(widget.spaces.map((space) => space['id'] as String));
      } else {
        _selectedIds.clear();
      }
    });
    _notifySelectionChanged();
  }

  /// Bascule la sélection d'un espace spécifique
  void _toggleSpaceSelection(Map<String, dynamic> space, bool? value) {
    setState(() {
      final id = space['id'] as String;
      if (value == true) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
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
              '${_selectedIds.length} / ${widget.spaces.length} sélectionnés',
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
  Widget _buildSpaceRow(Map<String, dynamic> space) {
    final id = space['id'] as String;
    final name = space['name'] as String;
    final serre = space['serre'] as String;
    final chapelle = space['chapelle'] as String;
    final planche = space['planche'] as String;
    final fullLocation = '$serre > $chapelle > $planche';
    
    return GardenCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        child: Row(
          children: [
            // Checkbox de sélection
            SizedBox(
              width: 32,
              child: Checkbox(
                value: _selectedIds.contains(id),
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
                  name,
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
                fullLocation,
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