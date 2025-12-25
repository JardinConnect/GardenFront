enum AnalyticMetric {
  AIR_TEMPERATURE,
  SOIL_TEMPERATURE,
  AIR_HUMIDITY,
  SOIL_HUMIDITY,
  LUMINOSITY,
  RAIN;

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
      case AnalyticMetric.RAIN:
        return "Pluie";
    }
  }
}
