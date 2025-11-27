import 'package:flutter/material.dart';
import 'package:garden_ui/ui/foundation/color/color_design_system.dart';

class ActivitySensors extends StatelessWidget {
  final List<int> activityData;

  const ActivitySensors({
    super.key,
    required this.activityData,
  });

  Color _getColorForLevel(int level) {
    switch (level) {
      case 0:
        return GardenColors.redAlert.shade600;
      case 1:
        return GardenColors.yellowWarning.shade400;
      case 2:
        return GardenColors.tertiary.shade700;
      case 3:
        return GardenColors.primary.shade700;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    const int daysInWeek = 7;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: List.generate(52, (weekIndex) {
            return Column(
              children: List.generate(daysInWeek, (dayIndex) {
                final dataIndex = weekIndex * daysInWeek + dayIndex;
                final level = dataIndex < activityData.length
                    ? activityData[dataIndex]
                    : 0;

                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _getColorForLevel(level),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}