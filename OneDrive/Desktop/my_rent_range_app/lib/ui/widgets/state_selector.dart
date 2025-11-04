import 'package:flutter/material.dart';
import '../../data/sources/state_mappings.dart';

/// State selector dropdown
/// Ported from StateSelector component
class StateSelector extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const StateSelector({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final states = StateMappings.getAllStateNames();
    
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: const InputDecoration(
        labelText: 'Select State',
        hintText: 'Choose a state...',
      ),
      items: states.map((stateName) {
        final abbr = StateMappings.getAbbr(stateName);
        return DropdownMenuItem<String>(
          value: abbr,
          child: Text('$stateName ($abbr)'),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

