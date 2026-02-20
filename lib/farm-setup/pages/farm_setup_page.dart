import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_connect/auth/models/user.dart';
import 'package:garden_connect/farm-setup/bloc/farm_setup_bloc.dart';
import 'package:garden_ui/ui/components.dart';

import '../models/farm.dart';
import '../widgets/farm_stepper.dart';

class FarmSetupPage extends StatefulWidget{

  const FarmSetupPage({super.key});

  @override
  State<FarmSetupPage> createState() => _FarmSetupPageState();
}

class _FarmSetupPageState extends State<FarmSetupPage> {
  UserAddDto? _user;
  String? _wifiSsid;
  String? _wifiPassword;
  Farm? _farm;
  String _title = "Bienvenue sur Garden Connect !";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      BlocProvider(
        create: (context) => FarmSetupBloc(),
        child: BlocBuilder<FarmSetupBloc,FarmState>(
          builder: (BuildContext context, state) {
            return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(_title,style: Theme.of(context).textTheme.headlineMedium,),
              ),
              Expanded(
                child: Padding(
                  padding:EdgeInsetsGeometry.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1, vertical:20),
                  child: GardenCard(
                      hasBorder: true,
                      hasShadow: true,
                      child: FarmStepper(
                        onStepChanged: (step) => setState(() => _stepChanged(step)),
                        onUserDataChanged: (user) {
                          setState(() {
                            _user = user;
                          });
                        },
                        onWifiDataChanged: (ssid, password) {
                          setState(() {
                            _wifiSsid = ssid;
                            _wifiPassword = password;
                          });
                        },
                        onFarmDataChanged: (farm) {
                          setState(() {
                            _farm = farm;
                          });
                        },
                        onCompleted: ()=>
                            context.read<FarmSetupBloc>().add(FarmCreateEvent(farm: _farm!, user: _user!, wifiSsid: _wifiSsid!, wifiPassword: _wifiPassword!)),
                      )
                  ),
                ),
              ),
            ],
          ),
              );
            },
        ),
      )
    );
  }

  void _stepChanged(int step) {
      switch(step) {
        case 0:
          _title = "Bienvenue sur Garden Connect !";
          break;
        case 1:
          _title = "Configuration du Wifi";
          break;
        case 2:
          _title = "Informations sur votre ferme";
          break;
        case 3:
          _title = "Configuration de vos espaces";
          break;
      }
  }
}