import '../models/neighborhood_data.dart';

/// Neighborhood-level rent data for all cities
/// Hierarchical structure: stateAbbr -> cityName -> neighborhoods
class NeighborhoodsDataSource {
  /// Internal data structure: state -> city -> neighborhoods
  static final Map<String, Map<String, List<NeighborhoodData>>> _neighborhoods = {
    'DC': {
      'Washington': [
        NeighborhoodData(
          id: 'georgetown',
          name: 'Georgetown',
          averageRent: 2500.0,
        ),
        NeighborhoodData(
          id: 'dupont-circle',
          name: 'Dupont Circle',
          averageRent: 2300.0,
        ),
        NeighborhoodData(
          id: 'adams-morgan',
          name: 'Adams Morgan',
          averageRent: 2200.0,
        ),
        NeighborhoodData(
          id: 'capitol-hill',
          name: 'Capitol Hill',
          averageRent: 2400.0,
        ),
        NeighborhoodData(
          id: 'columbia-heights',
          name: 'Columbia Heights',
          averageRent: 2000.0,
        ),
        NeighborhoodData(
          id: 'logan-circle',
          name: 'Logan Circle',
          averageRent: 2350.0,
        ),
        NeighborhoodData(
          id: 'shaw',
          name: 'Shaw',
          averageRent: 2150.0,
        ),
        NeighborhoodData(
          id: 'navy-yard',
          name: 'Navy Yard',
          averageRent: 2450.0,
        ),
        NeighborhoodData(
          id: 'noma',
          name: 'NoMa',
          averageRent: 2300.0,
        ),
        NeighborhoodData(
          id: 'h-street',
          name: 'H Street',
          averageRent: 2100.0,
        ),
        NeighborhoodData(
          id: 'brookland',
          name: 'Brookland',
          averageRent: 1900.0,
        ),
        NeighborhoodData(
          id: 'petworth',
          name: 'Petworth',
          averageRent: 1950.0,
        ),
      ],
    },
    'CA': {
      'San Francisco': [
        NeighborhoodData(
          id: 'pacific-heights',
          name: 'Pacific Heights',
          averageRent: 7500.0,
        ),
        NeighborhoodData(
          id: 'russian-hill',
          name: 'Russian Hill',
          averageRent: 6800.0,
        ),
        NeighborhoodData(
          id: 'marina-district',
          name: 'Marina District',
          averageRent: 6500.0,
        ),
        NeighborhoodData(
          id: 'north-beach',
          name: 'North Beach',
          averageRent: 6200.0,
        ),
        NeighborhoodData(
          id: 'financial-district',
          name: 'Financial District',
          averageRent: 5800.0,
        ),
        NeighborhoodData(
          id: 'mission-bay',
          name: 'Mission Bay',
          averageRent: 5500.0,
        ),
        NeighborhoodData(
          id: 'soma',
          name: 'SoMa',
          averageRent: 5200.0,
        ),
        NeighborhoodData(
          id: 'castro',
          name: 'Castro',
          averageRent: 4800.0,
        ),
        NeighborhoodData(
          id: 'haight-ashbury',
          name: 'Haight-Ashbury',
          averageRent: 4500.0,
        ),
        NeighborhoodData(
          id: 'mission-district',
          name: 'Mission District',
          averageRent: 4200.0,
        ),
        NeighborhoodData(
          id: 'sunset-district',
          name: 'Sunset District',
          averageRent: 3800.0,
        ),
        NeighborhoodData(
          id: 'richmond-district',
          name: 'Richmond District',
          averageRent: 3600.0,
        ),
      ],
      'Los Angeles': [
        NeighborhoodData(
          id: 'beverly-hills',
          name: 'Beverly Hills',
          averageRent: 6800.0,
        ),
        NeighborhoodData(
          id: 'santa-monica',
          name: 'Santa Monica',
          averageRent: 6200.0,
        ),
        NeighborhoodData(
          id: 'west-hollywood',
          name: 'West Hollywood',
          averageRent: 5800.0,
        ),
        NeighborhoodData(
          id: 'venice',
          name: 'Venice',
          averageRent: 5500.0,
        ),
        NeighborhoodData(
          id: 'manhattan-beach',
          name: 'Manhattan Beach',
          averageRent: 5200.0,
        ),
        NeighborhoodData(
          id: 'silver-lake',
          name: 'Silver Lake',
          averageRent: 4800.0,
        ),
        NeighborhoodData(
          id: 'los-feliz',
          name: 'Los Feliz',
          averageRent: 4500.0,
        ),
        NeighborhoodData(
          id: 'dtla',
          name: 'DTLA',
          averageRent: 4200.0,
        ),
        NeighborhoodData(
          id: 'hollywood',
          name: 'Hollywood',
          averageRent: 4000.0,
        ),
        NeighborhoodData(
          id: 'echo-park',
          name: 'Echo Park',
          averageRent: 3800.0,
        ),
        NeighborhoodData(
          id: 'koreatown',
          name: 'Koreatown',
          averageRent: 3500.0,
        ),
        NeighborhoodData(
          id: 'culver-city',
          name: 'Culver City',
          averageRent: 3300.0,
        ),
        NeighborhoodData(
          id: 'pasadena',
          name: 'Pasadena',
          averageRent: 3100.0,
        ),
        NeighborhoodData(
          id: 'north-hollywood',
          name: 'North Hollywood',
          averageRent: 2800.0,
        ),
        NeighborhoodData(
          id: 'van-nuys',
          name: 'Van Nuys',
          averageRent: 2500.0,
        ),
      ],
    },
    'NY': {
      'New York City': [
        // Manhattan Premium
        NeighborhoodData(
          id: 'upper-east-side',
          name: 'Upper East Side',
          averageRent: 5200.0,
        ),
        NeighborhoodData(
          id: 'upper-west-side',
          name: 'Upper West Side',
          averageRent: 5000.0,
        ),
        NeighborhoodData(
          id: 'west-village',
          name: 'West Village',
          averageRent: 4800.0,
        ),
        NeighborhoodData(
          id: 'east-village',
          name: 'East Village',
          averageRent: 4500.0,
        ),
        NeighborhoodData(
          id: 'soho',
          name: 'SoHo',
          averageRent: 5500.0,
        ),
        NeighborhoodData(
          id: 'tribeca',
          name: 'Tribeca',
          averageRent: 6000.0,
        ),
        NeighborhoodData(
          id: 'chelsea',
          name: 'Chelsea',
          averageRent: 4700.0,
        ),
        NeighborhoodData(
          id: 'gramercy',
          name: 'Gramercy',
          averageRent: 4400.0,
        ),
        NeighborhoodData(
          id: 'lower-east-side',
          name: 'Lower East Side',
          averageRent: 4200.0,
        ),
        // Brooklyn
        NeighborhoodData(
          id: 'williamsburg',
          name: 'Williamsburg',
          averageRent: 4000.0,
        ),
        NeighborhoodData(
          id: 'park-slope',
          name: 'Park Slope',
          averageRent: 3800.0,
        ),
        NeighborhoodData(
          id: 'dumbo',
          name: 'DUMBO',
          averageRent: 4500.0,
        ),
        NeighborhoodData(
          id: 'brooklyn-heights',
          name: 'Brooklyn Heights',
          averageRent: 4300.0,
        ),
        NeighborhoodData(
          id: 'bushwick',
          name: 'Bushwick',
          averageRent: 3200.0,
        ),
        NeighborhoodData(
          id: 'crown-heights',
          name: 'Crown Heights',
          averageRent: 2800.0,
        ),
        // Queens
        NeighborhoodData(
          id: 'astoria',
          name: 'Astoria',
          averageRent: 3000.0,
        ),
        NeighborhoodData(
          id: 'long-island-city',
          name: 'Long Island City',
          averageRent: 3500.0,
        ),
        NeighborhoodData(
          id: 'flushing',
          name: 'Flushing',
          averageRent: 2200.0,
        ),
        // Bronx
        NeighborhoodData(
          id: 'yankee-stadium-area',
          name: 'Yankee Stadium Area',
          averageRent: 2000.0,
        ),
        // Staten Island
        NeighborhoodData(
          id: 'staten-island',
          name: 'Staten Island',
          averageRent: 1800.0,
        ),
      ],
    },
    'IL': {
      'Chicago': [
        NeighborhoodData(
          id: 'loop',
          name: 'The Loop',
          averageRent: 2800.0,
        ),
        NeighborhoodData(
          id: 'river-north',
          name: 'River North',
          averageRent: 2600.0,
        ),
        NeighborhoodData(
          id: 'lincoln-park',
          name: 'Lincoln Park',
          averageRent: 2400.0,
        ),
        NeighborhoodData(
          id: 'wicker-park',
          name: 'Wicker Park',
          averageRent: 2300.0,
        ),
        NeighborhoodData(
          id: 'lakeview',
          name: 'Lakeview',
          averageRent: 2200.0,
        ),
        NeighborhoodData(
          id: 'logan-square',
          name: 'Logan Square',
          averageRent: 2000.0,
        ),
        NeighborhoodData(
          id: 'pilsen',
          name: 'Pilsen',
          averageRent: 1800.0,
        ),
        NeighborhoodData(
          id: 'hyde-park',
          name: 'Hyde Park',
          averageRent: 1700.0,
        ),
        NeighborhoodData(
          id: 'uptown',
          name: 'Uptown',
          averageRent: 1600.0,
        ),
        NeighborhoodData(
          id: 'south-loop',
          name: 'South Loop',
          averageRent: 2500.0,
        ),
      ],
    },
    'MA': {
      'Boston': [
        NeighborhoodData(
          id: 'back-bay',
          name: 'Back Bay',
          averageRent: 4500.0,
        ),
        NeighborhoodData(
          id: 'beacon-hill',
          name: 'Beacon Hill',
          averageRent: 4200.0,
        ),
        NeighborhoodData(
          id: 'south-end',
          name: 'South End',
          averageRent: 4000.0,
        ),
        NeighborhoodData(
          id: 'cambridge',
          name: 'Cambridge',
          averageRent: 3800.0,
        ),
        NeighborhoodData(
          id: 'somerville',
          name: 'Somerville',
          averageRent: 3200.0,
        ),
        NeighborhoodData(
          id: 'fenway',
          name: 'Fenway',
          averageRent: 3500.0,
        ),
        NeighborhoodData(
          id: 'allston',
          name: 'Allston',
          averageRent: 2800.0,
        ),
        NeighborhoodData(
          id: 'jamaica-plain',
          name: 'Jamaica Plain',
          averageRent: 3000.0,
        ),
        NeighborhoodData(
          id: 'north-end',
          name: 'North End',
          averageRent: 3900.0,
        ),
      ],
    },
    'PA': {
      'Philadelphia': [
        NeighborhoodData(
          id: 'center-city',
          name: 'Center City',
          averageRent: 2400.0,
        ),
        NeighborhoodData(
          id: 'university-city',
          name: 'University City',
          averageRent: 2200.0,
        ),
        NeighborhoodData(
          id: 'fishtown',
          name: 'Fishtown',
          averageRent: 2000.0,
        ),
        NeighborhoodData(
          id: 'northern-liberties',
          name: 'Northern Liberties',
          averageRent: 2100.0,
        ),
        NeighborhoodData(
          id: 'queen-village',
          name: 'Queen Village',
          averageRent: 2300.0,
        ),
        NeighborhoodData(
          id: 'fairmount',
          name: 'Fairmount',
          averageRent: 1900.0,
        ),
        NeighborhoodData(
          id: 'manayunk',
          name: 'Manayunk',
          averageRent: 1800.0,
        ),
        NeighborhoodData(
          id: 'south-philly',
          name: 'South Philly',
          averageRent: 1700.0,
        ),
      ],
    },
    // Additional cities will be added in Phase 2
  };

