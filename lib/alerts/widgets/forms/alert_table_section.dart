import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import '../../repository/alert_repository.dart';

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

  /// Construit un SpaceLocation depuis les données JSON de l'API
  factory SpaceLocation.fromJson(Map<String, dynamic> json) {
    return SpaceLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      serre: json['serre'] as String,
      chapelle: json['chapelle'] as String,
      planche: json['planche'] as String,
      isSelected: false,
    );
  }

  String get fullLocation => '$serre > $chapelle > $planche';
}

/// Composant pour la section du tableau de sélection des espaces
/// Récupère la liste des espaces depuis le repository
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
  List<SpaceLocation> _spaces = [];
  bool _selectAll = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSpaces();
  }

  /// Charge la liste des espaces depuis le repository
  Future<void> _loadSpaces() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Récupère le repository depuis le contexte (via le Bloc)
      final repository = AlertRepository();
      final spacesData = await repository.fetchSpaces();

      // Convertit les données JSON en objets SpaceLocation
      final loadedSpaces = spacesData
          .map((json) => SpaceLocation.fromJson(json))
          .toList();

      setState(() {
        _spaces = loadedSpaces;

        // Applique les sélections initiales si fournies
        if (widget.selectedSpaceIds != null) {
          for (var space in _spaces) {
            space.isSelected = widget.selectedSpaceIds!.contains(space.id);
          }
        }

        _updateSelectAllState();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des espaces: $e';
        _isLoading = false;
      });
    }
  }

  /// Met à jour l'état "tout sélectionner"
  void _updateSelectAllState() {
    _selectAll = _spaces.isNotEmpty && _spaces.every((space) => space.isSelected);
  }

  /// Notifie le parent que la sélection a changé
  void _notifySelectionChanged() {
    final selectedIds = _spaces
        .where((space) => space.isSelected)
        .map((space) => space.id)
        .toList();
    widget.onSelectionChanged?.call(selectedIds);
  }

  /// Bascule la sélection de tous les espaces
  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var space in _spaces) {
        space.isSelected = _selectAll;
      }
    });
    _notifySelectionChanged();
  }

  /// Bascule la sélection d'un espace spécifique
  void _toggleSpaceSelection(SpaceLocation space, bool? value) {
    setState(() {
      space.isSelected = value ?? false;
      _updateSelectAllState();
    });
    _notifySelectionChanged();
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un indicateur de chargement
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Afficher un message d'erreur
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSpaces,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Compteur de sélection
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
  Widget _buildSpaceRow(SpaceLocation space) {
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

