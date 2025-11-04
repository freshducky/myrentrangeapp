import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/city_data.dart';

/// Zillow city data structure
class ZillowCityData {
    final String regionName;
    final String state;
    final double homeValue;
    final double rentEstimate;
    final String trend;
    final String lastUpdated;

    ZillowCityData({
      required this.regionName,
      required this.state,
      required this.homeValue,
      required this.rentEstimate,
      required this.trend,
      required this.lastUpdated,
    });

    factory ZillowCityData.fromJson(Map<String, dynamic> json) {
      return ZillowCityData(
        regionName: json['region_name'] as String,
        state: json['state'] as String,
        homeValue: (json['home_value'] as num).toDouble(),
        rentEstimate: (json['rent_estimate'] as num).toDouble(),
        trend: json['trend'] as String,
        lastUpdated: json['last_updated'] as String,
      );
    }

    RentTrend? get rentTrend {
      switch (trend.toLowerCase()) {
        case 'up':
          return RentTrend.up;
        case 'down':
          return RentTrend.down;
        case 'stable':
        default:
          return RentTrend.stable;
      }
    }

    DateTime? get lastUpdatedDate {
      try {
        final parts = lastUpdated.split('-');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      } catch (e) {
        // Invalid date format
      }
      return null;
    }
}

/// Zillow data loader - loads verified rent data from Zillow dataset
class ZillowDataLoader {
  static Map<String, ZillowCityData>? _cachedData;

  /// Load Zillow data from JSON asset
  static Future<Map<String, ZillowCityData>> loadZillowData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'lib/data/sources/zillow_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _cachedData = {};
      jsonData.forEach((cityName, data) {
        _cachedData![cityName] = ZillowCityData.fromJson(data as Map<String, dynamic>);
      });

      return _cachedData!;
    } catch (e) {
      // If file doesn't exist or can't be loaded, return empty map
      // Silently fail - app will use estimated data
      _cachedData = {};
      return _cachedData!;
    }
  }

  /// Get Zillow data for a specific city
  static Future<ZillowCityData?> getCityData(String cityName) async {
    final data = await loadZillowData();
    return data[cityName];
  }

  /// Check if city has Zillow data
  static Future<bool> hasZillowData(String cityName) async {
    final data = await loadZillowData();
    return data.containsKey(cityName);
  }

  /// Get all cities with Zillow data
  static Future<List<String>> getCitiesWithZillowData() async {
    final data = await loadZillowData();
    return data.keys.toList();
  }
}

