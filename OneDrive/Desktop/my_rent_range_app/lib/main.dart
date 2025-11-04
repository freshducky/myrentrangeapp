import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/history_screen.dart';
import 'ui/theme/app_theme.dart';
import 'data/sources/city_data_enricher.dart';
import 'core/services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Zillow data on app startup
  await CityDataEnricher.initialize();
  
  // Initialize Google Mobile Ads (with error handling)
  try {
    await AdService.initialize();
  } catch (e) {
    // Continue without ads if initialization fails
    debugPrint('AdService initialization failed: $e');
  }
  
  runApp(const MyRentRangeApp());
}

class MyRentRangeApp extends StatefulWidget {
  const MyRentRangeApp({super.key});

  @override
  State<MyRentRangeApp> createState() => _MyRentRangeAppState();
}

class _MyRentRangeAppState extends State<MyRentRangeApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isWarmTheme = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString('theme_mode') ?? 'light';
      final isWarm = prefs.getBool('is_warm_theme') ?? false;

      setState(() {
        _isWarmTheme = isWarm;
        switch (themeModeString) {
          case 'warm':
            _themeMode = ThemeMode.light;
            _isWarmTheme = true;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            _isWarmTheme = false;
            break;
          case 'system':
            _themeMode = ThemeMode.system;
            break;
          case 'light':
          default:
            _themeMode = ThemeMode.light;
            _isWarmTheme = false;
            break;
        }
      });
    } catch (e) {
      // Default to light theme if loading fails
    }
  }

  void _updateTheme(ThemeMode mode, bool isWarm) async {
    setState(() {
      _themeMode = mode;
      _isWarmTheme = isWarm;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String themeModeString;
      if (mode == ThemeMode.system) {
        themeModeString = 'system';
      } else if (isWarm && mode == ThemeMode.light) {
        themeModeString = 'warm';
      } else if (mode == ThemeMode.dark) {
        themeModeString = 'dark';
      } else {
        themeModeString = 'light';
      }
      await prefs.setString('theme_mode', themeModeString);
      await prefs.setBool('is_warm_theme', isWarm);
    } catch (e) {
      // Fail silently
    }
  }

  ThemeData _getLightTheme() {
    return _isWarmTheme ? AppTheme.warmLightTheme : AppTheme.lightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyRentRange',
      theme: _getLightTheme(),
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(
        onThemeChanged: _updateTheme,
      ),
      routes: {
        '/settings': (context) => SettingsScreen(
              currentThemeMode: _themeMode,
              isWarmTheme: _isWarmTheme,
              onThemeChanged: _updateTheme,
            ),
        '/history': (context) => const HistoryScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
