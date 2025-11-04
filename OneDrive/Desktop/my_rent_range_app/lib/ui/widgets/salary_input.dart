import 'package:flutter/material.dart';
import '../../core/calculations/rent_calculator.dart';
import '../theme/app_theme.dart';

/// Salary input widget with type toggle (hourly/monthly/annual)
/// Ported from SalaryInput.tsx
class SalaryInput extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final IncomeType type;
  final ValueChanged<IncomeType> onTypeChanged;

  const SalaryInput({
    super.key,
    required this.value,
    required this.onChanged,
    required this.type,
    required this.onTypeChanged,
  });

  @override
  State<SalaryInput> createState() => _SalaryInputState();
}

class _SalaryInputState extends State<SalaryInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value.toStringAsFixed(0);
  }

  @override
  void didUpdateWidget(SalaryInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type selector buttons
        Row(
          children: [
            _TypeButton(
              label: 'Hourly',
              isSelected: widget.type == IncomeType.hourly,
              onTap: () => widget.onTypeChanged(IncomeType.hourly),
            ),
            const SizedBox(width: 8),
            _TypeButton(
              label: 'Monthly',
              isSelected: widget.type == IncomeType.monthly,
              onTap: () => widget.onTypeChanged(IncomeType.monthly),
            ),
            const SizedBox(width: 8),
            _TypeButton(
              label: 'Annual',
              isSelected: widget.type == IncomeType.annual,
              onTap: () => widget.onTypeChanged(IncomeType.annual),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Input field
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter ${_getTypeLabel(widget.type)} gross salary',
            prefixText: '\$ ',
          ),
          onChanged: (value) {
            final parsed = double.tryParse(value) ?? 0;
            widget.onChanged(parsed);
          },
        ),
      ],
    );
  }

  String _getTypeLabel(IncomeType type) {
    switch (type) {
      case IncomeType.hourly:
        return 'hourly';
      case IncomeType.monthly:
        return 'monthly';
      case IncomeType.annual:
        return 'annual';
    }
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentRed : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

