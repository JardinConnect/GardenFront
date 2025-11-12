import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/foundation/color/color_design_system.dart';

class NodeComparison extends StatelessWidget {
  const NodeComparison({super.key});

  Widget _buildSelect(List<String> values) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: values.first,
        autofocus: true,
        isDense: true,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        items:
            values.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.black)),
              );
            }).toList(),
        onChanged: (_) {},
      ),
    );
  }

  Widget _buildNode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Boitier 5', style: GardenTypography.headingSm),
            SizedBox(width: GardenSpace.paddingXs),
            Icon(
              Icons.remove_red_eye_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 15,
            ),
            SizedBox(width: GardenSpace.paddingXs),
            Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.primary,
              size: 15,
            ),
          ],
        ),
        Text(
          'Champ Nord > Planche-2 > Noeud-35',
          style: GardenTypography.bodyMd,
        ),
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
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: GardenSpace.paddingSm),
            Text('-5°C', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO prendre les données de l'api
    const analytics = ['Température', 'Humidité', 'Luminosité'];
    const areas = ['Espace 1', 'Espace 2', 'Espace 3'];
    const nodes = ['Cellule 1', 'Cellule 2', 'Cellule 3'];

    return Column(
      children: [
        Row(
          children: [
            _buildSelect(analytics),
            _buildSelect(areas),
            _buildSelect(nodes),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            _buildNode(context),
            SizedBox(width: GardenSpace.paddingSm),
            _buildNode(context),
            SizedBox(width: GardenSpace.paddingSm),
            _buildNode(context),
            SizedBox(width: GardenSpace.paddingSm),
            _buildNode(context),
          ],
        ),
      ],
    );
  }
}
