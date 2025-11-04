import 'package:flutter/material.dart';
import '../../data/models/city_data.dart';
import '../../data/sources/city_data.dart';

/// City selector dropdown
/// Ported from CitySelector component
class CitySelector extends StatelessWidget {
  final String? stateAbbr;
  final String? selectedCity;
  final ValueChanged<String?> onCitySelected;

  const CitySelector({
    super.key,
    required this.stateAbbr,
    required this.selectedCity,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (stateAbbr == null || stateAbbr!.isEmpty) {
      return const SizedBox.shrink();
    }

    final allCities = CityDataSource.getAllCities();
    final citiesInState = CityData.getCitiesByState(stateAbbr!, allCities);

    if (citiesInState.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'No cities available for $stateAbbr',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      value: selectedCity,
      decoration: const InputDecoration(
        labelText: 'Select City',
        hintText: 'Choose a city...',
      ),
      items: citiesInState.map((city) {
        return DropdownMenuItem<String>(
          value: city.name,
          child: Text(city.name),
        );
      }).toList(),
      onChanged: onCitySelected,
    );
  }
}

