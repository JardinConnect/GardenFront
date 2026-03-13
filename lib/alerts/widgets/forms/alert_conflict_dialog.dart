import 'package:flutter/material.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../../models/alert_models.dart';
import '../../../common/widgets/generic_dialog.dart';

/// Dialogue générique pour afficher les conflits d'alertes détectés
/// et demander à l'utilisateur s'il souhaite écraser les alertes existantes.
///
/// Retourne `true` si l'utilisateur confirme l'écrasement, `null` si annulé.
class AlertConflictDialog extends StatelessWidget {
  final List<AlertConflict> conflicts;
  final bool isEditing;

  const AlertConflictDialog({
    super.key,
    required this.conflicts,
    this.isEditing = false,
  });

  /// Affiche le dialogue et retourne `true` (écraser) ou `null` (annuler).
  static Future<bool?> show(
    BuildContext context,
    List<AlertConflict> conflicts, {
    bool isEditing = false,
  }) {
    return StyledDialog.show<bool>(
      context,
      title: 'Conflits détectés',
      headerColor: GardenColors.redAlert.shade500,
      dismissible: false,
      widthFactor: 0.35,
      content: _AlertConflictContent(conflicts: conflicts, isEditing: isEditing),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(null),
          child: Text('Annuler', style: GardenTypography.bodyMd),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
          icon: const Icon(Icons.delete_sweep_rounded, size: 16),
          label: const Text('Écraser les conflits'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StyledDialog(
      title: 'Conflits détectés',
      dismissible: false,
      content: _AlertConflictContent(conflicts: conflicts, isEditing: isEditing),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(null),
          child: Text('Annuler', style: GardenTypography.bodyMd),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
          icon: const Icon(Icons.delete_sweep_rounded, size: 16),
          label: const Text('Écraser les conflits'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _AlertConflictContent extends StatelessWidget {
  final List<AlertConflict> conflicts;
  final bool isEditing;

  const _AlertConflictContent({required this.conflicts, this.isEditing = false});

  Map<String, List<String>> _buildSummary() {
    final summary = <String, List<String>>{};
    for (final conflict in conflicts) {
      summary
          .putIfAbsent(conflict.existingAlertTitle, () => [])
          .add('${conflict.cellName} (${conflict.sensorType})');
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summary = _buildSummary();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: GardenColors.redAlert.shade500,
              size: 18,
            ),
            SizedBox(width: GardenSpace.gapSm),
            Expanded(
              child: Text(
                'Des alertes existantes sont en conflit avec votre sélection :',
                style: GardenTypography.bodyMd,
              ),
            ),
          ],
        ),

        SizedBox(height: GardenSpace.gapMd),

        // Liste des conflits
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  summary.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: GardenSpace.gapSm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_rounded,
                                size: 14,
                                color: GardenColors.redAlert.shade500,
                              ),
                              SizedBox(width: GardenSpace.gapXs),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: GardenTypography.bodyMd.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...entry.value.map(
                            (detail) => Padding(
                              padding: const EdgeInsets.only(left: 18, top: 2),
                              child: Text(
                                '• $detail',
                                style: GardenTypography.bodyMd.copyWith(
                                  color: GardenColors.typography.shade300,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),

        SizedBox(height: GardenSpace.gapMd),

        // Zone d'avertissement style danger_zone
        Container(
          padding: EdgeInsets.all(GardenSpace.paddingSm),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: GardenRadius.radiusSm,
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 18,
              ),
              SizedBox(width: GardenSpace.gapSm),
              Expanded(
                child: Text(
                  isEditing
                      ? 'Voulez-vous écraser les alertes existantes ou annuler la modification ?'
                      : 'Voulez-vous écraser les alertes existantes ou annuler la création ?',
                  style: GardenTypography.bodyMd.copyWith(
                    color: Colors.red.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
