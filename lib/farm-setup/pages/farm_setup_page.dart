import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_connect/auth/models/user.dart';
import 'package:garden_connect/core/app_assets.dart';
import 'package:garden_connect/farm-setup/bloc/farm_setup_bloc.dart';
import 'package:garden_ui/ui/components.dart';

import '../../areas/models/area.dart';
import '../../settings/users/widgets/user_add_form_widget.dart';
import '../models/farm.dart';
import '../views/area_setup_view.dart';
import '../widgets/farm_info_widget.dart';
import '../widgets/wifi_setup_widget.dart';

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
  List<Area>? _areas;
  String? _wrongPassword;
  String _title = "Bienvenue sur Garden Connect !";
  int _currentStep = 3;
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _wifiFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _farmFormKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              AppAssets.welcomeBackground,
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
      BlocConsumer<FarmSetupBloc,FarmState>(
            listener: (context, state) {
        if (state is NetworkLoaded && state.networkState == NetworkState.connected) {
          setState(() => _currentStep++);
          _wrongPassword = null;
        }
        if (state is NetworkLoaded && state.networkState == NetworkState.connexionFailed) {
          _wrongPassword = "Mot de passe incorrect";
        }
      },
        builder: (context, state) {
          if (state is FarmLoading || state is FarmInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NetworkLoaded ) {
            return
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(_title, style: Theme
                            .of(context).textTheme
                            .displayMedium),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                          maxWidth: MediaQuery.of(context).size.width * 0.6
                        ),
                        child: GardenCard(
                            hasBorder: true,
                            hasShadow: true,
                            child:Stepper(
                              type: StepperType.horizontal,
                              elevation: 0,
                              currentStep: _currentStep,
                              onStepCancel: _cancel,
                              onStepTapped: _stepTapped,
                              steps: [
                                Step(
                                  title: const Text('Votre compte'),
                                  content: UserAddFormWidget(
                                    isSuperAdminCreation: true,
                                    formKey: _userFormKey,
                                    onDataChanged: (user) => setState(() =>_user = user),
                                  ),
                                  isActive: _currentStep >= 0,
                                  state: _currentStep > 0
                                      ? StepState.complete
                                      : StepState.indexed,
                                ),
                                Step(
                                  title: const Text('Wifi'),
                                  content: WifiSetupWidget(
                                    wifiList: state.wifiList,
                                    onRefreshWifiList: () => context.read<FarmSetupBloc>().add(RefreshWifiListEvent()),
                                    formKey: _wifiFormKey,
                                    errorMessage:_wrongPassword,
                                    onDataChanged: (ssid, password) {
                                      setState(() {
                                        _wifiSsid = ssid;
                                        _wifiPassword = password;
                                        context.read<FarmSetupBloc>().add(NetworkChange());
                                      });
                                    },
                                  ),
                                  isActive: _currentStep >= 1,
                                  state: _currentStep > 1
                                      ? StepState.complete
                                      : StepState.indexed,
                                ),
                                Step(
                                  title: const Text('Votre ferme'),
                                  content: FarmInfoWidget(
                                    formKey: _farmFormKey,
                                    onDataChanged:(farm) =>setState(()=>_farm = farm),
                                  ),
                                  isActive: _currentStep >= 2,
                                  state: _currentStep > 2
                                      ? StepState.complete
                                      : StepState.indexed,
                                ),
                                Step(
                                  title: const Text('Vos espaces'),
                                  content: AreaSetupView(),
                                  isActive: _currentStep >= 3,
                                  state: StepState.indexed,
                                ),
                              ],
                              controlsBuilder: (context, details) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed:()=> _continue(context,state),
                                      child: _currentStep == 3 ? const Text('Terminer') : const Text('Suivant'),
                                    ),
                                    const SizedBox(width: 16),
                                    if(_currentStep > 0)
                                      TextButton(
                                        onPressed: details.onStepCancel,
                                        child:  const Text('Retour'),
                                      ),
                                  ],
                                );
                              },
                            )
                                                  ),
                      ),
                    ],
                  ),
                );
          }else if(state is FarmError){
            return Center(child: Text('Erreur: ${state.message}'));
          } else {
            return const Center(child: Text('État inconnu'));
          }
        }
      )]
    ));
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
  void _continue(BuildContext context, FarmState state){
    if (_currentStep < 3) {
      if (_validateCurrentStep()) {
        if(_currentStep == 1) {
          if ((state as NetworkLoaded).networkState==NetworkState.connected) {
            setState(() => _currentStep++);
            return;
          }
          if ((state).networkState==NetworkState.connecting) return; // on ignore les double-clics

          context.read<FarmSetupBloc>().add(ConnectFarmToWifiEvent(ssid: _wifiSsid!, password: _wifiPassword!));
          return;
        }
        setState(() {
          _currentStep++;
        });
        _stepChanged(_currentStep);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez corriger les erreurs avant de continuer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }else {
      context.read<FarmSetupBloc>().add(
          FarmCreateEvent(farm: _farm!,
              user: _user!,
              areas: _areas!
          ));
    }
  }
  void _stepTapped(int step) {
    if(step==_currentStep)return;

    if(_validateCurrentStep() || step < _currentStep) {
      if(_currentStep == 1 && step > _currentStep) {
        context.read<FarmSetupBloc>().add(ConnectFarmToWifiEvent(ssid: _wifiSsid!, password: _wifiPassword!));
        return;
      }
      setState(() {
        _currentStep = step;
      });
      _stepChanged(_currentStep);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _userFormKey.currentState?.validate() ?? false;
      case 1:
        return _wifiFormKey.currentState?.validate() ?? false;
      case 2:
        return _farmFormKey.currentState?.validate() ?? false;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _stepChanged(_currentStep);
    }
  }

}