/// City-level economic data
class CityData {
  final String id;
  final String name;
  final String state;
  final String fullName;
  final double medianRent;
  final double medianIncome;
  final bool isSpecialCase;

  CityData({
    required this.id,
    required this.name,
    required this.state,
    required this.fullName,
    required this.medianRent,
    required this.medianIncome,
    this.isSpecialCase = false,
  });

  /// Get city by full name (e.g., "Washington, DC")
  static CityData? getCityByFullName(String fullName, List<CityData> cities) {
    try {
      return cities.firstWhere(
        (city) => city.fullName == fullName,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get cities by state abbreviation
  static List<CityData> getCitiesByState(String stateAbbr, List<CityData> cities) {
    return cities.where((city) => city.state == stateAbbr.toUpperCase()).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}

