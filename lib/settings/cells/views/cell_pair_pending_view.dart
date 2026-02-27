import 'package:flutter/material.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

import '../widgets/title_view_widget.dart';
import '../widgets/tooltip_widget.dart';

class CellPairPendingView extends StatelessWidget {
  const CellPairPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleViewWidget(
                      title: 'Appairage en cours',
                      content:
                          'Votre capteur va se connecter automatiquement\nNe pas débrancher votre RaspberryPi',
                    ),
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.sensors,
                                size: 30,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Recherche en cours...',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '1:54',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 300,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Progression',
                                      style: GardenTypography.caption.copyWith(
                                        color: GardenColors.typography.shade200,
                                      ),
                                    ),
                                    Text(
                                      '75%',
                                      style: GardenTypography.caption.copyWith(
                                        color: GardenColors.typography.shade200,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: LinearProgressIndicator(
                                    minHeight: 6,
                                    value: 0.75,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: GardenColors.primary.shade200,
                              borderRadius: BorderRadius.circular(120),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: GardenColors.primary.shade300,
                                borderRadius: BorderRadius.circular(104),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.sensors,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          TooltipWidget(
                            title: 'En attente de la cellule...',
                            content:
                                'Assurez-vous que la LED du boitier clignote toujours lentement',
                            isCentered: true,
                          ),
                          const SizedBox(height: 48),
                          TooltipWidget(
                            title: 'Pour un appairage réussi',
                            content:
                                'Placez vous à moins de 5 mètres de la cellule mère si possible\nEvitez les interférences Bluetooth ou wifi\nEvitez de vous des placez dans l’espace et le temps',
                            isCentered: true,
                          ),
                          const SizedBox(height: 32),
                          Button(
                            label: 'Annuler',
                            icon: Icons.backspace,
                            onPressed: () => context.pop(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
