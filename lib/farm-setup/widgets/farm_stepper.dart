
import 'package:flutter/material.dart';
import 'package:garden_connect/farm-setup/widgets/wifi_setup_widget.dart';

import '../../analytics/models/analytics.dart';
import '../../areas/models/area.dart';
import '../../areas/widgets/tab_zones_widget.dart';
import '../../auth/models/user.dart';
import '../../settings/users/widgets/user_add_form_widget.dart';
import '../models/farm.dart';
import 'farm_info_widget.dart';

class FarmStepper extends StatefulWidget {
  final Function(int)? onStepChanged;
  final Function()? onCompleted;
  final Function(UserAddDto)? onUserDataChanged;
  final Function(String, String)? onWifiDataChanged;
  final Function(Farm)? onFarmDataChanged;

  const FarmStepper({
    super.key,
    this.onStepChanged,
    this.onCompleted,
    this.onUserDataChanged,
    this.onWifiDataChanged,
    this.onFarmDataChanged,
  });

  @override
  FarmStepperState createState() {
    return FarmStepperState();
  }
}


class FarmStepperState extends State<FarmStepper> {
  int _currentStep = 0;
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _wifiFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _farmFormKey = GlobalKey<FormState>();
  
  final List<Area> _areas = [
    Area(id: "1", name: "Serre 1 example", level: 1, color: Colors.blue, analytics: Analytics()),
    Area(id: "2", name: "Parcelle 1 example", level: 2, color: Colors.blue, analytics: Analytics()),
    Area(id: "3", name: "Jardin 1 example", level: 3, color: Colors.blue, analytics: Analytics()),
  ];

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

  void _continue() {
    if (_currentStep < 3) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        widget.onStepChanged?.call(_currentStep);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez corriger les erreurs avant de continuer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      widget.onStepChanged?.call(_currentStep);
    }
  }
  VoidCallback? onNextPressed(ControlsDetails details) {
    if (_currentStep==3) {
      return widget.onCompleted;
    }else {
      return details.onStepContinue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      elevation: 0,

      currentStep: _currentStep,
      onStepContinue: _continue,
      onStepCancel: _cancel,
      onStepTapped: (step) {
        if(_validateCurrentStep()) {
          setState(() {
            _currentStep = step;
          });
          widget.onStepChanged?.call(_currentStep);
        }
      },
      steps: [
        Step(
          title: const Text('Votre compte'),
          content: UserAddFormWidget(
            isSuperAdminCreation: true,
            formKey: _userFormKey,
            onDataChanged: (user) {
              widget.onUserDataChanged?.call(user);
            },
          ),
          isActive: _currentStep >= 0,
          state: _currentStep > 0
              ? StepState.complete
              : StepState.indexed,
        ),
        Step(
          title: const Text('Wifi'),
          content: WifiSetupWidget(
            formKey: _wifiFormKey,
            onDataChanged: (ssid, password) {
              widget.onWifiDataChanged?.call(ssid, password);
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
            onDataChanged: (farm) {
              widget.onFarmDataChanged?.call(farm);
            },
          ),
          isActive: _currentStep >= 2,
          state: _currentStep > 2
              ? StepState.complete
              : StepState.indexed,
        ),
        Step(
          title: const Text('Vos espaces'),
          content: TabZonesWidget(title: "test", areas: _areas, displayDetailsPanel: false),
          isActive: _currentStep >= 3,
          state: StepState.indexed,
        ),
      ],
      controlsBuilder: (context, details) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onNextPressed(details),
              child: _currentStep == 3 ? const Text('Terminer') : const Text('Suivant'),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: details.onStepCancel,
              child: const Text('Retour'),
            ),
          ],
        );
      },
    );
  }


}