  /// Check if a city has neighborhood data available
  static bool hasNeighborhoods(String stateAbbr, String cityName) {
    final stateData = _neighborhoods[stateAbbr.toUpperCase()];
    if (stateData == null) return false;
    
    // Case-insensitive city name matching
    final cityKey = stateData.keys.firstWhere(
      (key) => key.toLowerCase() == cityName.toLowerCase(),
      orElse: () => '',
    );
    
    return cityKey.isNotEmpty && stateData[cityKey] != null;
  }

  /// Get neighborhoods for a specific city
  /// Returns empty list if city doesn't have neighborhoods
  static List<NeighborhoodData> getNeighborhoodsForCity(
    String stateAbbr,
    String cityName,
  ) {
    final stateData = _neighborhoods[stateAbbr.toUpperCase()];
    if (stateData == null) return [];

    // Case-insensitive city name matching
    final cityKey = stateData.keys.firstWhere(
      (key) => key.toLowerCase() == cityName.toLowerCase(),
      orElse: () => '',
    );

    if (cityKey.isEmpty) return [];
    
    return stateData[cityKey] ?? [];
  }

  /// Get a specific neighborhood by name
  /// Returns null if not found
  static NeighborhoodData? getNeighborhoodByName(
    String stateAbbr,
    String cityName,
    String neighborhoodName,
  ) {
    final neighborhoods = getNeighborhoodsForCity(stateAbbr, cityName);
    if (neighborhoods.isEmpty) return null;
    
    return NeighborhoodData.getNeighborhoodByName(neighborhoodName, neighborhoods);
  }

  /// Get all neighborhoods for a state (all cities combined)
  /// Useful for debugging or analytics
  static List<NeighborhoodData> getAllNeighborhoodsForState(String stateAbbr) {
    final stateData = _neighborhoods[stateAbbr.toUpperCase()];
    if (stateData == null) return [];

    final List<NeighborhoodData> allNeighborhoods = [];
    for (final cityNeighborhoods in stateData.values) {
      allNeighborhoods.addAll(cityNeighborhoods);
    }
    
    return allNeighborhoods;
  }

  /// Get list of all states that have neighborhood data
  static List<String> getStatesWithNeighborhoods() {
    return _neighborhoods.keys.toList()..sort();
  }

  /// Get list of all cities with neighborhood data for a state
  static List<String> getCitiesWithNeighborhoods(String stateAbbr) {
    final stateData = _neighborhoods[stateAbbr.toUpperCase()];
    if (stateData == null) return [];
    
    return stateData.keys.toList()..sort();
  }
}

