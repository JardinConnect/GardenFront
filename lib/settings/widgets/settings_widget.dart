import 'package:flutter/material.dart';
import 'package:garden_ui/ui/widgets/atoms/Card/card.dart';

import '../models/settings.dart';

/// Parameter display moved inline for easier API integration.
/// Renamed to ParameterDisplaySection to avoid duplicate symbols.
class GlobalSettingsWidget extends StatefulWidget {
  final Settings settings;

  const GlobalSettingsWidget({super.key, required this.settings});

  @override
  State<GlobalSettingsWidget> createState() => _GlobalSettingsWidgetState();
}

class _GlobalSettingsWidgetState extends State<GlobalSettingsWidget> {


  @override
  Widget build(BuildContext context) {
    final settings = widget.settings;

    // Grouper les paramètres par catégorie
    Map<int, List<dynamic>> groupedSettings = {};

    for (var i = 0; i < settings.settings.length; i++) {
      int category = getCategory(i);
      if (!groupedSettings.containsKey(category)) {
        groupedSettings[category] = [];
      }
      groupedSettings[category]!.add(settings.settings[i]);
    }

    return GardenCard(
      hasShadow: true,
      hasBorder: true,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings_outlined),
                const SizedBox(width: 8),
                const Text('Paramètres', style: TextStyle(fontSize: 18)),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 10),

            for (var category in groupedSettings.keys)
              ExpansionTile(
                initiallyExpanded: category == 1,
                shape: const Border(),
                title: Text(
                  getCategoryName(category),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                children: [
                  for (var setting in groupedSettings[category]!)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CheckboxListTile(
                        value: setting.value,
                        onChanged: (value) {
                          setState(() {
                            setting.value = value ?? false;
                          });
                        },
                        title: Text(
                          setting.setting.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  int getCategory(int index) {
    if (index >= 0 && index <= 2) return 1;
    if (index >= 3 && index <= 4) return 2;
    if (index >= 5 && index <= 8) return 3;
    return 4;
  }

  String getCategoryName(int category) {
    switch (category) {
      case 1:
        return 'Général';
      case 2:
        return 'Notifications et alertes';
      case 3:
        return 'Gestion des cellules';
      default:
        return 'Gestion des espaces';
    }
  }
}
