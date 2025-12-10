import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import '../models/area.dart';
import '../bloc/area_bloc.dart';

class AddAreaFormWidget extends StatefulWidget {
  final List<Area> availableAreas;

  const AddAreaFormWidget({super.key, required this.availableAreas});

  @override
  State<AddAreaFormWidget> createState() => _AddAreaFormWidgetState();
}

class _AddAreaFormWidgetState extends State<AddAreaFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Area? _selectedParentArea;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<Area> _getAllAreasFlat(List<Area> areas) {
    List<Area> flatList = [];
    for (var area in areas) {
      flatList.add(area);
      if (area.areas != null && area.areas!.isNotEmpty) {
        flatList.addAll(_getAllAreasFlat(area.areas!));
      }
    }
    return flatList;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String newAreaName = _nameController.text.trim();
      Color areaColor = _selectedParentArea?.color ?? const Color(0xFF9B59B6);
      context.read<AreaBloc>().add(
        AddArea(
          name: newAreaName,
          color: areaColor,
          parentArea: _selectedParentArea,
        ),
      );

      _nameController.clear();
      setState(() {
        _selectedParentArea = null;
      });

      final mediaQuery = MediaQuery.of(context);
      final screenWidth = mediaQuery.size.width;
      final screenHeight = mediaQuery.size.height;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: NotificationToast(
            title: 'Nouvel Espace',
            message: "L'espace : $newAreaName a été ajouté avec succès !",
            size: NotificationSize.md,
            severity: NotificationSeverity.success,
          ),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: screenHeight - 100,
            right: 20,
            left: screenWidth - 400,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final flatAreas = _getAllAreasFlat(widget.availableAreas);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nouvel Espace', style: GardenTypography.displayLg),
        Padding(
          padding: const EdgeInsets.all(150),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom de l\'espace *',
                    labelStyle: GardenTypography.bodyLg,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un nom pour l\'espace';
                    }
                    if (value.trim().length < 3) {
                      return 'Le nom doit contenir au moins 3 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
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
                  items: [
                    DropdownMenuItem<Area?>(
                      value: null,
                      child: Text(
                        'Aucun (espace racine)',
                        style: GardenTypography.bodyLg,
                      ),
                    ),
                    ...flatAreas.map((area) {
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
                  onChanged: (Area? newValue) {
                    setState(() {
                      _selectedParentArea = newValue;
                    });
                  },
                ),
                const SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                      label: 'Annuler',
                      icon: Icons.backspace_outlined,
                      severity: ButtonSeverity.danger,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    Button(
                      label: 'Terminer',
                      icon: Icons.check_circle_outline_outlined,
                      onPressed: () => _submitForm(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
