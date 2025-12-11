import 'package:flutter/material.dart';

class WorkInProgressWidget extends StatelessWidget {
  const WorkInProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 24),
          Text(
            'Work in Progress',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Cette fonctionnalité est en cours de développement',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}