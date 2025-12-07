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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Archivage de l\'alerte ${event.value}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'archivage: $e')),
        );
      }
    }
  }

  Future<void> _handleArchiveAll() async {
    if (_alertEvents.isEmpty) return;

    // Dialog de confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archiver tout l\'historique'),
        content: Text('Êtes-vous sûr de vouloir archiver tous les ${_alertEvents.length} événements ?\nCette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Archiver tout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _performArchiveAll();
    }
  }

  Future<void> _performArchiveAll() async {
    try {
      // Archive tous les événements
      for (final event in _alertEvents) {
        await _alertRepository.archiveAlertEvent(event.id);
      }
      
      setState(() {
        _alertEvents.clear();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tout l\'historique a été archivé'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'archivage: $e')),
        );
      }
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
        onArchiveAll: _alertEvents.isNotEmpty ? _handleArchiveAll : null,
      ),
    );
  }
}