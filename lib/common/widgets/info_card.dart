// dart
import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

class InfoCard extends StatelessWidget {
  final IconData leadingIcon;
  final List<InfoSectionData> sections;

  const InfoCard({
    super.key,
    required this.leadingIcon,
    required this.sections,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: GardenSpace.gapSm,
              children: [
                Icon(
                  leadingIcon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                Expanded(
                  child: Text(
                    "Informations",
                    style: GardenTypography.headingMd,
                  ),
                ),
              ],
            ),
            ..._buildSections(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    final widgets = <Widget>[];

    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];

      widgets.add(_buildInfoSection(
        context: context,
        icon: section.icon,
        label: section.label,
        name: section.name,
        date: section.date,
      ));

      if (i < sections.length - 1) {
        widgets.add(Divider(color: Colors.grey[300]));
      }
    }

    return widgets;
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
              style: GardenTypography.bodyLg.copyWith(
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

class InfoSectionData {
  final IconData icon;
  final String label;
  final String name;
  final String date;

  const InfoSectionData({
    required this.icon,
    required this.label,
    required this.name,
    required this.date,
  });
}
