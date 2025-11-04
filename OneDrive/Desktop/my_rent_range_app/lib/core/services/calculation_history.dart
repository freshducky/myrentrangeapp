import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/calculation_result.dart';

/// Service for saving and loading calculation history
class CalculationHistory {
  static const int _maxHistoryItems = 50;

  /// Save a calculation result to history
  static Future<void> saveCalculation(CalculationResult result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing history
      final history = await getHistory();
      
      // Add new result at the beginning
      history.insert(0, result);
      
      // Limit history size
      if (history.length > _maxHistoryItems) {
        history.removeRange(_maxHistoryItems, history.length);
      }
      
      // Save as JSON
      final historyJson = history.map((r) => _resultToJson(r)).toList();
      await prefs.setString('calculation_history', jsonEncode(historyJson));
    } catch (e) {
      // Fail silently
    }
  }

  /// Get calculation history
  static Future<List<CalculationResult>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('calculation_history');
      
      if (historyJson == null) {
        return [];
      }
      
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.map((json) => _resultFromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear all history
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('calculation_history');
    } catch (e) {
      // Fail silently
    }
  }

  /// Convert CalculationResult to JSON
  static Map<String, dynamic> _resultToJson(CalculationResult result) {
    return {
      'netMonthlyIncome': result.netMonthlyIncome,
      'affordableRent': {
        'conservative': result.affordableRent.conservative,
        'balanced': result.affordableRent.balanced,
        'stretch': result.affordableRent.stretch,
      },
      'burdenLevel': result.burdenLevel.name,
      'burdenPercentage': result.burdenPercentage,
      'insights': result.insights,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Convert JSON to CalculationResult
  static CalculationResult _resultFromJson(Map<String, dynamic> json) {
    return CalculationResult(
      netMonthlyIncome: json['netMonthlyIncome'] as double,
      affordableRent: RentRange(
        conservative: json['affordableRent']['conservative'] as double,
        balanced: json['affordableRent']['balanced'] as double,
        stretch: json['affordableRent']['stretch'] as double,
      ),
      burdenLevel: RentBurdenLevel.values.firstWhere(
        (level) => level.name == json['burdenLevel'],
        orElse: () => RentBurdenLevel.safe,
      ),
      burdenPercentage: json['burdenPercentage'] as double,
      insights: json['insights'] as String,
    );
  }
}

