import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/sources/state_mappings.dart';

/// Geolocation service for detecting user's location
class LocationService {
  /// Get current location and determine state
  static Future<String?> getCurrentState() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Reverse geocode to get state
      return await getStateFromLocation(position);
    } catch (e) {
      // Fail silently
      return null;
    }
  }

  /// Get state from coordinates using reverse geocoding
  static Future<String?> getStateFromLocation(Position position) async {
    try {
      final lat = position.latitude;
      final lon = position.longitude;

      // Use OpenStreetMap Nominatim for reverse geocoding
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];

        // Try different possible state fields
        String? stateName = address?['state'] as String? ??
            address?['region'] as String? ??
            address?['state_district'] as String?;

        if (stateName != null) {
          // Try to match to our state mappings
          final abbr = StateMappings.getAbbr(stateName);
          if (abbr != null) {
            return abbr;
          }

          // Try case-insensitive matching
          for (final state in StateMappings.getAllStateNames()) {
            if (state.toLowerCase() == stateName.toLowerCase()) {
              return StateMappings.getAbbr(state);
            }
          }
        }
      }
    } catch (e) {
      // Fail silently
    }
    return null;
  }
}

