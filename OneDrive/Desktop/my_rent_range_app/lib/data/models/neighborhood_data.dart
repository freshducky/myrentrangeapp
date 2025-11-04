/// Neighborhood-level rent data
class NeighborhoodData {
  final String id;
  final String name;
  final double averageRent; // Average 1-bedroom rent
  final double? walkabilityScore; // Optional: for future enhancement

  NeighborhoodData({
    required this.id,
    required this.name,
    required this.averageRent,
    this.walkabilityScore,
  });

  /// Get neighborhood by name
  static NeighborhoodData? getNeighborhoodByName(
    String name,
    List<NeighborhoodData> neighborhoods,
  ) {
    try {
      return neighborhoods.firstWhere(
        (neighborhood) => neighborhood.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get neighborhoods by city (for future expansion to other cities)
  static List<NeighborhoodData> getNeighborhoodsByCity(
    String cityName,
    List<NeighborhoodData> neighborhoods,
  ) {
    // For now, all neighborhoods are DC-specific
    // This method is prepared for future city expansion
    return neighborhoods;
  }
}

