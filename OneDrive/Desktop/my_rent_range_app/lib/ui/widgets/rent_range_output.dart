import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/calculation_result.dart';
import '../theme/app_theme.dart';

/// Rent range output display
/// Ported from RentRangeOutput component
class RentRangeOutput extends StatelessWidget {
  final RentRange rentRange;
  final bool hasRoommates;

  const RentRangeOutput({
    super.key,
    required this.rentRange,
    required this.hasRoommates,
  });

  @override
  Widget build(BuildContext context) {
    final percentages = hasRoommates
        ? [0.20, 0.30, 0.40]
        : [0.20, 0.25, 0.30];

    final values = [
      rentRange.conservative,
      rentRange.balanced,
      rentRange.stretch,
    ];

    final labels = [
      '${(percentages[0] * 100).toInt()}% of net income',
      '${(percentages[1] * 100).toInt()}% of net income',
      '${(percentages[2] * 100).toInt()}% of net income',
    ];

    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rent Range',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.accentRed,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          values.length,
          (index) => _RentRangeCard(
            label: labels[index],
            value: formatter.format(values[index]),
            percentage: percentages[index],
          ),
        ),
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
            color: AppTheme.primaryBlue,
            width: 6,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
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
            style: const TextStyle(
              color: AppTheme.primaryBlue,
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

