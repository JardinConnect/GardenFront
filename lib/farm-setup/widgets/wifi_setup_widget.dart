import 'package:flutter/material.dart';
import 'package:garden_connect/farm-setup/models/network_info.dart';
import 'package:garden_ui/ui/components.dart';

class WifiSetupWidget extends StatefulWidget {

  final Function(String, String)? onDataChanged;
  final Function()? onRefreshWifiList;
  final GlobalKey<FormState>? formKey;
  final List<NetworkInfo> wifiList;

  const WifiSetupWidget({
    super.key,
    required this.wifiList,
    this.onDataChanged,
    this.onRefreshWifiList,
    this.formKey,
  });

  @override
  State<WifiSetupWidget> createState() => _WifiSetupWidgetState();
}

class _WifiSetupWidgetState extends State<WifiSetupWidget> {

  bool _passwordVisible = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ssidController = TextEditingController();
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _ssidController.addListener(_onDataChanged);
    _passwordController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    widget.onDataChanged?.call(
      _ssidController.text,
      _passwordController.text,
    );
  }
  void _refreshWifiList() {
    widget.onRefreshWifiList?.call();
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GardenCard(
        hasBorder: false,
        hasShadow: false,
        child: Form(
            key: widget.formKey ?? _internalFormKey,
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     controller: _ssidController,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Veuillez entrer un SSID';
                //       }
                //       return null;
                //     },
                //     decoration: const InputDecoration(
                //       labelText: 'SSID',
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child:
                          DropdownButtonFormField<String>(
                            initialValue: widget.wifiList.first.ssid,
                            decoration: const InputDecoration(labelText: 'SSID'),
                            items: widget.wifiList.map((network)=>network.ssid).map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              _ssidController.text = value ?? "";
                            },
                          ),
                        ),
                      ),
                      Button(label: "Rafraichir", onPressed: _refreshWifiList)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      suffixIcon: IconButton(
                        onPressed: ()=>
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            }),
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                ),
              ],
            )
        )
    );
  }
}