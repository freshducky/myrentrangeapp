import 'bedroom_config.dart';

/// Result of a rent calculation
class CalculationResult {
  final double netMonthlyIncome;
  final RentRange affordableRent;
  final RentBurdenLevel burdenLevel;
  final double burdenPercentage;
  final String insights;
  final BedroomConfiguration selectedBedroom;
  final String? selectedNeighborhood;
  final double? neighborhoodAverageRent;

  CalculationResult({
    required this.netMonthlyIncome,
    required this.affordableRent,
    required this.burdenLevel,
    required this.burdenPercentage,
    required this.insights,
    required this.selectedBedroom,
    this.selectedNeighborhood,
    this.neighborhoodAverageRent,
  });
}

/// Rent range with different percentage levels
class RentRange {
  final double conservative; // 20%
  final double balanced; // 25% or 30%
  final double stretch; // 30% or 40%

  RentRange({
    required this.conservative,
    required this.balanced,
    required this.stretch,
  });
}

/// Rent burden classification levels
enum RentBurdenLevel {
  safe, // < 30%
  high, // 30-50%
  severe, // > 50%
}

extension RentBurdenLevelExtension on RentBurdenLevel {
  String get label {
    switch (this) {
      case RentBurdenLevel.safe:
        return 'Safe Rent Burden';
      case RentBurdenLevel.high:
        return 'High Rent Burden';
      case RentBurdenLevel.severe:
        return 'Severe Rent Burden';
    }
  }

  String get icon {
    switch (this) {
      case RentBurdenLevel.safe:
        return '✅';
      case RentBurdenLevel.high:
        return '⚠️';
      case RentBurdenLevel.severe:
        return '🎯';
    }
  }
}

