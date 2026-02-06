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
          "id": "3",
          "name": "Parcelle Nord",
          "color": "FFE74C3C",
          "is_tracked": true,
          "level": 1,
          "analytics": {
            "air_temperature": [
              {
                "value": 18,
                "occurred_at": "2025-11-05T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              },
              {
                "value": 20,
                "occurred_at": "2025-11-06T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              },
              {
                "value": 19,
                "occurred_at": "2025-11-07T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              }
            ],
            "soil_temperature": [
              {
                "value": 15,
                "occurred_at": "2025-11-05T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              },
              {
                "value": 16,
                "occurred_at": "2025-11-06T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              }
            ],
            "air_humidity": [
              {
                "value": 75,
                "occurred_at": "2025-11-09T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              },
              {
                "value": 70,
                "occurred_at": "2025-11-10T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              },
              {
                "value": 68,
                "occurred_at": "2025-11-11T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              }
            ],
            "soil_humidity": [
              {
                "value": 50,
                "occurred_at": "2025-11-10T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              },
              {
                "value": 48,
                "occurred_at": "2025-11-11T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              }
            ],
            "deep_soil_humidity": [
              {
                "value": 55,
                "occurred_at": "2025-11-09T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              },
              {
                "value": 65,
                "occurred_at": "2025-11-10T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              },
              {
                "value": 48,
                "occurred_at": "2025-11-11T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              }
            ],
            "light": [
              {
                "value": 38,
                "occurred_at": "2025-11-09T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              },
              {
                "value": 41,
                "occurred_at": "2025-11-10T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              },
              {
                "value": 34,
                "occurred_at": "2025-11-11T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              }
            ]
          },
          "areas": [
            {
              "id": "7",
              "name": "Planche Tomates Nord",
              "color": "FFE74C3C",
              "is_tracked": true,
              "level": 2,
              "analytics": {
                "air_temperature": [
                  {
                    "value": 18,
                    "occurred_at": "2025-11-05T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  },
                  {
                    "value": 20,
                    "occurred_at": "2025-11-06T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  },
                  {
                    "value": 19,
                    "occurred_at": "2025-11-07T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  }
                ],
                "soil_temperature": [
                  {
                    "value": 15,
                    "occurred_at": "2025-11-05T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  },
                  {
                    "value": 16,
                    "occurred_at": "2025-11-06T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  }
                ],
                "air_humidity": [
                  {
                    "value": 75,
                    "occurred_at": "2025-11-09T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  },
                  {
                    "value": 70,
                    "occurred_at": "2025-11-10T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  },
                  {
                    "value": 68,
                    "occurred_at": "2025-11-11T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  }
                ],
                "soil_humidity": [
                  {
                    "value": 50,
                    "occurred_at": "2025-11-10T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  },
                  {
                    "value": 48,
                    "occurred_at": "2025-11-11T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  }
                ],
                "deep_soil_humidity": [
                  {
                    "value": 55,
                    "occurred_at": "2025-11-09T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  },
                  {
                    "value": 65,
                    "occurred_at": "2025-11-10T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  },
                  {
                    "value": 48,
                    "occurred_at": "2025-11-11T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  }
                ],
                "light": [
                  {
                    "value": 38,
                    "occurred_at": "2025-11-09T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  },
                  {
                    "value": 41,
                    "occurred_at": "2025-11-10T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  },
                  {
                    "value": 34,
                    "occurred_at": "2025-11-11T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  }
                ]
              },
              "cells": [
                {
                  "id": "14",
                  "name": "Tomate Serre Nord",
                  "battery": 67,
                  "is_tracked": true,
                  "last_update_at": "2026-01-09 09:46:26",
                  "location": "Champ #1 > Parcelle #3 > Planche A",
                  "analytics": {
                    "air_temperature": [
                      {
                        "value": 18,
                        "occurred_at": "2025-11-05T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 20,
                        "occurred_at": "2025-11-06T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      },
                      {
                        "value": 19,
                        "occurred_at": "2025-11-07T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      }
                    ],
                    "soil_temperature": [
                      {
                        "value": 15,
                        "occurred_at": "2025-11-05T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 16,
                        "occurred_at": "2025-11-06T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "air_humidity": [
                      {
                        "value": 75,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 70,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      },
                      {
                        "value": 68,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      }
                    ],
                    "soil_humidity": [
                      {
                        "value": 50,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 48,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "deep_soil_humidity": [
                      {
                        "value": 55,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 65,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 48,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "light": [
                      {
                        "value": 38,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 41,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 34,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ]
                  }
                },
                {
                  "id": "15",
                  "name": "Tomate Serre Nord A2",
                  "battery": 67,
                  "is_tracked": true,
                  "last_update_at": "2026-01-09 09:46:26",
                  "location": "Champ #1 > Parcelle #3 > Planche A",
                  "analytics": {
                    "air_temperature": [
                      {
                        "value": 18,
                        "occurred_at": "2025-11-05T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 20,
                        "occurred_at": "2025-11-06T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      },
                      {
                        "value": 19,
                        "occurred_at": "2025-11-07T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      }
                    ],
                    "soil_temperature": [
                      {
                        "value": 15,
                        "occurred_at": "2025-11-05T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 16,
                        "occurred_at": "2025-11-06T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "air_humidity": [
                      {
                        "value": 75,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 70,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      },
                      {
                        "value": 68,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      }
                    ],
                    "soil_humidity": [
                      {
                        "value": 50,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 48,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "deep_soil_humidity": [
                      {
                        "value": 55,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 65,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 48,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "light": [
                      {
                        "value": 38,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 41,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 34,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ]
                  }
                }
              ]
            },
          ]
        },
        {
          "id": "4",
          "name": "Parcelle Sud",
          "is_tracked": true,
          "color": "FF3498DB",
          "level": 1,
          "analytics": {
            "air_temperature": [
              {
                "value": 18,
                "occurred_at": "2025-11-05T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              },
              {
                "value": 20,
                "occurred_at": "2025-11-06T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              },
              {
                "value": 19,
                "occurred_at": "2025-11-07T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              }
            ],
            "soil_temperature": [
              {
                "value": 15,
                "occurred_at": "2025-11-05T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              },
              {
                "value": 16,
                "occurred_at": "2025-11-06T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              }
            ],
            "air_humidity": [
              {
                "value": 75,
                "occurred_at": "2025-11-09T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              },
              {
                "value": 70,
                "occurred_at": "2025-11-10T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              },
              {
                "value": 68,
                "occurred_at": "2025-11-11T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              }
            ],
            "soil_humidity": [
              {
                "value": 50,
                "occurred_at": "2025-11-10T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              },
              {
                "value": 48,
                "occurred_at": "2025-11-11T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              }
            ],
            "deep_soil_humidity": [
              {
                "value": 55,
                "occurred_at": "2025-11-09T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              },
              {
                "value": 65,
                "occurred_at": "2025-11-10T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              },
              {
                "value": 48,
                "occurred_at": "2025-11-11T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              }
            ],
            "light": [
              {
                "value": 38,
                "occurred_at": "2025-11-09T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "OK"
              },
              {
                "value": 41,
                "occurred_at": "2025-11-10T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "WARNING"
              },
              {
                "value": 34,
                "occurred_at": "2025-11-11T08:00:00Z",
                "sensor_id": 12,
                "alert_status":  "ALERT"
              }
            ]
          },
          "areas": [
            {
              "id": "8",
              "name": "Planche Tomates Sud",
              "is_tracked": true,
              "color": "FF3498DB",
              "level": 2,
              "analytics": {
                "air_temperature": [
                  {
                    "value": 18,
                    "occurred_at": "2025-11-05T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  },
                  {
                    "value": 20,
                    "occurred_at": "2025-11-06T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  },
                  {
                    "value": 19,
                    "occurred_at": "2025-11-07T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  }
                ],
                "soil_temperature": [
                  {
                    "value": 15,
                    "occurred_at": "2025-11-05T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  },
                  {
                    "value": 16,
                    "occurred_at": "2025-11-06T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  }
                ],
                "air_humidity": [
                  {
                    "value": 75,
                    "occurred_at": "2025-11-09T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  },
                  {
                    "value": 70,
                    "occurred_at": "2025-11-10T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  },
                  {
                    "value": 68,
                    "occurred_at": "2025-11-11T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  }
                ],
                "soil_humidity": [
                  {
                    "value": 50,
                    "occurred_at": "2025-11-10T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  },
                  {
                    "value": 48,
                    "occurred_at": "2025-11-11T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  }
                ],
                "deep_soil_humidity": [
                  {
                    "value": 55,
                    "occurred_at": "2025-11-09T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  },
                  {
                    "value": 65,
                    "occurred_at": "2025-11-10T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  },
                  {
                    "value": 48,
                    "occurred_at": "2025-11-11T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  }
                ],
                "light": [
                  {
                    "value": 38,
                    "occurred_at": "2025-11-09T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "OK"
                  },
                  {
                    "value": 41,
                    "occurred_at": "2025-11-10T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "WARNING"
                  },
                  {
                    "value": 34,
                    "occurred_at": "2025-11-11T08:00:00Z",
                    "sensor_id": 12,
                    "alert_status":  "ALERT"
                  }
                ]
              },
              "cells": [
                {
                  "id": "15",
                  "name": "Tomate Serre Sud A1",
                  "battery": 67,
                  "is_tracked": true,
                  "last_update_at": "2026-01-09 09:46:26",
                  "location": "Champ #1 > Parcelle #3 > Planche A",
                  "analytics": {
                    "air_temperature": [
                      {
                        "value": 18,
                        "occurred_at": "2025-11-05T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 20,
                        "occurred_at": "2025-11-06T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      },
                      {
                        "value": 19,
                        "occurred_at": "2025-11-07T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      }
                    ],
                    "soil_temperature": [
                      {
                        "value": 15,
                        "occurred_at": "2025-11-05T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 16,
                        "occurred_at": "2025-11-06T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "air_humidity": [
                      {
                        "value": 75,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 70,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      },
                      {
                        "value": 68,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      }
                    ],
                    "soil_humidity": [
                      {
                        "value": 50,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 48,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "deep_soil_humidity": [
                      {
                        "value": 55,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 65,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 48,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "light": [
                      {
                        "value": 38,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 41,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 34,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ]
                  }
                },
                {
                  "id": "15",
                  "name": "Tomate Serre Sud A2",
                  "battery": 67,
                  "is_tracked": true,
                  "last_update_at": "2026-01-09 09:46:26",
                  "location": "Champ #1 > Parcelle #3 > Planche A",
                  "analytics": {
                    "air_temperature": [
                      {
                        "value": 18,
                        "occurred_at": "2025-11-05T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 20,
                        "occurred_at": "2025-11-06T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      },
                      {
                        "value": 19,
                        "occurred_at": "2025-11-07T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      }
                    ],
                    "soil_temperature": [
                      {
                        "value": 15,
                        "occurred_at": "2025-11-05T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 16,
                        "occurred_at": "2025-11-06T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "air_humidity": [
                      {
                        "value": 75,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 70,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      },
                      {
                        "value": 68,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      }
                    ],
                    "soil_humidity": [
                      {
                        "value": 50,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 48,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "deep_soil_humidity": [
                      {
                        "value": 55,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 65,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 48,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ],
                    "light": [
                      {
                        "value": 38,
                        "occurred_at": "2025-11-09T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "OK"
                      },
                      {
                        "value": 41,
                        "occurred_at": "2025-11-10T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "WARNING"
                      },
                      {
                        "value": 34,
                        "occurred_at": "2025-11-11T08:00:00Z",
                        "sensor_id": 12,
                        "alert_status":  "ALERT"
                      }
                    ]
                  }
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
        "id": "1",
        "name": name,
        "color": color,
        "level": parentArea != null ? parentArea.level + 1 : 1,
        "areas": <Map<String, dynamic>>[],
        "is_tracked": false,
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

// Ajoutez cette méthode après fetchAreas()
  Future<Area?> fetchAreaById(int id) async {
    try {
      // Utiliser le cache si disponible
      if (_cachedAreas != null) {
        final allAreas = _cachedAreas!.map((area) => Area.fromJson(area)).toList();
        final flattenedAreas = Area.getAllAreasFlattened(allAreas);
        return flattenedAreas.cast<Area?>().firstWhere(
              (area) => area?.id == id,
          orElse: () => null,
        );
      }

      // Si pas de cache, charger d'abord les areas
      await fetchAreas();
      return fetchAreaById(id);
    } catch (e) {
      throw Exception('Failed to load area with id $id: $e');
    }
  }

  Future<Area> updateArea({
    required String id,
    required String name,
    required Color color,
    required bool isTracked,
    Area? parentArea,
  }) async {
    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(milliseconds: 500));

      if (_cachedAreas == null) {
        throw Exception('Cache not initialized');
      }

      // Trouver et mettre à jour l'area
      final updated = _updateAreaInList(
        _cachedAreas!,
        id,
        name,
        color,
        parentArea,
        isTracked
      );

      if (!updated) {
        throw Exception('Area with id $id not found');
      }

      // Récupérer l'area mise à jour
      final allAreas = _cachedAreas!.map((area) => Area.fromJson(area)).toList();
      final flattenedAreas = Area.getAllAreasFlattened(allAreas);

      return flattenedAreas.firstWhere((area) => area.id != null && area.id == id);
    } catch (e) {
      throw Exception('Failed to update area: $e');
    }
  }

  bool _updateAreaInList(
      List<Map<String, dynamic>> areas,
      String id,
      String name,
      Color color,
      Area? parentArea,
      bool isTracked,
      ) {
    for (var i = 0; i < areas.length; i++) {
      final area = areas[i];

      if (area['id'] == id) {
        // Area trouvée, la mettre à jour
        area['name'] = name;
        area['color'] = color.value.toRadixString(16).toUpperCase();
        area['is_tracked'] = isTracked;

        // Si on change de parent, il faut déplacer l'area
        if (parentArea != null) {
          // Retirer de la liste actuelle
          final areaToMove = areas.removeAt(i);
          // Calculer le nouveau niveau
          areaToMove['level'] = parentArea.level + 1;
          // Ajouter au nouveau parent
          _addAreaToParent(_cachedAreas!, parentArea.name, areaToMove);
        }

        return true;
      }

      // Chercher récursivement dans les sous-areas
      if (area['areas'] != null && area['areas'] is List) {
        if (_updateAreaInList(
          (area['areas'] as List).cast<Map<String, dynamic>>(),
          id,
          name,
          color,
          parentArea,
          isTracked,
        )) {
          return true;
        }
      }
    }

    return false;
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