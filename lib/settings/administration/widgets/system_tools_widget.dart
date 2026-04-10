import 'package:flutter/material.dart';
import 'package:garden_connect/settings/administration/widgets/administration_card_widget.dart';
import 'package:garden_ui/ui/components.dart';

class SystemToolsWidget extends StatelessWidget {
  const SystemToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdministrationCardWidget(
      title: "Outils système",
      icon: Icons.build_outlined,
      child: Center(
        child: Button(
          label: "Redémarrer GardenConnect",
          icon: Icons.autorenew_outlined,
          onPressed: () => {},
        ),
      ),
    );
  }
}
