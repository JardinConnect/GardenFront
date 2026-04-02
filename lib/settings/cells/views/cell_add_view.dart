import 'package:flutter/material.dart';
import 'package:garden_connect/common/widgets/back_text_button.dart';
import 'package:garden_connect/core/app_assets.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/title_view_widget.dart';
import '../widgets/tooltip_widget.dart';

class CellAddView extends StatelessWidget {
  const CellAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackTextButton(backFunction: () => Navigator.of(context).pop()),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleViewWidget(
                    title: 'Ajouter une cellule',
                    content:
                        'Suivez ces étapes pour connecter un nouveau capteur à votre système',
                  ),
                  SizedBox(height: GardenSpace.gapXl),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          AppAssets.addCell,
                          width: 320,
                          height: 240,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: GardenSpace.gapLg),
                      Center(
                        child: TooltipWidget(
                          isCentered: true,
                          title:
                              'Appuyer 3 secondes sur le bouton de la cellule',
                          content:
                              'Maintenez le bouton enfoncé jusqu\'à ce que la LED clignote lentement',
                        ),
                      ),
                      SizedBox(height: GardenSpace.gapMd),
                      Center(
                        child: TooltipWidget(
                          isCentered: true,
                          title: 'Vérifiez le clignotement de la LED',
                          content:
                              'La LED doit clignoter lentement pour indiquer le mode appairage',
                        ),
                      ),
                      SizedBox(height: GardenSpace.gapMd),
                      Center(
                        child: TooltipWidget(
                          isCentered: true,
                          title: 'Restez à proximité',
                          content:
                              'Placez-vous à moins de 5 mètres de la cellule mère si possible sans obstacle',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: GardenSpace.gapXl),
                  Center(
                    child: Button(
                      label: 'Démarrer l\'apparaige',
                      icon: Icons.sensors,
                      onPressed: () => context.go('/settings/cells/add/pairing'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
