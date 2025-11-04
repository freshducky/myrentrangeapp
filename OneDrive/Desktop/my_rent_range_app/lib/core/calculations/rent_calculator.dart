import '../../data/models/calculation_result.dart';
import '../../data/models/bedroom_config.dart';
import '../../data/sources/tax_rates.dart';
import '../../data/sources/neighborhoods_data.dart';

/// Income type enumeration
enum IncomeType {
  hourly,
  monthly,
  annual,
}

/// Core rent calculation engine
/// Ported from TypeScript functions in src/pages/index.tsx
class RentCalculator {
  /// FICA tax rate (Social Security + Medicare)
  static const double ficaRate = 0.0765;

  /// Car ownership monthly cost deduction
  static const double carOwnershipCost = 500.0;

  /// Convert gross income to monthly based on type
  /// Ported from grossToMonthly() in index.tsx
  static double calculateMonthlyIncome(double gross, IncomeType type) {
    switch (type) {
      case IncomeType.hourly:
        // hourly * 40 hours/week * 52 weeks/year / 12 months
        return gross * 40 * 52 / 12;
      case IncomeType.annual:
        return gross / 12;
      case IncomeType.monthly:
        return gross;
    }
  }

  /// Calculate net monthly income after taxes and deductions
  /// Ported from calcNetMonthly() in index.tsx
  static double calculateNetIncome({
    required double grossMonthly,
    required String stateAbbr,
    required bool ownsCar,
  }) {
    // Get state tax rate
    final stateTaxRate = TaxRates.getRate(stateAbbr);

    // Calculate net: gross * (1 - FICA - stateTax)
    double net = grossMonthly * (1 - ficaRate - stateTaxRate);

    // Subtract car ownership cost if applicable
    if (ownsCar) {
      net -= carOwnershipCost;
    }

    // Ensure non-negative
    return net > 0 ? net : 0;
  }

  /// Calculate rent ranges based on net income and living situation
  /// Applies bedroom multiplier to adjust for unit size
  static RentRange calculateRentRanges({
    required double netMonthly,
    required bool hasRoommates,
    BedroomConfiguration bedroom = BedroomConfiguration.oneBedroom,
  }) {
    final baseMultiplier = bedroom.multiplier;
    
    RentRange baseRange;
    if (hasRoommates) {
      // Living with roommates: 20%, 30%, 40%
      baseRange = RentRange(
        conservative: netMonthly * 0.20,
        balanced: netMonthly * 0.30,
        stretch: netMonthly * 0.40,
      );
    } else {
      // Living alone: 20%, 25%, 30%
      baseRange = RentRange(
        conservative: netMonthly * 0.20,
        balanced: netMonthly * 0.25,
        stretch: netMonthly * 0.30,
      );
    }
    
    // Apply bedroom multiplier
    return RentRange(
      conservative: baseRange.conservative * baseMultiplier,
      balanced: baseRange.balanced * baseMultiplier,
      stretch: baseRange.stretch * baseMultiplier,
    );
  }
  
  /// Apply bedroom multiplier to a rent value
  static double applyBedroomMultiplier(
    double rent,
    BedroomConfiguration bedroom,
  ) {
    return rent * bedroom.multiplier;
  }

  /// Calculate rent burden level and percentage
  /// Ported from InsightsPanel rent burden calculation
  static RentBurdenLevel calculateRentBurden({
    required double rent,
    required double netMonthlyIncome,
  }) {
    if (netMonthlyIncome <= 0 || rent <= 0) {
      return RentBurdenLevel.safe;
    }

    final burden = rent / netMonthlyIncome;

    if (burden >= 0.50) {
      return RentBurdenLevel.severe;
    } else if (burden >= 0.30) {
      return RentBurdenLevel.high;
    } else {
      return RentBurdenLevel.safe;
    }
  }

