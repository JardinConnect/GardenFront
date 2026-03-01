# Endpoints API - Gestion des Alertes

Ce document liste les endpoints API nécessaires pour le module de gestion des alertes.

## Vue d'ensemble

### Pages présentes dans le scope Alerte

#### Alerte Visualisation
- Voir la liste des alertes configurées sous forme de **cards**
- Carrousel si plusieurs alertes sont configurées sur une même cellule
- Sur chaque card : possibilité d'activer/désactiver l'alerte via toggle
- Par capteur (plusieurs capteurs possibles dans une card) : affichage min/max pour la plage critique et la plage d'avertissement
- Vue en liste également disponible (utilise les mêmes endpoints que la vue en cards)

#### Alerte Historique
- Liste des événements d'alerte déclenchés
- Informations affichées par événement :
  - Type de capteur
  - Nom de la cellule
  - Heure et date de déclenchement
  - Sévérité (critique/avertissement)
  - Valeur mesurée lors du déclenchement
  - Localisation de la cellule
- Actions disponibles :
  - Bouton "Archiver" sur chaque ligne
  - Bouton "Archiver tout" pour archiver tous les événements

#### Alerte CRUD (Création/Modification)
**Création d'une alerte :**
- Nom de l'alerte
- Sélection d'un ou plusieurs capteurs
- Pour chaque capteur :
  - Plage critique (min/max) - **OBLIGATOIRE**
  - Plage d'avertissement (min/max) - **OPTIONNEL**
- Association à une ou plusieurs cellules via checkbox
- Liste des cellules avec : nom + emplacement
- **Validation** : Si une alerte existe déjà sur le même type de capteur pour une cellule sélectionnée, afficher un message de confirmation :
  - _"Cette cellule contient déjà une alerte sur [type capteur]. Voulez-vous écraser l'alerte précédente et sauvegarder celle-ci ?"_
  
**Modification d'une alerte :**
- Mêmes champs que la création
- Zone de danger pour supprimer l'alerte

---

## Besoins Fonctionnels

Le module d'alertes nécessite des endpoints pour :
- **Visualiser** les alertes configurées (liste et détails)
- **Créer/Modifier/Supprimer** des alertes
- **Activer/Désactiver** une alerte
- **Vérifier les conflits** lors de la création (alerte déjà existante sur une cellule/capteur)
- **Consulter l'historique** des événements d'alerte
- **Archiver** les événements (individuellement ou en masse)
- **Récupérer les données de référence** (espaces, cellules, capteurs disponibles)

---

## Gestion des Alertes

### GET `/api/alerts`
**Description** : Récupère la liste de toutes les alertes configurées (pour vue liste et cards)

**Query Parameters** :
- `cellId` (optionnel) : Filtrer par cellule

**Réponse** :
```json
[
  {
    "id": "string",
    "title": "string",
    "isActive": "boolean",
    "cellIds": ["string"],
    "cells": [
      {
        "id": "string",
        "name": "string",
        "location": "string"
      }
    ],
    "sensors": [
      {
        "type": "string",
        "index": "number",
        "criticalRange": {
          "min": "number",
          "max": "number"
        },
        "warningRange": {
          "min": "number",
          "max": "number"
        }
      }
    ],
    "createdAt": "datetime",
    "updatedAt": "datetime"
  }
]
```

---

### GET `/api/alerts/{id}`
**Description** : Récupère les détails complets d'une alerte spécifique (pour modification)

**Paramètres** :
- `id` (path) : Identifiant de l'alerte

**Réponse** :
```json
{
  "id": "string",
  "title": "string",
  "isActive": "boolean",
  "cellIds": ["string"],
  "cells": [
    {
      "id": "string",
      "name": "string",
      "location": "string"
    }
  ],
  "sensors": [
    {
      "type": "string",
      "index": "number",
      "criticalRange": {
        "min": "number",
        "max": "number"
      },
      "warningRange": {
        "min": "number | null",
        "max": "number | null"
      }
    }
  ],
  "warningEnabled": "boolean",
  "createdAt": "datetime",
  "updatedAt": "datetime"
}
```

---

### POST `/api/alerts/validate`
**Description** : Vérifie si une alerte existe déjà sur les cellules sélectionnées pour les types de capteurs choisis

**Body** :
```json
{
  "cellIds": ["string"],
  "sensorTypes": ["string"]
}
```

**Réponse** :
```json
{
  "conflicts": [
    {
      "cellId": "string",
      "cellName": "string",
      "sensorType": "string",
      "existingAlertId": "string",
      "existingAlertTitle": "string",
      "message": "Cette cellule contient déjà une alerte sur l'humidité de la surface du sol."
    }
  ],
  "hasConflicts": "boolean"
}
```

---

### POST `/api/alerts`
**Description** : Crée une nouvelle alerte

