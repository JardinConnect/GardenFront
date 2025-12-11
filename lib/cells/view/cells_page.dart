import 'package:flutter/material.dart';
import 'package:garden_connect/common/widgets/wip_widget.dart';

class CellsPage extends StatelessWidget {
  const CellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: WorkInProgressWidget()));
  }
}