  /// Calculate burden percentage (0.0 to 1.0)
  static double calculateBurdenPercentage({
    required double rent,
    required double netMonthlyIncome,
  }) {
    if (netMonthlyIncome <= 0) {
      return 0.0;
    }
    return rent / netMonthlyIncome;
  }

  /// Complete calculation: takes gross income and returns full result
  static CalculationResult calculate({
    required double grossIncome,
    required IncomeType incomeType,
    required String stateAbbr,
    required bool ownsCar,
    required bool hasRoommates,
    BedroomConfiguration bedroom = BedroomConfiguration.oneBedroom,
    double? actualRent, // Optional: for rent burden calculation
    String? cityName, // Optional: city name for neighborhood lookup
    String? neighborhoodName, // Optional: neighborhood name for context
  }) {
    // Step 1: Convert to monthly gross
    final monthlyGross = calculateMonthlyIncome(grossIncome, incomeType);

    // Step 2: Calculate net income
    final netMonthly = calculateNetIncome(
      grossMonthly: monthlyGross,
      stateAbbr: stateAbbr,
      ownsCar: ownsCar,
    );

    // Step 3: Calculate rent ranges (with bedroom multiplier)
    final rentRange = calculateRentRanges(
      netMonthly: netMonthly,
      hasRoommates: hasRoommates,
      bedroom: bedroom,
    );

    // Step 4: Calculate rent burden if actual rent provided
    RentBurdenLevel burdenLevel = RentBurdenLevel.safe;
    double burdenPercentage = 0.0;
    String insights = '';

    // Step 5: Get neighborhood data if provided
    String? selectedNeighborhood;
    double? neighborhoodAverageRent;
    if (neighborhoodName != null && 
        neighborhoodName.isNotEmpty && 
        cityName != null && 
        cityName.isNotEmpty) {
      final neighborhood = NeighborhoodsDataSource.getNeighborhoodByName(
        stateAbbr,
        cityName,
        neighborhoodName,
      );
      if (neighborhood != null) {
        selectedNeighborhood = neighborhood.name;
        neighborhoodAverageRent = neighborhood.averageRent;
      }
    }

    if (actualRent != null && actualRent > 0) {
      burdenLevel = calculateRentBurden(
        rent: actualRent,
        netMonthlyIncome: netMonthly,
      );
      burdenPercentage = calculateBurdenPercentage(
        rent: actualRent,
        netMonthlyIncome: netMonthly,
      );

      // Generate insights
      insights = _generateInsights(
        burdenLevel: burdenLevel,
        burdenPercentage: burdenPercentage,
        rentRange: rentRange,
        actualRent: actualRent,
        bedroom: bedroom,
        neighborhoodName: selectedNeighborhood,
        neighborhoodAverageRent: neighborhoodAverageRent,
      );
    } else {
      insights = _generateDefaultInsights(
        netMonthly: netMonthly,
        rentRange: rentRange,
        hasRoommates: hasRoommates,
        bedroom: bedroom,
        neighborhoodName: selectedNeighborhood,
        neighborhoodAverageRent: neighborhoodAverageRent,
      );
    }

    return CalculationResult(
      netMonthlyIncome: netMonthly,
      affordableRent: rentRange,
      burdenLevel: burdenLevel,
      burdenPercentage: burdenPercentage,
      insights: insights,
      selectedBedroom: bedroom,
      selectedNeighborhood: selectedNeighborhood,
      neighborhoodAverageRent: neighborhoodAverageRent,
    );
  }