**Body** :
```json
{
  "title": "string",
  "isActive": "boolean",
  "cellIds": ["string"],
  "sensors": [
    {
      "type": "string",
      "index": "number",
      "criticalRange": {
        "min": "number",
        "max": "number"
      },
      "warningRange": {
        "min": "number | null",
        "max": "number | null"
      }
    }
  ],
  "warningEnabled": "boolean",
  "overwriteExisting": "boolean"
}
```

**Réponse** :
```json
{
  "id": "string",
  "title": "string",
  "message": "Alerte créée avec succès",
  "overwrittenAlerts": ["string"]
}
```

**Codes de réponse** :
- `201 Created` : Alerte créée avec succès
- `409 Conflict` : Conflit détecté et `overwriteExisting` est `false`

---

### PUT `/api/alerts/{id}`
**Description** : Met à jour une alerte existante

**Paramètres** :
- `id` (path) : Identifiant de l'alerte

**Body** : Identique à POST (sans `overwriteExisting`)

**Réponse** :
```json
{
  "id": "string",
  "title": "string",
  "message": "Alerte mise à jour avec succès"
}
```

---

### PATCH `/api/alerts/{id}/toggle`
**Description** : Active ou désactive une alerte (toggle depuis les cards)

**Paramètres** :
- `id` (path) : Identifiant de l'alerte

**Body** :
```json
{
  "isActive": "boolean"
}
```

**Réponse** :
```json
{
  "id": "string",
  "isActive": "boolean",
  "message": "Statut de l'alerte mis à jour"
}
```

---

### DELETE `/api/alerts/{id}`
**Description** : Supprime une alerte (zone de danger en mode édition)

**Paramètres** :
- `id` (path) : Identifiant de l'alerte

**Réponse** :
```json
{
  "message": "Alerte supprimée avec succès"
}
```

**Code de réponse** : `200 OK` ou `204 No Content`

---

## sGestion des Événements d'Alerte (Historique)

### GET `/api/alerts/events`
**Description** : Récupère l'historique des événements d'alerte non archivés

**Query Parameters** :
- `cellId` (optionnel) : Filtrer par cellule
- `severity` (optionnel) : Filtrer par sévérité (`critical` | `warning`)
- `startDate` (optionnel) : Date de début (ISO 8601)
- `endDate` (optionnel) : Date de fin (ISO 8601)

**Réponse** :
```json
[
  {
    "id": "string",
    "alertId": "string",
    "alertTitle": "string",
    "cellId": "string",
    "cellName": "string",
    "cellLocation": "string",
    "sensorType": "string",
    "severity": "critical" | "warning",
    "value": "number",
    "thresholdMin": "number",
    "thresholdMax": "number",
    "timestamp": "datetime",
    "isArchived": "boolean"
  }
]
```

---

### PATCH `/api/alerts/events/{id}/archive`
**Description** : Archive un événement d'alerte spécifique

**Paramètres** :
- `id` (path) : Identifiant de l'événement

**Réponse** :
```json
{
  "id": "string",
  "message": "Événement archivé avec succès"
}
```

---

### POST `/api/alerts/events/archive-all`
**Description** : Archive tous les événements d'alerte non archivés

**Réponse** :
```json
{
  "archivedCount": "number",
  "message": "Tous les événements ont été archivés"
}
```

---

### POST `/api/alerts/events/archive-by-cell`
**Description** : Archive tous les événements d'une cellule spécifique

**Body** :
```json
{
  "cellId": "string"
}
```

**Réponse** :
```json
{
  "archivedCount": "number",
  "cellId": "string",
  "message": "Événements de la cellule archivés avec succès"
}
```

---

## 🏠 Données de Référence

### GET `/api/spaces`
**Description** : Récupère la liste des espaces (zones) avec leurs cellules

**Réponse** :
```json
[
  {
    "id": "string",
    "name": "string",
    "cells": [
      {
        "id": "string",
        "name": "string",
        "location": "string"
      }
    ]
  }
]
```

---

### GET `/api/cells`
**Description** : Récupère la liste de toutes les cellules disponibles (pour sélection lors de la création d'alerte)

**Réponse** :
```json
[
  {
    "id": "string",
    "name": "string",
    "location": "string",
    "spaceId": "string",
    "spaceName": "string"
  }
]
```

---

### GET `/api/sensors/types`
**Description** : Récupère la liste des types de capteurs disponibles avec leurs contraintes

**Réponse** :
```json
[
  {
    "type": "string",
    "label": "string",
    "unit": "string",
    "minValue": "number",
    "maxValue": "number",
    "defaultCriticalRange": {
      "min": "number",
      "max": "number"
    },
    "defaultWarningRange": {
      "min": "number",
      "max": "number"
    }
  }
]
```

---

## Checklist d'Implémentation

### Frontend (BLoC)
- [ ] Connecter le repository aux vrais endpoints
- [ ] Gérer les erreurs et afficher les messages appropriés
- [ ] Implémenter la logique de validation des conflits
- [ ] Afficher les dialogues de confirmation d'écrasement
- [ ] Tester les flux complets (création, modification, suppression)
-