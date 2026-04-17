import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:garden_connect/cells/models/cell_pairing_payload.dart';
import 'package:garden_connect/cells/repository/cell_sse_repository.dart';
import 'package:garden_ui/ui/components.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

import '../widgets/title_view_widget.dart';
import '../widgets/tooltip_widget.dart';

class CellPairPendingView extends StatefulWidget {
  const CellPairPendingView({super.key});

  @override
  State<CellPairPendingView> createState() => _CellPairPendingViewState();
}

class _CellPairPendingViewState extends State<CellPairPendingView> {
  static const Duration _pairingTimeout = Duration(seconds: 15);

  final CellSSERepository _pairingRepository = CellSSERepository();
  StreamSubscription<SSEModel>? _pairingSubscription;
  Timer? _timeoutTimer;
  Timer? _countdownTimer;

  Duration _remaining = _pairingTimeout;
  double _progress = 0.0;
  String _statusMessage = 'Recherche d\'un device IoT en cours...';
  bool _hasNavigated = false;
  CellPairingDevice? _device;
  CellPairingCell? _cell;

  @override
  void initState() {
    super.initState();
    _startPairing();
  }

  @override
  void dispose() {
    _stopPairing();
    super.dispose();
  }

  void _startPairing() {
    _timeoutTimer?.cancel();
    _countdownTimer?.cancel();

    _remaining = _pairingTimeout;
    _timeoutTimer = Timer(_pairingTimeout, _handleTimeout);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 0) return;
      setState(() {
        _remaining = Duration(seconds: _remaining.inSeconds - 1);
      });
    });

    _pairingSubscription = _pairingRepository.subscribeToPairing().listen(
      _handleSseEvent,
      onError: (_) => _handleFailure(),
      onDone: _handleFailure,
    );
  }

  void _stopPairing() {
    _timeoutTimer?.cancel();
    _countdownTimer?.cancel();
    _pairingSubscription?.cancel();
    _timeoutTimer = null;
    _countdownTimer = null;
    _pairingSubscription = null;
  }

  void _handleTimeout() {
    _handleFailure();
  }

  void _handleFailure() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _stopPairing();
    context.go('/settings/cells/add');
  }

  void _handleCompleted() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _stopPairing();
    context.go(
      '/settings/cells/add/pairing/configure',
      extra: CellPairingPayload(device: _device, cell: _cell),
    );
  }

  void _handleSseEvent(SSEModel event) {
    if (!mounted) return;
    final payload = _parsePayload(event.data);
    final step = payload?['step'] as String?;
    final message = payload?['message'] as String?;
    final deviceJson = payload?['device'] as Map<String, dynamic>?;
    final cellJson = payload?['cell'] as Map<String, dynamic>?;

    if (deviceJson != null) {
      _device = CellPairingDevice.fromJson(deviceJson);
    }
    if (cellJson != null) {
      _cell = CellPairingCell.fromJson(cellJson);
    }

    if (step != null) {
      setState(() {
        _progress = _progressForStep(step);
        if (message != null && message.isNotEmpty) {
          _statusMessage = message;
        }
      });
    }

    if (event.event == 'completed' || step == 'completed') {
      _handleCompleted();
      return;
    }

    if (event.event == 'error' || step == 'failed') {
      _handleFailure();
    }
  }

  Map<String, dynamic>? _parsePayload(String? data) {
    if (data == null || data.isEmpty) return null;
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }

  double _progressForStep(String step) {
    switch (step) {
      case 'scanning':
        return 0.25;
      case 'device_found':
        return 0.5;
      case 'creating':
        return 0.75;
      case 'completed':
        return 1.0;
      default:
        return _progress;
    }
  }

  String _formatRemaining(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _handleCancel() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    _stopPairing();
    context.go('/settings/cells/add');
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).round();
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
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sensors,
                                  size: 30,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(width: GardenSpace.gapSm),
                                Expanded(
                                  child: Text(
                                    _statusMessage,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatRemaining(_remaining),
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
                    SizedBox(height: GardenSpace.gapXl),
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
                                      '$percent%',
                                      style: GardenTypography.caption.copyWith(
                                        color: GardenColors.typography.shade200,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: GardenSpace.gapXs),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: LinearProgressIndicator(
                                    minHeight: 6,
                                    value: _progress,
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
                              margin: EdgeInsets.all(GardenSpace.paddingMd),
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
                            title: _statusMessage,
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
                          SizedBox(height: GardenSpace.gapXl),
                          Button(
                            label: 'Annuler',
                            icon: Icons.backspace,
                            onPressed: _handleCancel,
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
