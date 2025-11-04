import 'package:flutter/material.dart';
import '../widgets/salary_input.dart';
import '../widgets/state_selector.dart';
import '../widgets/city_selector.dart';
import '../widgets/neighborhood_selector.dart';
import '../widgets/option_toggles.dart';
import '../widgets/rent_range_output.dart';
import '../../core/calculations/rent_calculator.dart';
import '../../data/models/calculation_result.dart';
import '../../data/models/bedroom_config.dart';
import '../../data/sources/neighborhoods_data.dart';
import '../../core/services/calculation_history.dart';
import '../widgets/bedroom_selector.dart';
import '../widgets/ad_banner.dart';
import '../theme/app_theme.dart';

/// Main home screen - calculator interface
/// Ported from src/pages/index.tsx
class HomeScreen extends StatefulWidget {
  final Function(ThemeMode, bool)? onThemeChanged;

  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Input state
  double _salary = 60000;
  IncomeType _salaryType = IncomeType.annual;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedNeighborhood;
  BedroomConfiguration _selectedBedroom = BedroomConfiguration.oneBedroom;
  bool _ownsCar = false;
  bool _livingAlone = false;

  // Calculation result
  CalculationResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    if (_selectedState == null || _selectedState!.isEmpty) {
      setState(() {
        _result = null;
      });
      return;
    }

    // Pass neighborhood if city has neighborhood support
    String? neighborhoodName;
    if (_selectedCity != null && 
        _selectedNeighborhood != null &&
        NeighborhoodsDataSource.hasNeighborhoods(_selectedState!, _selectedCity!)) {
      neighborhoodName = _selectedNeighborhood;
    }

    final result = RentCalculator.calculate(
      grossIncome: _salary,
      incomeType: _salaryType,
      stateAbbr: _selectedState!,
      ownsCar: _ownsCar,
      hasRoommates: !_livingAlone,
      bedroom: _selectedBedroom,
      cityName: _selectedCity,
      neighborhoodName: neighborhoodName,
    );

    setState(() {
      _result = result;
    });

    // Save to history
    CalculationHistory.saveCalculation(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'My',
              style: TextStyle(color: AppTheme.accentRed),
            ),
            Text(
              'RentRange',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
            tooltip: 'Calculation History',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Header
            Text(
              'What is MyRentRange?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'MyRentRange is your free rent range calculator, designed to help '
              'you understand how much rent you can afford based on your real '
              'take-home pay and local data.',
            ),
            const SizedBox(height: 32),

            // Input form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Where You Live',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    StateSelector(
                      selectedValue: _selectedState,
                      onChanged: (value) {
                        setState(() {
                          _selectedState = value;
                          _selectedCity = null; // Reset city when state changes
                          _selectedNeighborhood = null; // Reset neighborhood when state changes
                        });
                        _calculate();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_selectedState != null)
                      CitySelector(
                        stateAbbr: _selectedState,
                        selectedCity: _selectedCity,
                        onCitySelected: (city) {
                          setState(() {
                            _selectedCity = city;
                            // Reset neighborhood when city changes away from DC
                            if (_selectedState != 'DC' || city != 'Washington') {
                              _selectedNeighborhood = null;
                            }
                          });
                          _calculate();
                        },
                      ),
                    // Show neighborhood selector if city has neighborhoods
                    if (_selectedState != null && 
                        _selectedCity != null &&
                        NeighborhoodsDataSource.hasNeighborhoods(_selectedState!, _selectedCity!)) ...[
                      const SizedBox(height: 16),
                      NeighborhoodSelector(
                        stateAbbr: _selectedState,
                        cityName: _selectedCity,
                        selectedNeighborhood: _selectedNeighborhood,
                        onNeighborhoodSelected: (neighborhood) {
                          setState(() {
                            _selectedNeighborhood = neighborhood;
                          });
                          _calculate();
                        },
                      ),
                    ],
                    // Bedroom selector
                    const SizedBox(height: 16),
                    BedroomSelector(
                      selectedBedroom: _selectedBedroom,
                      onBedroomSelected: (bedroom) {
                        setState(() {
                          _selectedBedroom = bedroom;
                        });
                        _calculate();
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Salary input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gross Salary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    SalaryInput(
                      value: _salary,
                      onChanged: (value) {
                        setState(() {
                          _salary = value;
                        });
                        _calculate();
                      },
                      type: _salaryType,
                      onTypeChanged: (type) {
                        setState(() {
                          _salaryType = type;
                        });
                        _calculate();
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Options
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Options',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    OptionToggles(
                      ownsCar: _ownsCar,
                      onOwnsCarChanged: (value) {
                        setState(() {
                          _ownsCar = value;
                        });
                        _calculate();
                      },
                      livingAlone: _livingAlone,
                      onLivingAloneChanged: (value) {
                        setState(() {
                          _livingAlone = value;
                        });
                        _calculate();
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

                // Rent range output
                if (_result != null)
                  RentRangeOutput(
                    rentRange: _result!.affordableRent,
                    netMonthlyIncome: _result!.netMonthlyIncome,
                    grossIncome: _salary,
                    incomeType: _salaryType,
                    stateAbbr: _selectedState!,
                    hasRoommates: !_livingAlone,
                    bedroom: _result!.selectedBedroom,
                    neighborhoodName: _result!.selectedNeighborhood,
                    neighborhoodAverageRent: _result!.neighborhoodAverageRent,
                  ),
                ],
              ),
            ),
          ),
          // Banner ad at bottom (iOS only, hides when removed)
          const AdBanner(),
        ],
      ),
    );
  }
}

