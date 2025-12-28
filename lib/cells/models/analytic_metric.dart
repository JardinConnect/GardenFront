enum AnalyticMetric {
  AIR_TEMPERATURE,
  SOIL_TEMPERATURE,
  AIR_HUMIDITY,
  SOIL_HUMIDITY,
  LUMINOSITY,
  DEEP_SOIL_HUMIDITY;

  String get label {
    switch (this) {
      case AnalyticMetric.AIR_TEMPERATURE:
        return "Température Air";
      case AnalyticMetric.SOIL_TEMPERATURE:
        return "Température Sol";
      case AnalyticMetric.AIR_HUMIDITY:
        return "Humidité Air";
      case AnalyticMetric.SOIL_HUMIDITY:
        return "Humidité Sol";
      case AnalyticMetric.LUMINOSITY:
        return "Luminosité";
      case AnalyticMetric.DEEP_SOIL_HUMIDITY:
        return "Humidité du sol profond";
    }
  }

  String get unit {
    switch (this) {
      case AnalyticMetric.AIR_TEMPERATURE:
        return "°C";
      case AnalyticMetric.SOIL_TEMPERATURE:
        return "°C";
      case AnalyticMetric.AIR_HUMIDITY:
        return "%";
      case AnalyticMetric.SOIL_HUMIDITY:
        return "%";
      case AnalyticMetric.LUMINOSITY:
        return "lux";
      case AnalyticMetric.DEEP_SOIL_HUMIDITY:
        return "%";
    }
  }
}
