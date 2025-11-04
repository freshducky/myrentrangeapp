import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/services/calculation_history.dart';
import '../../data/models/calculation_result.dart';
import '../../data/models/bedroom_config.dart';
import '../widgets/history_item.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<_HistoryEntry> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('calculation_history');
      
      if (historyJson == null) {
        setState(() {
          _history = [];
          _isLoading = false;
        });
        return;
      }

      final List<dynamic> decoded = jsonDecode(historyJson);
      final List<_HistoryEntry> entries = [];

      for (var item in decoded) {
        try {
          final timestampStr = item['timestamp'] as String?;
          DateTime timestamp;
          if (timestampStr != null) {
            timestamp = DateTime.parse(timestampStr);
          } else {
            timestamp = DateTime.now();
          }

          final result = _resultFromJsonStatic(
            item as Map<String, dynamic>,
          );

          entries.add(_HistoryEntry(
            result: result,
            timestamp: timestamp,
          ));
        } catch (e) {
          // Skip invalid entries
          continue;
        }
      }

      // Sort by timestamp, newest first
      entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        _history = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _history = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEntry(_HistoryEntry entry) async {
    final history = await CalculationHistory.getHistory();
    // Remove the entry by matching timestamp
    history.removeWhere((result) {
      // Since we can't directly match CalculationResult, we'll need to rebuild
      // the history list. For now, we'll reload all history.
      return false;
    });

    // Rebuild history without the deleted entry
    final List<Map<String, dynamic>> historyJson = [];
    for (var item in _history) {
      if (item != entry) {
        historyJson.add(_resultToJsonStatic(item.result));
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('calculation_history', jsonEncode(historyJson));
      await _loadHistory();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Calculation deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete')),
        );
      }
    }
  }

  Future<void> _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
          'Are you sure you want to delete all calculation history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentRed,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await CalculationHistory.clearHistory();
      await _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All history cleared')),
        );
      }
    }
  }

  void _loadCalculation(_HistoryEntry entry) {
    // Navigate back to home and pass the calculation data
    // For now, we'll just navigate back
    // In a full implementation, we'd pass this data back to HomeScreen
    Navigator.pop(context, entry.result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllHistory,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _EmptyState()
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final entry = _history[index];
                      return HistoryItem(
                        result: entry.result,
                        timestamp: entry.timestamp,
                        onTap: () => _loadCalculation(entry),
                        onDelete: () => _deleteEntry(entry),
                      );
                    },
                  ),
                ),
    );
  }

  static Map<String, dynamic> _resultToJsonStatic(CalculationResult result) {
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
      'selectedBedroom': result.selectedBedroom.index,
      'selectedNeighborhood': result.selectedNeighborhood,
      'neighborhoodAverageRent': result.neighborhoodAverageRent,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  static CalculationResult _resultFromJsonStatic(Map<String, dynamic> json) {
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
      selectedBedroom: BedroomConfiguration.values[
        (json['selectedBedroom'] as int?) ?? BedroomConfiguration.oneBedroom.index
      ],
      selectedNeighborhood: json['selectedNeighborhood'] as String?,
      neighborhoodAverageRent: (json['neighborhoodAverageRent'] as num?)?.toDouble(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Calculation History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your recent calculations will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }
}

class _HistoryEntry {
  final CalculationResult result;
  final DateTime timestamp;

  _HistoryEntry({
    required this.result,
    required this.timestamp,
  });
}

