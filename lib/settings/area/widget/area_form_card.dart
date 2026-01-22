import 'package:flutter/material.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class AreaFormCard extends StatefulWidget {
  final Area? area;
  final List<Area> availableParents;
  final Function(String name, Area? parentArea) onSave;
  final VoidCallback onCancel;
  final bool isViewMode;

  const AreaFormCard({
    super.key,
    this.area,
    required this.availableParents,
    required this.onSave,
    required this.onCancel,
    this.isViewMode = false,
  });

  @override
  State<AreaFormCard> createState() => _AreaFormCardState();
}

class _AreaFormCardState extends State<AreaFormCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  Area? _selectedParentArea;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.area?.name ?? '');
    _selectedParentArea = widget.area?.parent;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nameController.text.trim(), _selectedParentArea);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.area != null;

    return GardenCard(
      child: Padding(
        padding: EdgeInsets.all(GardenSpace.paddingLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GardenSpace.gapLg,
            children: [
              isEdit
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: GardenSpace.gapSm,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.hexagon_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: GardenSpace.gapXs,
                            children: [
                              Text(
                                widget.area!.name,
                                style: GardenTypography.headingLg,
                              ),
                              Text(
                                'Niveau ${widget.area!.level}',
                                style: GardenTypography.bodyMd.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: GardenSpace.gapSm,
                      children: [
                        Icon(
                          Icons.hexagon_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        Text(
                          'Ajoutez un nouvel espace',
                          style: GardenTypography.headingLg,
                        ),
                      ],
                    ),
              SizedBox(height: GardenSpace.gapMd),
              TextFormField(
                controller: _nameController,
                enabled: !widget.isViewMode,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'espace',
                  hintText: 'Entrez le nom de l\'espace',
                ),
                validator: (value) {
                  if (widget.isViewMode) return null;
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  if (value.trim().length < 3) {
                    return 'Le nom doit contenir au moins 3 caractères';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Area?>(
                initialValue: _selectedParentArea,
                decoration: InputDecoration(
                  labelText: 'Ajouter à',
                  hintText: 'Ajouter à',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                isExpanded: true,
                items: widget.isViewMode
                    ? null
                    : [
                        DropdownMenuItem<Area?>(
                          value: null,
                          child: Text(
                            'Aucun (espace racine)',
                            style: GardenTypography.bodyLg,
                          ),
                        ),
                        ...widget.availableParents.map((area) {
                          return DropdownMenuItem<Area>(
                            value: area,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LevelIndicator(
                                    level: area.level,
                                    size: LevelIndicatorSize.sm,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    area.name,
                                    style: GardenTypography.bodyLg,
                                  ),
                                ),
                                Text(
                                  'Niveau ${area.level}',
                                  style: GardenTypography.bodyLg,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                onChanged: widget.isViewMode
                    ? null
                    : (Area? newValue) {
                        setState(() {
                          _selectedParentArea = newValue;
                        });
                      },
              ),
              if (isEdit) const Spacer(),
              if (!widget.isViewMode && isEdit)
                Container(
                  padding: EdgeInsets.all(GardenSpace.paddingMd),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: GardenSpace.gapSm),
                      Expanded(
                        child: Text(
                          'La modification de l\'emplacement de cet élément entraînera automatiquement le déplacement de l\'ensemble des espaces qui lui sont rattachés. Cette action impactera la structure globale et repositionnera tous les éléments dépendants selon la nouvelle hiérarchie définie.',
                          style: GardenTypography.bodyLg.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.isViewMode)
                Center(
                  child: Button(
                    label: 'Modifier',
                    icon: Icons.edit,
                    onPressed: () {
                      context.go('/settings/areas/${widget.area?.id}');
                    },
                  ),
                )
              else if (!widget.isViewMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: GardenSpace.gapSm,
                  children: [
                    Button(
                      label: 'Annuler',
                      severity: ButtonSeverity.danger,
                      onPressed: widget.onCancel,
                    ),
                    Button(
                      label: isEdit ? 'Modifier' : 'Ajouter',
                      icon: Icons.check,
                      onPressed: _handleSave,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
