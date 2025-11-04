import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/calculation_result.dart';
import '../../data/models/bedroom_config.dart';
import '../../core/calculations/rent_calculator.dart';
import '../theme/app_theme.dart';

/// Rent range output display
/// Ported from RentRangeOutput component
class RentRangeOutput extends StatelessWidget {
  final RentRange rentRange;
  final double netMonthlyIncome;
  final double grossIncome;
  final IncomeType incomeType;
  final String stateAbbr;
  final bool hasRoommates;
  final BedroomConfiguration bedroom;
  final String? neighborhoodName;
  final double? neighborhoodAverageRent;

  const RentRangeOutput({
    super.key,
    required this.rentRange,
    required this.netMonthlyIncome,
    required this.grossIncome,
    required this.incomeType,
    required this.stateAbbr,
    required this.hasRoommates,
    required this.bedroom,
    this.neighborhoodName,
    this.neighborhoodAverageRent,
  });

  @override
  Widget build(BuildContext context) {
    final values = [
      rentRange.conservative,
      rentRange.balanced,
      rentRange.stretch,
    ];

    // Calculate ACTUAL percentages after bedroom multipliers are applied
    final actualPercentages = values.map((value) {
      if (netMonthlyIncome > 0) {
        return (value / netMonthlyIncome) * 100;
      }
      return 0.0;
    }).toList();

    final labels = [
      '${actualPercentages[0].toStringAsFixed(1)}% of net income',
      '${actualPercentages[1].toStringAsFixed(1)}% of net income',
      '${actualPercentages[2].toStringAsFixed(1)}% of net income',
    ];

    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    // Format gross income for display
    String grossIncomeDisplay;
    switch (incomeType) {
      case IncomeType.hourly:
        grossIncomeDisplay = '${formatter.format(grossIncome)}/hr';
        break;
      case IncomeType.monthly:
        grossIncomeDisplay = '${formatter.format(grossIncome)}/mo';
        break;
      case IncomeType.annual:
        grossIncomeDisplay = '${formatter.format(grossIncome)}/yr';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Explicit salary-to-affordability connection
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What You Can Afford',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      const TextSpan(text: 'With your '),
                      TextSpan(
                        text: grossIncomeDisplay,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text: ' salary in $stateAbbr',
                      ),
                      const TextSpan(text: ', your net monthly income is '),
                      TextSpan(
                        text: formatter.format(netMonthlyIncome),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentRed,
                        ),
                      ),
                      const TextSpan(text: ' (after taxes).'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on this, here\'s what you can afford for a ${bedroom.displayName.toLowerCase()}:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          values.length,
          (index) => _RentRangeCard(
            label: labels[index],
            value: formatter.format(values[index]),
            percentage: actualPercentages[index] / 100, // Convert back to decimal for card display
          ),
        ),
        // SEPARATE: Market context (not affordability)
        if (neighborhoodName != null && neighborhoodAverageRent != null) ...[
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          // Rename to "Market Context" instead of mixing with affordability
          Text(
            'Market Context',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Average rent in $neighborhoodName (for reference only)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          _NeighborhoodContextCard(
            neighborhoodName: neighborhoodName!,
            neighborhoodAverageRent: neighborhoodAverageRent!,
            balancedRent: rentRange.balanced,
            bedroom: bedroom,
          ),
        ],
      ],
    );
  }
}

class _RentRangeCard extends StatelessWidget {
  final String label;
  final String value;
  final double percentage;

  const _RentRangeCard({
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 6,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            '$value/mo',
            style: const TextStyle(
              color: AppTheme.accentRed,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _NeighborhoodContextCard extends StatelessWidget {
  final String neighborhoodName;
  final double neighborhoodAverageRent;
  final double balancedRent;
  final BedroomConfiguration bedroom;

  const _NeighborhoodContextCard({
    required this.neighborhoodName,
    required this.neighborhoodAverageRent,
    required this.balancedRent,
    required this.bedroom,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    // Apply bedroom multiplier to neighborhood rent for comparison
    final adjustedNeighborhoodRent = RentCalculator.applyBedroomMultiplier(
      neighborhoodAverageRent,
      bedroom,
    );
    final difference = balancedRent - adjustedNeighborhoodRent;
    final percentDiff = (difference / adjustedNeighborhoodRent) * 100;
    
    String comparisonText;
    Color comparisonColor;
    
    if (percentDiff.abs() <= 1) {
      comparisonText = 'Your balanced range is close to the neighborhood average';
      comparisonColor = Colors.green;
    } else if (percentDiff > 0) {
      comparisonText = 'Your balanced range is ${percentDiff.abs().toStringAsFixed(1)}% above the neighborhood average';
      comparisonColor = Colors.orange;
    } else {
      comparisonText = 'Your balanced range is ${percentDiff.abs().toStringAsFixed(1)}% below the neighborhood average';
      comparisonColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: comparisonColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: comparisonColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: comparisonColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Neighborhood Context',
                style: TextStyle(
                  color: comparisonColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Average Market Rent (${bedroom.displayName})',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${formatter.format(adjustedNeighborhoodRent)}/mo',
            style: TextStyle(
              color: comparisonColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            comparisonText,
            style: TextStyle(
              color: comparisonColor,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

