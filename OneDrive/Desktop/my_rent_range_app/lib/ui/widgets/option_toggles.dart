import 'package:flutter/material.dart';

/// Option toggles for car ownership and living situation
/// Ported from OptionToggles component
class OptionToggles extends StatelessWidget {
  final bool ownsCar;
  final ValueChanged<bool> onOwnsCarChanged;
  final bool livingAlone;
  final ValueChanged<bool> onLivingAloneChanged;

  const OptionToggles({
    super.key,
    required this.ownsCar,
    required this.onOwnsCarChanged,
    required this.livingAlone,
    required this.onLivingAloneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Own a car?'),
          subtitle: const Text('Subtracts \$500/month from net income'),
          value: ownsCar,
          onChanged: onOwnsCarChanged,
        ),
        SwitchListTile(
          title: const Text('Living alone?'),
          subtitle: const Text('Tightens rent cap to 25% max'),
          value: livingAlone,
          onChanged: onLivingAloneChanged,
        ),
      ],
    );
  }
}

