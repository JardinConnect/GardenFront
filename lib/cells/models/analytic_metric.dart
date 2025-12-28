enum AnalyticMetric {
  airTemperature,
  soilTemperature,
  airHumidity,
  soilHumidity,
  luminosity,
  deepSoilHumidity;

  String get label {
    switch (this) {
      case AnalyticMetric.airTemperature:
        return "Température Air";
      case AnalyticMetric.soilTemperature:
        return "Température Sol";
      case AnalyticMetric.airHumidity:
        return "Humidité Air";
      case AnalyticMetric.soilHumidity:
        return "Humidité Sol";
      case AnalyticMetric.luminosity:
        return "Luminosité";
      case AnalyticMetric.deepSoilHumidity:
        return "Humidité du sol profond";
    }
  }

  String get unit {
    switch (this) {
      case AnalyticMetric.airTemperature:
        return "°C";
      case AnalyticMetric.soilTemperature:
        return "°C";
      case AnalyticMetric.airHumidity:
        return "%";
      case AnalyticMetric.soilHumidity:
        return "%";
      case AnalyticMetric.luminosity:
        return "lux";
      case AnalyticMetric.deepSoilHumidity:
        return "%";
    }
  }
}
