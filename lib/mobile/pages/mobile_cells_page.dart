import 'package:flutter/material.dart';
import 'package:garden_connect/mobile/common/widgets/mobile_header.dart';
import 'package:garden_ui/ui/design_system.dart';

class MobileCellsPage extends StatelessWidget {
  const MobileCellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: GardenSpace.paddingLg, vertical: GardenSpace.paddingMd),
          child: Column(
            children: [
              MobileHeader(actionsButtons: [
                IconButton(onPressed: () => {}, icon: Icon(Icons.list, color: GardenColors.primary.shade500, size: 32))
              ],)
            ],
          ),
        )
      ),
    );
  }
}
