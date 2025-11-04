/// State-level economic and demographic data
class StateData {
  final String abbreviation;
  final String name;
  final double medianSalary;
  final double avgSalary;
  final double medianRent;
  final double avgRentTopCity;
  final String topCity;
  final String stateTax;

  StateData({
    required this.abbreviation,
    required this.name,
    required this.medianSalary,
    required this.avgSalary,
    required this.medianRent,
    required this.avgRentTopCity,
    required this.topCity,
    required this.stateTax,
  });
}

