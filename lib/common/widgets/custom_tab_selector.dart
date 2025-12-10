import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:garden_ui/ui/foundation/color/color_design_system.dart';

class CustomTabSelector extends StatelessWidget {
  final List<String> tabs;

  const CustomTabSelector({
    super.key,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          indicator: BoxDecoration(
            borderRadius: GardenRadius.radiusSm,
            color: GardenColors.base.shade200,
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          tabs: tabs.map((text) => Tab(text: text)).toList(),
        ),
      ),
    );
  }
}
