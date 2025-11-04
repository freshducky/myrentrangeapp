import 'package:flutter/material.dart';
import '../../data/sources/neighborhoods_data.dart';

/// Neighborhood selector dropdown
/// Displays when a city with neighborhood data is selected
class NeighborhoodSelector extends StatelessWidget {
  final String? stateAbbr;
  final String? cityName;
  final String? selectedNeighborhood;
  final ValueChanged<String?> onNeighborhoodSelected;

  const NeighborhoodSelector({
    super.key,
    required this.stateAbbr,
    required this.cityName,
    required this.selectedNeighborhood,
    required this.onNeighborhoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Check if city has neighborhoods
    if (stateAbbr == null || 
        cityName == null || 
        !NeighborhoodsDataSource.hasNeighborhoods(stateAbbr!, cityName!)) {
      return const SizedBox.shrink();
    }

    final neighborhoods = NeighborhoodsDataSource.getNeighborhoodsForCity(
      stateAbbr!,
      cityName!,
    );

    if (neighborhoods.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonFormField<String>(
      value: selectedNeighborhood,
      decoration: const InputDecoration(
        labelText: 'Select Neighborhood (Optional)',
        hintText: 'Choose a neighborhood...',
        helperText: 'Get neighborhood-specific rent context',
      ),
      items: neighborhoods.map((neighborhood) {
        return DropdownMenuItem<String>(
          value: neighborhood.name,
          child: Text('${neighborhood.name} (${neighborhood.averageRent.toStringAsFixed(0)}\$/mo)'),
        );
      }).toList(),
      onChanged: onNeighborhoodSelected,
    );
  }
}

