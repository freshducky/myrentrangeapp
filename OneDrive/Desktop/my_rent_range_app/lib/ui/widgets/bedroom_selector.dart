import 'package:flutter/material.dart';
import '../../data/models/bedroom_config.dart';

/// Bedroom configuration selector dropdown
class BedroomSelector extends StatelessWidget {
  final BedroomConfiguration selectedBedroom;
  final ValueChanged<BedroomConfiguration> onBedroomSelected;

  const BedroomSelector({
    super.key,
    required this.selectedBedroom,
    required this.onBedroomSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<BedroomConfiguration>(
      value: selectedBedroom,
      decoration: const InputDecoration(
        labelText: 'Bedroom Size',
        hintText: 'Select bedroom configuration...',
        helperText: 'Adjusts rent ranges and neighborhood comparisons',
      ),
      items: BedroomConfiguration.values.map((bedroom) {
        String multiplierText = '';
        if (bedroom == BedroomConfiguration.oneBedroom) {
          multiplierText = ' (baseline)';
        } else {
          multiplierText = ' (${bedroom.multiplier}x)';
        }
        
        return DropdownMenuItem<BedroomConfiguration>(
          value: bedroom,
          child: Text('${bedroom.displayName}$multiplierText'),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onBedroomSelected(value);
        }
      },
    );
  }
}

