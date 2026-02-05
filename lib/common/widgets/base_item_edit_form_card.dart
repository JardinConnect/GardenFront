import 'package:flutter/material.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:garden_connect/common/models/base_item.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

class BaseItemEditFormCard extends StatefulWidget {
  final BaseItem? item;
  final List<Area> availableParents;
  final Function(String name, Area? parentArea) onSave;
  final VoidCallback onCancel;
  final bool isViewMode;
  final IconData icon;
  final String? infoText;

  const BaseItemEditFormCard({
    super.key,
    this.item,
    required this.availableParents,
    required this.onSave,
    required this.onCancel,
    required this.icon,
    this.isViewMode = false,
    this.infoText,
  });

  @override
  State<BaseItemEditFormCard> createState() => _BaseItemEditFormCardState();
}

class _BaseItemEditFormCardState extends State<BaseItemEditFormCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  Area? _selectedParentArea;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _selectedParentArea =
        widget.item == null || widget.item!.parentId == null
            ? null
            : widget.availableParents.cast<Area?>().firstWhere(
              (area) => area!.id == widget.item!.parentId!,
              orElse: () => null,
            );
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
    final isEdit = widget.item != null;

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
                          widget.icon,
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
                              widget.item!.name,
                              style: GardenTypography.headingLg,
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
                items:
                    widget.isViewMode
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
                onChanged:
                    widget.isViewMode
                        ? null
                        : (Area? newValue) {
                          setState(() {
                            _selectedParentArea = newValue;
                          });
                        },
              ),
              if (!widget.isViewMode && isEdit && widget.infoText != null)
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
                          widget.infoText!,
                          style: GardenTypography.bodyLg.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              if (widget.isViewMode)
                Center(
                  child: Button(
                    label: 'Modifier',
                    icon: Icons.edit,
                    onPressed: () {
                      context.go('/settings/areas/${widget.item?.id}');
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
