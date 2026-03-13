import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/areas/bloc/area_bloc.dart';
import 'package:garden_ui/ui/foundation/padding/space_design_system.dart';
import 'package:garden_ui/ui/foundation/typography/typography_design_system.dart';

import '../../areas/widgets/tab_zones_widget.dart';

class AreaSetupView extends StatelessWidget {

  const AreaSetupView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AreaBloc,AreaState>(
      builder: (context, state) {
        if (state is AreasLoaded) {
          return  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: TabZonesWidget(title: "test", areas: state.areas, displayDetailsPanel: false, selectedArea: state.selectedArea, )),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(GardenSpace.paddingLg),
                    child: Container(
                      padding: EdgeInsets.all(GardenSpace.paddingMd),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: GardenSpace.gapSm),
                          Expanded(
                            child: Text(
                            "Les Espaces vous permette de séparer et dimensionner votre ferme en plusieurs lieux, cultures ou espaces. \n\nVous pouvez imbriquer les espaces les un dans les autres pour creer votre ferme comme l'example ici qui représente un jardin qui se trouve dans une parcelle qui est elle meme dqns une serre. \n\nVous pouvez contruire votre ferme dans les paramètres : paramètres>Espaces, en cliquant sur le + en haut a droite ou en modifiant un espace existant !",
                              style: GardenTypography.bodyLg.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              ],
          );
        }else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}