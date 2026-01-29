import 'package:flutter/material.dart';
import 'package:garden_connect/areas/models/area.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class AreaInfoCard extends StatelessWidget {
  final Area area;

  const AreaInfoCard({
    super.key,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return GardenCard(
      child: Padding(
        padding: EdgeInsets.all(GardenSpace.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: GardenSpace.gapMd,
          children: [
            // En-tête avec nom et niveau
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: GardenSpace.gapSm,
              children: [
                Icon(
                  Icons.hexagon_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: GardenSpace.gapXs,
                    children: [
                      Text(
                        area.name,
                        style: GardenTypography.headingMd,
                      ),
                      Text(
                        'Niveau ${area.level}',
                        style: GardenTypography.bodyMd.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300]),
            // Informations de création
            _buildInfoSection(
              context: context,
              icon: Icons.person_add_outlined,
              label: 'Création',
              name: 'Alexandre LEFAY',
              date: '15 janvier 2025',
            ),
            Divider(color: Colors.grey[300]),
            // Informations de dernière modification
            _buildInfoSection(
              context: context,
              icon: Icons.edit_outlined,
              label: 'Dernière modification',
              name: 'Benjamin COUET',
              date: '20 janvier 2025',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String name,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: GardenSpace.gapSm,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: GardenSpace.gapXs),
            Text(
              label,
              style: GardenTypography.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: GardenSpace.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GardenSpace.gapXs,
            children: [
              Row(
                children: [
                  Text(
                    'Par : ',
                    style: GardenTypography.bodyMd.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    name,
                    style: GardenTypography.bodyMd,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Date : ',
                    style: GardenTypography.bodyMd.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    date,
                    style: GardenTypography.bodyMd,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
