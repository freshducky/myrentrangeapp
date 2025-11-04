import '../models/city_data.dart';
import 'city_data.dart';
import 'zillow_data_loader.dart';

/// Enriches city data with Zillow data when available
class CityDataEnricher {
  static Map<String, ZillowCityData>? _zillowData;

  /// Initialize Zillow data (call on app startup)
  static Future<void> initialize() async {
    _zillowData = await ZillowDataLoader.loadZillowData();
  }

  /// Get all cities with Zillow data enrichment
  static List<CityData> getAllCitiesEnriched() {
    final baseCities = CityDataSource.getAllCities();
    
    // If Zillow data not loaded yet, return base cities
    if (_zillowData == null) {
      return baseCities;
    }

    // Enrich cities with Zillow data where available
    return baseCities.map((city) {
      final zillowData = _zillowData![city.name];
      
      if (zillowData != null) {
        // Use Zillow rent estimate, keep other fields from base
        return CityData(
          id: city.id,
          name: city.name,
          state: city.state,
          fullName: city.fullName,
          medianRent: zillowData.rentEstimate,
          medianIncome: city.medianIncome,
          isSpecialCase: city.isSpecialCase,
          dataSource: 'Zillow',
          lastUpdated: zillowData.lastUpdatedDate,
          rentTrend: zillowData.rentTrend,
        );
      }
      
      // No Zillow data, return base city with estimated source
      return CityData(
        id: city.id,
        name: city.name,
        state: city.state,
        fullName: city.fullName,
        medianRent: city.medianRent,
        medianIncome: city.medianIncome,
        isSpecialCase: city.isSpecialCase,
        dataSource: 'Estimated',
        lastUpdated: null,
        rentTrend: null,
      );
    }).toList();
  }

  /// Get enriched city data for a specific city
  static CityData? getCityEnriched(String cityName) {
    final allCities = getAllCitiesEnriched();
    try {
      return allCities.firstWhere((city) => city.name == cityName);
    } catch (e) {
      return null;
    }
  }

  /// Check if city has Zillow data
  static bool hasZillowData(String cityName) {
    return _zillowData?.containsKey(cityName) ?? false;
  }
}

