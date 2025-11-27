import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

class HexagonesWidget extends StatelessWidget {
  final List<String> areas;

  HexagonesWidget({super.key, required this.areas});

  List<Widget> _buildHexagons(BuildContext context) {
    return areas.map((item) {
      return HexagonWidget.flat(
        width: 125,
        color: Theme.of(context).colorScheme.primary,
        padding: 16.0,
        child: Center(child: Text(item, style: TextStyle(color: Colors.white))),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Vos Espaces',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 25),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'Niveau 1',
                autofocus: true,
                isDense: true,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                items:
                    <String>['Niveau 1', 'Niveau 2', 'Niveau 2'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                onChanged: (_) {},
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                child: Text(
                  '18 noeuds actifs',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildHexagons(context),
        ),
      ],
    );
  }
}