  static String _generateInsights({
    required RentBurdenLevel burdenLevel,
    required double burdenPercentage,
    required RentRange rentRange,
    required double actualRent,
    required BedroomConfiguration bedroom,
    String? neighborhoodName,
    double? neighborhoodAverageRent,
  }) {
    final percentage = (burdenPercentage * 100).toStringAsFixed(1);
    final levelLabel = burdenLevel.label;
    final levelIcon = burdenLevel.icon;

    final buffer = StringBuffer();
    buffer.writeln('$levelIcon $levelLabel: $percentage%');
    buffer.writeln('');
    buffer.writeln('Your rent of \$${actualRent.toStringAsFixed(0)}/mo represents '
        '$percentage% of your net monthly income.');
    buffer.writeln('');
    buffer.writeln('Affordable rent ranges:');
    buffer.writeln('• Conservative: \$${rentRange.conservative.toStringAsFixed(0)}/mo (20%)');
    buffer.writeln('• Balanced: \$${rentRange.balanced.toStringAsFixed(0)}/mo '
        '(${(rentRange.balanced / rentRange.conservative * 20).toStringAsFixed(0)}%)');
    buffer.writeln('• Stretch: \$${rentRange.stretch.toStringAsFixed(0)}/mo '
        '(${(rentRange.stretch / rentRange.conservative * 20).toStringAsFixed(0)}%)');

    // Add neighborhood context if available (with bedroom multiplier applied)
    if (neighborhoodName != null && neighborhoodAverageRent != null) {
      buffer.writeln('');
      buffer.writeln('Neighborhood context:');
      final adjustedNeighborhoodRent = applyBedroomMultiplier(neighborhoodAverageRent, bedroom);
      buffer.writeln('$neighborhoodName average ${bedroom.description} rent: \$${adjustedNeighborhoodRent.toStringAsFixed(0)}/mo');
      
      final difference = rentRange.balanced - adjustedNeighborhoodRent;
      final percentDiff = (difference / adjustedNeighborhoodRent) * 100;
      if (percentDiff.abs() > 1) {
        final direction = percentDiff > 0 ? 'above' : 'below';
        buffer.writeln('Your balanced range is ${percentDiff.abs().toStringAsFixed(1)}% $direction the neighborhood average');
      } else {
        buffer.writeln('Your balanced range is close to the neighborhood average');
      }
    }

    return buffer.toString();
  }

  static String _generateDefaultInsights({
    required double netMonthly,
    required RentRange rentRange,
    required bool hasRoommates,
    required BedroomConfiguration bedroom,
    String? neighborhoodName,
    double? neighborhoodAverageRent,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Your net monthly income: \$${netMonthly.toStringAsFixed(0)}');
    buffer.writeln('');
    buffer.writeln('Based on your situation${hasRoommates ? " (with roommates)" : " (living alone)"} '
        'for a ${bedroom.description} unit, your affordable rent ranges are:');
    buffer.writeln('• Conservative: \$${rentRange.conservative.toStringAsFixed(0)}/mo (20%)');
    buffer.writeln('• Balanced: \$${rentRange.balanced.toStringAsFixed(0)}/mo '
        '(${(rentRange.balanced / rentRange.conservative * 20).toStringAsFixed(0)}%)');
    buffer.writeln('• Stretch: \$${rentRange.stretch.toStringAsFixed(0)}/mo '
        '(${(rentRange.stretch / rentRange.conservative * 20).toStringAsFixed(0)}%)');

    // Add neighborhood context if available (with bedroom multiplier applied)
    if (neighborhoodName != null && neighborhoodAverageRent != null) {
      buffer.writeln('');
      buffer.writeln('Neighborhood context:');
      final adjustedNeighborhoodRent = applyBedroomMultiplier(neighborhoodAverageRent, bedroom);
      buffer.writeln('$neighborhoodName average ${bedroom.description} rent: \$${adjustedNeighborhoodRent.toStringAsFixed(0)}/mo');
      
      final difference = rentRange.balanced - adjustedNeighborhoodRent;
      final percentDiff = (difference / adjustedNeighborhoodRent) * 100;
      if (percentDiff.abs() > 1) {
        final direction = percentDiff > 0 ? 'above' : 'below';
        buffer.writeln('Your balanced range is ${percentDiff.abs().toStringAsFixed(1)}% $direction the neighborhood average');
      } else {
        buffer.writeln('Your balanced range is close to the neighborhood average');
      }
    }

    return buffer.toString();
  }
}

