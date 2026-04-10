import 'package:flutter/material.dart';
import 'package:garden_connect/settings/administration/widgets/administration_card_widget.dart';
import 'package:garden_ui/ui/components.dart';

class CGUWidget extends StatelessWidget {
  const CGUWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdministrationCardWidget(
      title: "CGU",
      icon: Icons.build_outlined,
      child: Center(
        child: Button(
          label: "Consulter les CGU",
          icon: Icons.arrow_forward,
          onPressed: () => {},
        ),
      ),
    );
  }
}
