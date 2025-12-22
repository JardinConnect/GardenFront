
import 'package:flutter/material.dart';
import 'package:garden_connect/settings/models/settings.dart';
import 'package:garden_ui/ui/widgets/atoms/Card/card.dart' show GardenCard;

class LogCardWidget extends StatelessWidget {
  const LogCardWidget({super.key, required this.logs});
  final Logs logs;

  @override
  Widget build(BuildContext context) {

    return GardenCard(
      child: SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  Text(
                    "Dernieres Activites",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsetsGeometry.directional(
                        top: 20,
                        start: 60,
                        end: 60,
                      ),
                      child: Column(
                        children: [
                          for (final log in logs.logs)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  log,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: Theme.of(context).textTheme.bodyMedium?.fontStyle
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}