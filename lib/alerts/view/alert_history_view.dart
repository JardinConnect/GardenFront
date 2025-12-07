import 'package:flutter/material.dart';
import '../models/alert_models.dart';
import '../data/alert_repository.dart';
import '../widgets/alert_table.dart';

/// Composant pour l'affichage de l'historique des alertes
class AlertHistoryView extends StatefulWidget {
  const AlertHistoryView({super.key});

  @override
  State<AlertHistoryView> createState() => _AlertHistoryViewState();
}

class _AlertHistoryViewState extends State<AlertHistoryView> {
  final AlertRepository _alertRepository = AlertRepository();
  List<AlertEvent> _alertEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlertHistory();
  }

  Future<void> _loadAlertHistory() async {
    try {
      final events = await _alertRepository.getAlertHistory();
      setState(() {
        _alertEvents = events;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'historique: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDeleteEvent(AlertEvent event) async {
    try {
      await _alertRepository.archiveAlertEvent(event.id);
      setState(() {
        _alertEvents.removeWhere((e) => e.id == event.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Archivage de l\'alerte ${event.value}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'archivage: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: AlertTable(
        events: _alertEvents,
        showHeaders: true,
        onDeleteEvent: _handleDeleteEvent,
      ),
    );
  }
}