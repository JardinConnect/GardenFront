import 'dart:ui';

import '../models/area.dart';

class AreaRepository {
  // Liste en mémoire pour simuler la persistance
  List<Map<String, dynamic>>? _cachedAreas;

  Future<List<Area>> fetchAreas() async {
    // TODO call API route to fetch areas data
    try {
      // Utiliser le cache si disponible
      if (_cachedAreas != null) {
        return _cachedAreas!.map((area) => Area.fromJson(area)).toList();
      }

      // Données initiales
      _cachedAreas = [
        {
          "name": "Parcelle Nord",
          "color": "FFE74C3C",
          "level": 1,
          "analytics": {
            "air_temperature": [
              {"value": 18, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
              {"value": 20, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
              {"value": 19, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
              {"value": 21, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
              {"value": 22, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
              {"value": 20, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
              {"value": 34, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
            ],
            "soil_temperature": [
              {"value": 15, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
              {"value": 16, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
              {"value": 15, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
              {"value": 17, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
              {"value": 18, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
              {"value": 16, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
              {"value": 15, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
            ],
            "air_humidity": [
              {"value": 65, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
              {"value": 70, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
              {"value": 68, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
              {"value": 72, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
              {"value": 75, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
              {"value": 70, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
              {"value": 68, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
            ],
            "soil_humidity": [
              {"value": 45, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
              {"value": 50, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
              {"value": 48, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
              {"value": 52, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
              {"value": 55, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
              {"value": 50, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
              {"value": 48, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
            ],
            "light": [
              {"value": 35, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "12"},
              {"value": 40, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "12"},
              {"value": 32, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "12"},
              {"value": 45, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "12"},
              {"value": 38, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "12"},
              {"value": 41, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "12"},
              {"value": 34, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "12"},
            ],
          },
          "areas": [
            {
              "name": "Planche Tomates Nord",
              "color": "FFE74C3C",
              "level": 2,
              "analytics": {
                "air_temperature": [
                  {"value": 22, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "13"},
                  {"value": 24, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "13"},
                  {"value": 23, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "13"},
                  {"value": 25, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "13"},
                  {"value": 26, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "13"},
                  {"value": 24, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "13"},
                  {"value": 23, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "13"},
                ],
                "soil_temperature": [
                  {"value": 17, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "13"},
                  {"value": 18, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "13"},
                  {"value": 17, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "13"},
                  {"value": 19, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "13"},
                  {"value": 20, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "13"},
                  {"value": 18, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "13"},
                  {"value": 17, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "13"},
                ],
                "air_humidity": [
                  {"value": 60, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "13"},
                  {"value": 65, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "13"},
                  {"value": 63, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "13"},
                  {"value": 67, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "13"},
                  {"value": 70, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "13"},
                  {"value": 65, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "13"},
                  {"value": 63, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "13"},
                ],
                "soil_humidity": [
                  {"value": 50, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "13"},
                  {"value": 55, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "13"},
                  {"value": 53, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "13"},
                  {"value": 57, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "13"},
                  {"value": 60, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "13"},
                  {"value": 55, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "13"},
                  {"value": 53, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "13"},
                ],
                "light": [
                  {"value": 40, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "13"},
                  {"value": 45, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "13"},
                  {"value": 37, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "13"},
                  {"value": 50, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "13"},
                  {"value": 43, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "13"},
                  {"value": 46, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "13"},
                  {"value": 39, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "13"},
                ],
              },
              "cells": [
                {
                  "name": "Cellule Tomates A1",
                },
                {
                  "name": "Cellule Tomates A2",
                }
              ]
            },
          ]
        },
        {
          "name": "Parcelle Sud",
          "color": "FF3498DB",
          "level": 1,
          "analytics": {
            "air_temperature": [
              {"value": 20, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "16"},
              {"value": 22, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "16"},
              {"value": 21, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "16"},
              {"value": 23, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "16"},
              {"value": 24, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "16"},
              {"value": 22, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "16"},
              {"value": 21, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "16"},
            ],
            "soil_temperature": [
              {"value": 16, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "16"},
              {"value": 17, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "16"},
              {"value": 16, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "16"},
              {"value": 18, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "16"},
              {"value": 19, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "16"},
              {"value": 17, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "16"},
              {"value": 16, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "16"},
            ],
            "air_humidity": [
              {"value": 68, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "16"},
              {"value": 73, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "16"},
              {"value": 71, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "16"},
              {"value": 75, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "16"},
              {"value": 78, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "16"},
              {"value": 73, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "16"},
              {"value": 71, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "16"},
            ],
            "soil_humidity": [
              {"value": 47, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "16"},
              {"value": 52, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "16"},
              {"value": 50, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "16"},
              {"value": 54, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "16"},
              {"value": 57, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "16"},
              {"value": 52, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "16"},
              {"value": 50, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "16"},
            ],
            "light": [
              {"value": 37, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "16"},
              {"value": 42, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "16"},
              {"value": 34, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "16"},
              {"value": 47, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "16"},
              {"value": 40, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "16"},
              {"value": 43, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "16"},
              {"value": 36, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "16"},
            ],
          },
          "areas": [
            {
              "name": "Planche Tomates Sud",
              "color": "FF3498DB",
              "level": 2,
              "analytics": {
                "air_temperature": [
                  {"value": 24, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "17"},
                  {"value": 26, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "17"},
                  {"value": 25, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "17"},
                  {"value": 27, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "17"},
                  {"value": 28, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "17"},
                  {"value": 26, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "17"},
                  {"value": 25, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "17"},
                ],
                "soil_temperature": [
                  {"value": 19, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "17"},
                  {"value": 20, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "17"},
                  {"value": 19, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "17"},
                  {"value": 21, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "17"},
                  {"value": 22, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "17"},
                  {"value": 20, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "17"},
                  {"value": 19, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "17"},
                ],
                "air_humidity": [
                  {"value": 63, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "17"},
                  {"value": 68, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "17"},
                  {"value": 66, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "17"},
                  {"value": 70, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "17"},
                  {"value": 73, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "17"},
                  {"value": 68, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "17"},
                  {"value": 66, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "17"},
                ],
                "soil_humidity": [
                  {"value": 51, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "17"},
                  {"value": 56, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "17"},
                  {"value": 54, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "17"},
                  {"value": 58, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "17"},
                  {"value": 61, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "17"},
                  {"value": 56, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "17"},
                  {"value": 54, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "17"},
                ],
                "light": [
                  {"value": 43, "occurredAt": "2025-11-05T08:00:00Z", "sensorId": "17"},
                  {"value": 48, "occurredAt": "2025-11-06T08:00:00Z", "sensorId": "17"},
                  {"value": 40, "occurredAt": "2025-11-07T08:00:00Z", "sensorId": "17"},
                  {"value": 53, "occurredAt": "2025-11-08T08:00:00Z", "sensorId": "17"},
                  {"value": 46, "occurredAt": "2025-11-09T08:00:00Z", "sensorId": "17"},
                  {"value": 49, "occurredAt": "2025-11-10T08:00:00Z", "sensorId": "17"},
                  {"value": 42, "occurredAt": "2025-11-11T08:00:00Z", "sensorId": "17"},
                ],
              },
              "cells": [
                {
                  "name": "Cellule Tomates A1",
                },
                {
                  "name": "Cellule Tomates A2",
                }
              ]
            },
          ]
        }
      ];

      return _cachedAreas!.map((area) => Area.fromJson(area)).toList();
    } catch (e) {
      throw Exception('Failed to load areas: $e');
    }
  }

  Future<Area> createArea({
    required String name,
    required String color,
    Area? parentArea,
  }) async {
    // TODO: Remplacer par un vrai appel API
    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(milliseconds: 500));

      // Créer la nouvelle area
      final newAreaJson = {
        "name": name,
        "color": color,
        "level": parentArea != null ? parentArea.level + 1 : 1,
        "areas": <Map<String, dynamic>>[],
      };

      if (parentArea == null) {
        _cachedAreas ??= [];
        _cachedAreas!.add(newAreaJson);
      } else {
        _addAreaToParent(_cachedAreas!, parentArea.name, newAreaJson);
      }

      return Area.fromJson(newAreaJson);
    } catch (e) {
      throw Exception('Failed to create area: $e');
    }
  }

  bool _addAreaToParent(
      List<Map<String, dynamic>> areas,
      String parentName,
      Map<String, dynamic> newArea,
      ) {
    for (var area in areas) {
      if (area['name'] == parentName) {
        // Parent trouvé, ajouter la nouvelle area
        if (area['areas'] == null) {
          area['areas'] = <Map<String, dynamic>>[];
        }
        (area['areas'] as List<Map<String, dynamic>>).add(newArea);
        return true;
      }

      // Chercher récursivement dans les sous-areas
      if (area['areas'] != null && area['areas'] is List) {
        if (_addAreaToParent(
          (area['areas'] as List).cast<Map<String, dynamic>>(),
          parentName,
          newArea,
        )) {
          return true;
        }
      }
    }
    return false;
  }
}