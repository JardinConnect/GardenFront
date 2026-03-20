

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';

import '../models/farm.dart';


class FarmInfoWidget extends StatefulWidget{

  final Function(Farm)? onDataChanged;
  final GlobalKey<FormState>? formKey;

  const FarmInfoWidget({
    super.key,
    this.onDataChanged,
    this.formKey,
  });

  @override
  State<FarmInfoWidget> createState() => _FarmInfoWidgetState();
}

class _FarmInfoWidgetState extends State<FarmInfoWidget>{

  late final TextEditingController _nameController;
  late final TextEditingController _addressController ;
  late final TextEditingController _zipCodeController ;
  late final TextEditingController _cityController ;
  late final TextEditingController _phoneNumberController;
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();

  Farm farm = Farm(
    name: '',
    address: '',
    zipCode: '',
    city: '',
    phoneNumber: '',
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _zipCodeController = TextEditingController();
    _cityController = TextEditingController();
    _phoneNumberController = TextEditingController();

    _nameController.addListener(_onDataChanged);
    _addressController.addListener(_onDataChanged);
    _zipCodeController.addListener(_onDataChanged);
    _cityController.addListener(_onDataChanged);
    _phoneNumberController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    farm.name = _nameController.text;
    farm.city = _cityController.text;
    farm.zipCode = _zipCodeController.text;
    farm.phoneNumber = _phoneNumberController.text;
    farm.address = _addressController.text;
    widget.onDataChanged?.call(farm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GardenCard(
        hasShadow: false,
        hasBorder: false,
        child:Form(
          key: widget.formKey ?? _internalFormKey,
          child: Column(
            spacing: GardenSpace.gapMd,
            children: [
              TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom de la ferme';
                    }
                    return null;
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nom de la ferme')
              ),
              TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'adresse de la ferme';
                    }
                    return null;
                  },
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Adresse')
              ),
              Row(
                spacing: GardenSpace.gapMd,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le code postal';
                          }
                          if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                            return 'Veuillez entrer un code postal valide (5 chiffres)';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _zipCodeController,
                        decoration: const InputDecoration(labelText: 'Code Postal', hintText: 'Ex: 75001')
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la ville';
                          }
                          return null;
                        },
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'Ville')
                    ),
                  ),
                ],
              ),
              TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Veuillez entrer un numéro de téléphone valide (10 chiffres)';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Téléphone', hintText: 'Ex: 0612345678')
              ),
            ]
          ),
        )
    );
  }
}