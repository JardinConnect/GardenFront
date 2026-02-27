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

    // Grouper les paramètres par catégorie
    Map<String, List<dynamic>> groupedSettings = {};

    for (var i = 0; i < widget.settings.settings.length; i++) {
      String category = widget.settings.settings[i].setting.categoryName;
      if (!groupedSettings.containsKey(category)) {
        groupedSettings[category] = [];
      }
      groupedSettings[category]!.add(widget.settings.settings[i]);
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
                Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor,),
                const SizedBox(width: 8),
                const Text('Paramètres', style: TextStyle(fontSize: 18)),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 10),
            for (var category in groupedSettings.keys)
              ExpansionTile(
                initiallyExpanded: category == groupedSettings.keys.elementAt(0) || category == groupedSettings.keys.elementAt(1),
                shape: const Border(),
                title: Text(category,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                children:
                  groupedSettings[category]!.map((setting)=>
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
                    )).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
