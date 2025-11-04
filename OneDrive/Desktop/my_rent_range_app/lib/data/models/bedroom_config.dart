/// Bedroom configuration options
enum BedroomConfiguration {
  studio,
  oneBedroom,
  twoBedrooms,
  threePlusBedrooms,
}

extension BedroomConfigurationExtension on BedroomConfiguration {
  /// Get the multiplier for this bedroom configuration
  double get multiplier {
    switch (this) {
      case BedroomConfiguration.studio:
        return 0.7;
      case BedroomConfiguration.oneBedroom:
        return 1.0;
      case BedroomConfiguration.twoBedrooms:
        return 1.4;
      case BedroomConfiguration.threePlusBedrooms:
        return 1.8;
    }
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case BedroomConfiguration.studio:
        return 'Studio';
      case BedroomConfiguration.oneBedroom:
        return '1 Bedroom';
      case BedroomConfiguration.twoBedrooms:
        return '2 Bedrooms';
      case BedroomConfiguration.threePlusBedrooms:
        return '3+ Bedrooms';
    }
  }

  /// Get short description for insights
  String get description {
    switch (this) {
      case BedroomConfiguration.studio:
        return 'studio';
      case BedroomConfiguration.oneBedroom:
        return '1-bedroom';
      case BedroomConfiguration.twoBedrooms:
        return '2-bedroom';
      case BedroomConfiguration.threePlusBedrooms:
        return '3+ bedroom';
    }
  }

  /// Get default configuration (1 Bedroom)
  static BedroomConfiguration getDefault() {
    return BedroomConfiguration.oneBedroom;
  }
}

