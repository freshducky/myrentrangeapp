import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'models/settings_model.dart';
import 'utils/number_formatter.dart';
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WarmLightCalculatorApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // Warm cream background
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Circular loading indicator around the logo
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF8B4513).withOpacity(0.8 * _pulseAnimation.value),
                    ),
                    strokeWidth: 4,
                  ),
                ),
                // Circular logo with pulse animation
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B4513).withOpacity(0.3 * _pulseAnimation.value),
                          blurRadius: 20 * _pulseAnimation.value,
                          spreadRadius: 5 * _pulseAnimation.value,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF8B4513),
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/freshducky.jpg',
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 180,
                              height: 180,
                              color: const Color(0xFF8B4513),
                              child: const Icon(
                                Icons.calculate,
                                size: 100,
                                color: Color(0xFFF5E6D3),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WarmLightCalculatorApp extends StatefulWidget {
  const WarmLightCalculatorApp({super.key});

  @override
  State<WarmLightCalculatorApp> createState() => _WarmLightCalculatorAppState();
}

class _WarmLightCalculatorAppState extends State<WarmLightCalculatorApp> {
  final AppSettings _settings = AppSettings();
  bool _settingsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settings.loadSettings();
    // Add a small delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _settingsLoaded = true;
      });
    }
  }

  ThemeData _getTheme() {
    // High contrast takes priority
    if (_settings.highContrast) {
      if (_settings.highContrastMode == 'dark') {
        // High contrast dark mode - black background, warm yellow/cream text
        return ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: const Color(0xFFFFEAA7), // Warm yellow
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFEAA7),
            surface: Colors.black,
            background: Colors.black,
            onPrimary: Colors.black,
            onSurface: Color(0xFFFFEAA7),
            onBackground: Color(0xFFFFEAA7),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: Color(0xFFFFEAA7),
            ),
            displayMedium: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: Color(0xFFFFEAA7),
            ),
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFEAA7),
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFFFFEAA7),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Color(0xFFFFEAA7),
            elevation: 0,
            centerTitle: true,
          ),
        );
      } else {
        // High contrast light mode - white background, black text
        return ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.black,
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            surface: Colors.white,
            background: Colors.white,
            onPrimary: Colors.white,
            onSurface: Colors.black,
            onBackground: Colors.black,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
            displayMedium: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
        );
      }
    } else if (_settings.darkMode) {
      // Regular dark mode - warm dark theme
      return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: MaterialColor(
          0xFF8B4513,
          <int, Color>{
            50: const Color(0xFF3D1F08),
            100: const Color(0xFF52290B),
            200: const Color(0xFF66330E),
            300: const Color(0xFF7A3D11),
            400: const Color(0xFF8B4513),
            500: const Color(0xFFBF5F1A),
            600: const Color(0xFFCA7C3A),
            700: const Color(0xFFD9A06D),
            800: const Color(0xFFE8C4A0),
            900: const Color(0xFFF5E6D3),
          },
        ),
        scaffoldBackgroundColor: const Color(0xFF2D1810),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF52290B),
          foregroundColor: Color(0xFFD9A06D),
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            color: Color(0xFFCA7C3A), // Darker warm color for better contrast in dark mode
          ),
          displayMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: Color(0xFFCA7C3A),
          ),
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFFCA7C3A),
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color(0xFFCA7C3A),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B4513),
          secondary: Color(0xFFCA7C3A),
          surface: Color(0xFF3D1F08),
          background: Color(0xFF2D1810),
          onPrimary: Color(0xFFD9A06D),
          onSecondary: Color(0xFF2D1810),
          onSurface: Color(0xFFD9A06D),
          onBackground: Color(0xFFD9A06D),
        ),
      );
    } else {
      // Warm light theme (default)
      return ThemeData(
        primarySwatch: MaterialColor(
          0xFF8B4513,
          <int, Color>{
            50: const Color(0xFFF5E6D3),
            100: const Color(0xFFE8C4A0),
            200: const Color(0xFFD9A06D),
            300: const Color(0xFFCA7C3A),
            400: const Color(0xFFBF5F1A),
            500: const Color(0xFF8B4513),
            600: const Color(0xFF7A3D11),
            700: const Color(0xFF66330E),
            800: const Color(0xFF52290B),
            900: const Color(0xFF3D1F08),
          },
        ),
        scaffoldBackgroundColor: const Color(0xFFF5E6D3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B4513),
          foregroundColor: Color(0xFFF5E6D3),
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            color: Color(0xFF2D1810),
          ),
          displayMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: Color(0xFF2D1810),
          ),
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D1810),
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Color(0xFF2D1810),
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF8B4513),
          secondary: Color(0xFFD9A06D),
          surface: Color(0xFFF5E6D3),
          background: Color(0xFFF5E6D3),
          onPrimary: Color(0xFFF5E6D3),
          onSecondary: Color(0xFF2D1810),
          onSurface: Color(0xFF2D1810),
          onBackground: Color(0xFF2D1810),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final locale = Locale(_settings.language);
    return MaterialApp(
      title: 'Warm Light Calculator',
      theme: _getTheme(),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('zh'), // Mandarin
        Locale('ja'), // Japanese
        Locale('fi'), // Finnish
        Locale('af'), // Afrikaans
        Locale('sw'), // Swahili
        Locale('de'), // German
        Locale('pt'), // Portuguese
        Locale('it'), // Italian
        Locale('ru'), // Russian
        Locale('ar'), // Arabic
        Locale('hi'), // Hindi
        Locale('ko'), // Korean
      ],
      home: _settingsLoaded
          ? CalculatorScreen(settings: _settings, onSettingsChanged: _loadSettings)
          : const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Background finish widgets
class _MatteBackgroundPainter extends CustomPainter {
  final Color baseColor;
  
  _MatteBackgroundPainter(this.baseColor);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Make matte 1.5 shades lighter
    final lighterColor = Color.fromRGBO(
      (baseColor.red + 38).clamp(0, 255),
      (baseColor.green + 38).clamp(0, 255),
      (baseColor.blue + 38).clamp(0, 255),
      1.0,
    );
    final paint = Paint()..color = lighterColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // Add more visible matte texture with more speckles
    final random = math.Random(42);
    // More dots for denser texture
    for (int i = 0; i < 15000; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = random.nextDouble() * 0.08 + 0.02; // More visible
      paint.color = Colors.black.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 1.5, paint);
    }
    // Add more lighter spots for depth
    for (int i = 0; i < 5000; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = random.nextDouble() * 0.06;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MatteBackground extends StatelessWidget {
  final Color color;
  final Widget child;
  
  const _MatteBackground({required this.color, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MatteBackgroundPainter(color),
      child: child,
    );
  }
}

class _PlasticBackground extends StatelessWidget {
  final Color baseColor;
  final Widget child;
  
  const _PlasticBackground({required this.baseColor, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(baseColor, Colors.white, 0.18) ?? baseColor,
            Color.lerp(baseColor, Colors.white, 0.12) ?? baseColor,
            baseColor,
            Color.lerp(baseColor, Colors.black, 0.10) ?? baseColor,
          ],
          stops: const [0.0, 0.25, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Much stronger reflective highlight overlay (shinier plastic)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.2,
                  colors: [
                    Colors.white.withOpacity(0.40),
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.10),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.25, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Additional highlight for extra shine
          Positioned(
            top: 50,
            left: 50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Additional subtle gradient for depth
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.08),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final AppSettings settings;
  final VoidCallback onSettingsChanged;

  const CalculatorScreen({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _previousValue = '';
  String _operation = '';
  bool _waitingForOperand = false;
  double _memory = 0.0;
  String? _tipBreakdown; // Stores tip amount for display
  String? _previousDisplay; // For undo functionality
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Color _getButtonColor(bool isOperation, bool isSpecial, bool isEquals, bool isTip, ThemeData theme) {
    if (widget.settings.highContrast) {
      if (widget.settings.highContrastMode == 'dark') {
        if (isEquals || isSpecial) {
          return const Color(0xFFFFEAA7);
        }
        return Colors.grey[800]!;
      } else {
        if (isEquals || isSpecial) {
          return Colors.black;
        }
        return Colors.grey[300]!;
      }
    }

    // Warm light theme colors
    if (isEquals) {
      return const Color(0xFF8B4513);
    } else if (isTip) {
      return const Color(0xFFC49A6C); // Slightly different warm color for tips
    } else if (isOperation) {
      return const Color(0xFFCA7C3A);
    } else if (isSpecial) {
      return const Color(0xFFBF5F1A);
    } else {
      return const Color(0xFFD9A06D);
    }
  }

  Color _getButtonTextColor(bool isOperation, bool isSpecial, bool isEquals, ThemeData theme) {
    if (widget.settings.highContrast) {
      if (widget.settings.highContrastMode == 'dark') {
        return (isEquals || isSpecial) ? Colors.black : const Color(0xFFFFEAA7);
      } else {
        return (isEquals || isSpecial) ? Colors.white : Colors.black;
      }
    }

    return (isEquals || isSpecial) ? const Color(0xFFF5E6D3) : const Color(0xFF2D1810);
  }

  Color _getDisplayBackgroundColor(ThemeData theme) {
    if (widget.settings.highContrast) {
      if (widget.settings.highContrastMode == 'dark') {
        return Colors.grey[900]!;
      } else {
        return Colors.grey[200]!;
      }
    }
    return const Color(0xFFE8C4A0);
  }

  Color _getDisplayBorderColor(ThemeData theme) {
    if (widget.settings.highContrast) {
      if (widget.settings.highContrastMode == 'dark') {
        return const Color(0xFFFFEAA7);
      } else {
        return Colors.black;
      }
    }
    return const Color(0xFF8B4513);
  }

  Color _getBackgroundColor(ThemeData theme) {
    return theme.scaffoldBackgroundColor;
  }

  Widget _buildBackgroundFinish(Widget child, ThemeData theme) {
    final backgroundColor = _getBackgroundColor(theme);
    
    switch (widget.settings.backgroundFinish) {
      case 'matte':
        return _MatteBackground(color: backgroundColor, child: child);
      case 'plastic':
        return _PlasticBackground(baseColor: backgroundColor, child: child);
      case 'basic':
      default:
        return child;
    }
  }

  Future<void> _playSound() async {
    if (widget.settings.soundEffects) {
      HapticFeedback.lightImpact();
      try {
        await _audioPlayer.play(AssetSource('click_sound.mp3'));
      } catch (e) {
        // Silently handle audio errors
      }
    }
  }

  Future<void> _speakText(String text) async {
    final l10n = AppLocalizations.of(context);
    final errorText = l10n?.error ?? 'Error';
    if (widget.settings.textToSpeech && text != errorText && text != 'Error') {
      await _tts.speak(text);
    }
  }

  Future<void> _copyToClipboard() async {
    final l10n = AppLocalizations.of(context)!;
    if (_display != l10n.error && _display != 'Error') {
      await Clipboard.setData(ClipboardData(text: _display));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _applyTip(double percentage) {
    if (_display == 'Error') return;
    
    try {
      final double value = double.parse(_display.replaceAll(',', ''));
      if (value == 0) return; // Don't calculate tip on zero
      
      _saveStateForUndo(); // Save state before tip calculation
      
      final double tip = value * (percentage / 100);
      final double result = value + tip;
      
      // Round to 2 decimal places (cents) for currency
      final double roundedTip = (tip * 100).round() / 100;
      final double roundedResult = (result * 100).round() / 100;
      
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _display = _formatNumber(roundedResult);
        _tipBreakdown = l10n.tipBreakdown(_formatNumber(roundedTip));
        _waitingForOperand = true;
        _operation = ''; // Clear any pending operation
        _previousValue = ''; // Clear previous value
      });
      
      _playSound();
      _speakText(_display);
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _display = l10n.error;
        _waitingForOperand = false;
        _tipBreakdown = null;
      });
      _speakText(l10n.error);
    }
  }

  String _formatNumber(double number) {
    final l10n = AppLocalizations.of(context);
    final errorText = l10n?.error ?? 'Error';
    if (number.isNaN || number.isInfinite) return errorText;
    
    // Limit to 12 significant figures
    if (number.abs() >= 1) {
      // For numbers >= 1, limit total digits
      final String numberStr = number.toString();
      final parts = numberStr.split('.');
      final integerPart = parts[0];
      final decimalPart = parts.length > 1 ? parts[1] : '';
      
      // Limit total digits to 12
      final totalDigits = integerPart.replaceAll('-', '').length + decimalPart.length;
      if (totalDigits > 12) {
        if (integerPart.replaceAll('-', '').length >= 12) {
          // If integer part is already 12+ digits, just show integer
          return NumberFormatter.formatNumber(integerPart);
        } else {
          // Limit decimal places to fit within 12 total digits
          final maxDecimalPlaces = 12 - integerPart.replaceAll('-', '').length;
          final limitedDecimal = decimalPart.length > maxDecimalPlaces 
              ? decimalPart.substring(0, maxDecimalPlaces) 
              : decimalPart;
          return NumberFormatter.formatNumber('$integerPart${limitedDecimal.isNotEmpty ? '.$limitedDecimal' : ''}');
        }
      }
    } else {
      // For numbers < 1, limit to 12 significant figures total
      final String numberStr = number.toString();
      if (numberStr.length > 14) { // Account for "0." prefix
        // Use scientific notation for very small numbers, or truncate
        final parts = numberStr.split('.');
        if (parts.length > 1) {
          final decimalPart = parts[1];
          // Find first non-zero digit
          int firstNonZero = 0;
          for (int i = 0; i < decimalPart.length; i++) {
            if (decimalPart[i] != '0') {
              firstNonZero = i;
              break;
            }
          }
          // Keep 12 significant figures from first non-zero
          final significantDigits = decimalPart.substring(firstNonZero);
          final limited = significantDigits.length > 12 
              ? significantDigits.substring(0, 12) 
              : significantDigits;
          return NumberFormatter.formatNumber('0.${'0' * firstNonZero}$limited');
        }
      }
    }
    
    final String numberStr = number % 1 == 0 
        ? number.toInt().toString() 
        : number.toString();
    
    return NumberFormatter.formatNumber(numberStr);
  }

  void _undo() {
    if (_previousDisplay != null) {
      setState(() {
        _display = _previousDisplay!;
        _previousDisplay = null; // Clear after undo so can't undo multiple times
      });
      _playSound();
    }
  }

  void _saveStateForUndo() {
    // Save current state before making changes
    final l10n = AppLocalizations.of(context);
    final errorText = l10n?.error ?? 'Error';
    if (_display != errorText && _display != 'Error' && _display != '0') {
      _previousDisplay = _display;
    }
  }

  Future<void> _onButtonPressed(String value) async {
    await _playSound();
    
    // Handle undo separately
    final l10n = AppLocalizations.of(context)!;
    if (value == l10n.undo || value == 'UNDO') {
      _undo();
      return;
    }
    
    // Save state before making changes (except for memory operations)
    if (!value.startsWith('M')) {
      _saveStateForUndo();
    }
    
    setState(() {
      if (value == 'C') {
        _display = '0';
        _previousValue = '';
        _operation = '';
        _waitingForOperand = false;
        _tipBreakdown = null;
      } else if (value == '⌫') {
        final l10n = AppLocalizations.of(context);
        final errorText = l10n?.error ?? 'Error';
        if (_display != errorText && _display != 'Error' && _display.length > 1) {
          String newDisplay = _display.substring(0, _display.length - 1).replaceAll(',', '');
          _display = NumberFormatter.formatNumber(newDisplay);
        } else {
          _display = '0';
        }
      } else if (value == l10n.enter || value == 'ENTER') {
        _tipBreakdown = null; // Clear tip breakdown on new calculation
        _calculate();
      } else if (['+', '-', '×', '÷'].contains(value)) {
        _tipBreakdown = null; // Clear tip breakdown on new operation
        if (_operation.isNotEmpty && !_waitingForOperand) {
          _calculate();
        }
        _previousValue = _display.replaceAll(',', '');
        _operation = value;
        _waitingForOperand = true;
      } else if (value.startsWith('M')) {
        _handleMemory(value);
      } else if (value == '.') {
        // Handle decimal point
        if (_waitingForOperand || _display == 'Error') {
          _display = '0.';
          _waitingForOperand = false;
        } else {
          String cleanDisplay = _display.replaceAll(',', '');
          // Only add decimal point if it doesn't already exist
          if (!cleanDisplay.contains('.')) {
            _display = cleanDisplay + '.';
          }
        }
      } else {
        final l10n = AppLocalizations.of(context);
        final errorText = l10n?.error ?? 'Error';
        if (_waitingForOperand || _display == errorText || _display == 'Error') {
          _display = value;
          _waitingForOperand = false;
          _tipBreakdown = null; // Clear tip breakdown when entering new number
        } else {
          String cleanDisplay = _display.replaceAll(',', '');
          // If display ends with a decimal point, append the digit and format
          if (cleanDisplay.endsWith('.')) {
            _display = cleanDisplay + value;
            // Format only if it's a valid number (has digits before and after decimal)
            try {
              double.parse(_display);
              _display = NumberFormatter.formatNumber(_display);
            } catch (e) {
              // Keep as is if parsing fails
            }
          } else {
            _display = _display == '0' ? value : cleanDisplay + value;
            _display = NumberFormatter.formatNumber(_display);
          }
        }
      }
    });

    if (['+', '-', '×', '÷', l10n.enter, 'ENTER'].contains(value)) {
      await _speakText(value);
    } else if (value.length == 1 && RegExp(r'[0-9]').hasMatch(value)) {
      await _speakText(value);
    }
  }

  void _handleMemory(String operation) {
    try {
      final double currentValue = double.parse(_display.replaceAll(',', ''));
      
      switch (operation) {
        case 'M+':
          _memory += currentValue;
          break;
        case 'M-':
          _memory -= currentValue;
          break;
        case 'MR':
          setState(() {
            _display = _formatNumber(_memory);
            _waitingForOperand = true;
          });
          _speakText(_display);
          break;
        case 'MC':
          _memory = 0.0;
          break;
      }
      _playSound();
    } catch (e) {
      // Handle error silently
    }
  }

  void _calculate() {
    if (_operation.isEmpty || _previousValue.isEmpty) return;

    try {
      double prev = double.parse(_previousValue.replaceAll(',', ''));
      double current = double.parse(_display.replaceAll(',', ''));
      double result = 0;

      switch (_operation) {
        case '+':
          result = prev + current;
          break;
        case '-':
          result = prev - current;
          break;
        case '×':
          result = prev * current;
          break;
        case '÷':
          if (current != 0) {
            result = prev / current;
          } else {
            final l10n = AppLocalizations.of(context)!;
            setState(() {
              _display = l10n.error;
              _operation = '';
              _previousValue = '';
              _waitingForOperand = false;
            });
            _speakText(l10n.error);
            return;
          }
          break;
      }

      setState(() {
        _display = _formatNumber(result);
        _operation = '';
        _previousValue = '';
        _waitingForOperand = true;
      });

      _speakText(_display);
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _display = l10n.error;
        _operation = '';
        _previousValue = '';
        _waitingForOperand = false;
      });
      _speakText(l10n.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: _buildBackgroundFinish(
        SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
            // Display
            Expanded(
              flex: 1,
              child: GestureDetector(
                onLongPress: _copyToClipboard,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getDisplayBackgroundColor(theme),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getDisplayBorderColor(theme),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_tipBreakdown != null)
                        Text(
                          _tipBreakdown!,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 18,
                            color: theme.textTheme.displayLarge?.color?.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.end,
                        ),
                      Text(
                        _display,
                        style: theme.textTheme.displayLarge,
                        textAlign: TextAlign.end,
                      ),
                      if (_operation.isNotEmpty && _previousValue.isNotEmpty)
                        Text(
                          '${NumberFormatter.formatNumber(_previousValue)} $_operation',
                          style: theme.textTheme.headlineLarge,
                          textAlign: TextAlign.end,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Tip buttons row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  _buildTipButton(l10n.tip15, 15, theme),
                  const SizedBox(width: 8),
                  _buildTipButton(l10n.tip20, 20, theme),
                  const SizedBox(width: 8),
                  _buildTipButton(l10n.tip25, 25, theme),
                ],
              ),
            ),
            // Buttons
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Row 1: Memory buttons (M+, M-, MR, MC)
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('M+', isSpecial: true, theme: theme),
                          _buildButton('M-', isSpecial: true, theme: theme),
                          _buildButton('MR', isSpecial: true, theme: theme),
                          _buildButton('MC', isSpecial: true, theme: theme),
                        ],
                      ),
                    ),
                    // Row 2: Clear, Backspace, Divide, Multiply
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('C', isSpecial: true, theme: theme),
                          _buildButton('⌫', isSpecial: true, theme: theme),
                          _buildButton('÷', isOperation: true, theme: theme),
                          _buildButton('×', isOperation: true, theme: theme),
                        ],
                      ),
                    ),
                    // Row 3: 7, 8, 9, Subtract
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('7', theme: theme),
                          _buildButton('8', theme: theme),
                          _buildButton('9', theme: theme),
                          _buildButton('-', isOperation: true, theme: theme),
                        ],
                      ),
                    ),
                    // Row 4: 4, 5, 6, Add
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('4', theme: theme),
                          _buildButton('5', theme: theme),
                          _buildButton('6', theme: theme),
                          _buildButton('+', isOperation: true, theme: theme),
                        ],
                      ),
                    ),
                    // Row 5: 1, 2, 3, Undo
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1', theme: theme),
                          _buildButton('2', theme: theme),
                          _buildButton('3', theme: theme),
                          _buildButton(l10n.undo, isSpecial: true, theme: theme),
                        ],
                      ),
                    ),
                    // Row 6: 0, Decimal, Equals
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('0', theme: theme),
                          _buildButton('.', theme: theme),
                          _buildButton(l10n.enter, isOperation: true, isEquals: true, theme: theme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
              ],
            ),
            // Settings button in top right
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: theme.textTheme.displayLarge?.color,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(settings: widget.settings, onSettingsChanged: widget.onSettingsChanged),
                    ),
                  );
                  widget.onSettingsChanged();
                  setState(() {}); // Refresh UI
                },
              ),
            ),
          ],
        ),
      ),
        theme,
      ),
    );
  }

  Widget _buildTipButton(String label, double percentage, ThemeData theme) {
    final backgroundColor = _getButtonColor(false, false, false, true, theme);
    final textColor = _getButtonTextColor(false, false, false, theme);
    
    // Create lighter and darker versions for the glossy gradient
    final lighterColor = Color.fromRGBO(
      (backgroundColor.red + 50).clamp(0, 255),
      (backgroundColor.green + 50).clamp(0, 255),
      (backgroundColor.blue + 50).clamp(0, 255),
      1.0,
    );
    final darkerColor = Color.fromRGBO(
      (backgroundColor.red - 30).clamp(0, 255),
      (backgroundColor.green - 30).clamp(0, 255),
      (backgroundColor.blue - 30).clamp(0, 255),
      1.0,
    );
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        height: 60,
        child: _TipButtonWidget(
          label: label,
          backgroundColor: backgroundColor,
          lighterColor: lighterColor,
          darkerColor: darkerColor,
          textColor: textColor,
          backgroundFinish: widget.settings.backgroundFinish,
          onPressed: () => _applyTip(percentage),
        ),
      ),
    );
  }

  Widget _buildButton(String text, {bool isOperation = false, bool isSpecial = false, bool isEquals = false, required ThemeData theme}) {
    final backgroundColor = _getButtonColor(isOperation, isSpecial, isEquals, false, theme);
    final textColor = _getButtonTextColor(isOperation, isSpecial, isEquals, theme);
    
    // Create lighter and darker versions for the glossy gradient
    final lighterColor = Color.fromRGBO(
      (backgroundColor.red + 50).clamp(0, 255),
      (backgroundColor.green + 50).clamp(0, 255),
      (backgroundColor.blue + 50).clamp(0, 255),
      1.0,
    );
    final darkerColor = Color.fromRGBO(
      (backgroundColor.red - 30).clamp(0, 255),
      (backgroundColor.green - 30).clamp(0, 255),
      (backgroundColor.blue - 30).clamp(0, 255),
      1.0,
    );

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        height: 60,
        child: _CalculatorButtonWidget(
          text: text,
          backgroundColor: backgroundColor,
          lighterColor: lighterColor,
          darkerColor: darkerColor,
          textColor: textColor,
          backgroundFinish: widget.settings.backgroundFinish,
          onPressed: () => _onButtonPressed(text),
        ),
      ),
    );
  }
}

class _CalculatorButtonWidget extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color lighterColor;
  final Color darkerColor;
  final Color textColor;
  final String backgroundFinish;
  final VoidCallback onPressed;

  const _CalculatorButtonWidget({
    required this.text,
    required this.backgroundColor,
    required this.lighterColor,
    required this.darkerColor,
    required this.textColor,
    required this.backgroundFinish,
    required this.onPressed,
  });

  @override
  State<_CalculatorButtonWidget> createState() => _CalculatorButtonWidgetState();
}

class _CalculatorButtonWidgetState extends State<_CalculatorButtonWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  
  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }
  
  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pressController,
      builder: (context, child) {
        final pressProgress = _pressController.value;
        final pressOffset = pressProgress * 2.0;
        
        // Darken colors on press
        final currentBaseColor = Color.lerp(
          widget.backgroundColor,
          widget.darkerColor,
          pressProgress * 0.3,
        )!;
        final currentLightColor = Color.lerp(
          widget.lighterColor,
          widget.backgroundColor,
          pressProgress * 0.4,
        )!;
        
        // Reduce shadow on press (cave in effect)
        final shadowOffset = 5 - (pressProgress * 3);
        final shadowBlur = 8 - (pressProgress * 5);
        final highlightOpacity = 0.4 - (pressProgress * 0.3);
        
        // Add extra drop shadows for plastic finish
        final List<BoxShadow> shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(0.4 - pressProgress * 0.2),
            offset: Offset(0, shadowOffset),
            blurRadius: shadowBlur,
            spreadRadius: -1,
          ),
        ];
        
        if (widget.backgroundFinish == 'plastic') {
          // Add multiple drop shadows for plastic finish
          shadows.addAll([
            BoxShadow(
              color: Colors.black.withOpacity(0.15 - pressProgress * 0.05),
              offset: Offset(0, shadowOffset + 2),
              blurRadius: shadowBlur + 4,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.10 - pressProgress * 0.03),
              offset: Offset(0, shadowOffset + 4),
              blurRadius: shadowBlur + 8,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(2, shadowOffset + 1),
              blurRadius: shadowBlur + 2,
              spreadRadius: 0,
            ),
          ]);
        }
        
        return GestureDetector(
          onTapDown: (_) {
            _pressController.forward();
          },
          onTapUp: (_) {
            _pressController.reverse();
            widget.onPressed();
          },
          onTapCancel: () {
            _pressController.reverse();
          },
          child: Transform.translate(
            offset: Offset(0, pressOffset),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    currentLightColor,
                    currentBaseColor,
                    widget.darkerColor,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: shadows,
              ),
              child: Stack(
                children: [
                  // Glossy highlight overlay (oval-shaped on top-left)
                  Positioned(
                    top: -10,
                    left: -10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(highlightOpacity),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Button content
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: null,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: widget.text == 'UNDO' || widget.text == 'ENTER' || 
                               widget.text == AppLocalizations.of(context)?.undo || 
                               widget.text == AppLocalizations.of(context)?.enter
                          ? Text(
                              widget.text,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.5,
                                color: widget.textColor,
                              ),
                            )
                          : Text(
                              widget.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: widget.textColor,
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TipButtonWidget extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final Color lighterColor;
  final Color darkerColor;
  final Color textColor;
  final String backgroundFinish;
  final VoidCallback onPressed;

  const _TipButtonWidget({
    required this.label,
    required this.backgroundColor,
    required this.lighterColor,
    required this.darkerColor,
    required this.textColor,
    required this.backgroundFinish,
    required this.onPressed,
  });

  @override
  State<_TipButtonWidget> createState() => _TipButtonWidgetState();
}

class _TipButtonWidgetState extends State<_TipButtonWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  
  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }
  
  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pressController,
      builder: (context, child) {
        final pressProgress = _pressController.value;
        final pressOffset = pressProgress * 2.0;
        
        // Darken colors on press
        final currentBaseColor = Color.lerp(
          widget.backgroundColor,
          widget.darkerColor,
          pressProgress * 0.3,
        )!;
        final currentLightColor = Color.lerp(
          widget.lighterColor,
          widget.backgroundColor,
          pressProgress * 0.4,
        )!;
        
        // Reduce shadow on press (cave in effect)
        final shadowOffset = 5 - (pressProgress * 3);
        final shadowBlur = 8 - (pressProgress * 5);
        final highlightOpacity = 0.4 - (pressProgress * 0.3);
        
        // Add extra drop shadows for plastic finish
        final List<BoxShadow> shadows = [
          BoxShadow(
            color: Colors.black.withOpacity(0.4 - pressProgress * 0.2),
            offset: Offset(0, shadowOffset),
            blurRadius: shadowBlur,
            spreadRadius: -1,
          ),
        ];
        
        if (widget.backgroundFinish == 'plastic') {
          // Add multiple drop shadows for plastic finish
          shadows.addAll([
            BoxShadow(
              color: Colors.black.withOpacity(0.15 - pressProgress * 0.05),
              offset: Offset(0, shadowOffset + 2),
              blurRadius: shadowBlur + 4,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.10 - pressProgress * 0.03),
              offset: Offset(0, shadowOffset + 4),
              blurRadius: shadowBlur + 8,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(2, shadowOffset + 1),
              blurRadius: shadowBlur + 2,
              spreadRadius: 0,
            ),
          ]);
        }
        
        return GestureDetector(
          onTapDown: (_) {
            _pressController.forward();
          },
          onTapUp: (_) {
            _pressController.reverse();
            widget.onPressed();
          },
          onTapCancel: () {
            _pressController.reverse();
          },
          child: Transform.translate(
            offset: Offset(0, pressOffset),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    currentLightColor,
                    currentBaseColor,
                    widget.darkerColor,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: shadows,
              ),
              child: Stack(
                children: [
                  // Glossy highlight overlay (oval-shaped on top-left)
                  Positioned(
                    top: -10,
                    left: -10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(highlightOpacity),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Button content
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: null,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: widget.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final AppSettings settings;
  final VoidCallback? onSettingsChanged;

  const SettingsScreen({super.key, required this.settings, this.onSettingsChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _textToSpeech;
  late bool _highContrast;
  late bool _soundEffects;
  late String _highContrastMode;
  late bool _darkMode;
  late String _backgroundFinish;
  late String _language;

  @override
  void initState() {
    super.initState();
    _textToSpeech = widget.settings.textToSpeech;
    _highContrast = widget.settings.highContrast;
    _soundEffects = widget.settings.soundEffects;
    _highContrastMode = widget.settings.highContrastMode;
    _darkMode = widget.settings.darkMode;
    _backgroundFinish = widget.settings.backgroundFinish;
    _language = widget.settings.language;
  }

  Future<void> _saveSettings() async {
    widget.settings.textToSpeech = _textToSpeech;
    widget.settings.highContrast = _highContrast;
    widget.settings.soundEffects = _soundEffects;
    widget.settings.highContrastMode = _highContrastMode;
    widget.settings.darkMode = _darkMode;
    widget.settings.backgroundFinish = _backgroundFinish;
    widget.settings.language = _language;
    await widget.settings.saveSettings();
    // Trigger rebuild of parent to apply language change
    if (mounted) {
      widget.onSettingsChanged?.call();
      // Only pop if we're not already closing (language change handles its own pop)
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final packageInfo = '1.0.0+1'; // From pubspec.yaml
    
    // Language names map
    final languageNames = {
      'en': 'English',
      'es': 'Español',
      'fr': 'Français',
      'zh': '中文',
      'ja': '日本語',
      'fi': 'Suomi',
      'af': 'Afrikaans',
      'sw': 'Kiswahili',
      'de': 'Deutsch',
      'pt': 'Português',
      'it': 'Italiano',
      'ru': 'Русский',
      'ar': 'العربية',
      'hi': 'हिन्दी',
      'ko': '한국어',
    };
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language picker
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(languageNames[_language] ?? 'English'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.language),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: languageNames.length,
                      itemBuilder: (context, index) {
                        final langCode = languageNames.keys.elementAt(index);
                        final langName = languageNames[langCode]!;
                        return RadioListTile<String>(
                          title: Text(langName),
                          value: langCode,
                          groupValue: _language,
                          onChanged: (value) {
                            setState(() {
                              _language = value!;
                            });
                            Navigator.of(context).pop(); // Close dialog first
                            _saveSettings(); // Then save and close settings
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: Text(l10n.textToSpeech),
            subtitle: Text(l10n.textToSpeechSubtitle),
            value: _textToSpeech,
            onChanged: (value) {
              setState(() {
                _textToSpeech = value;
              });
              _saveSettings();
            },
          ),
          SwitchListTile(
            title: Text(l10n.darkMode),
            subtitle: Text(l10n.darkModeSubtitle),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
                // Disable high contrast when dark mode is enabled
                if (value) {
                  _highContrast = false;
                }
              });
              _saveSettings();
            },
          ),
          SwitchListTile(
            title: Text(l10n.highContrastMode),
            subtitle: Text(l10n.highContrastModeSubtitle),
            value: _highContrast,
            onChanged: (value) {
              setState(() {
                _highContrast = value;
                // Disable dark mode when high contrast is enabled
                if (value) {
                  _darkMode = false;
                }
              });
              _saveSettings();
            },
          ),
          if (_highContrast)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.highContrastStyle),
                  RadioListTile<String>(
                    title: Text(l10n.highContrastDark),
                    value: 'dark',
                    groupValue: _highContrastMode,
                    onChanged: (value) {
                      setState(() {
                        _highContrastMode = value!;
                      });
                      _saveSettings();
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.highContrastLight),
                    value: 'light',
                    groupValue: _highContrastMode,
                    onChanged: (value) {
                      setState(() {
                        _highContrastMode = value!;
                      });
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),
          SwitchListTile(
            title: Text(l10n.soundEffects),
            subtitle: Text(l10n.soundEffectsSubtitle),
            value: _soundEffects,
            onChanged: (value) {
              setState(() {
                _soundEffects = value;
              });
              _saveSettings();
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.backgroundFinish,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'basic',
                  label: Text(l10n.basic),
                ),
                ButtonSegment(
                  value: 'matte',
                  label: Text(l10n.matte),
                ),
                ButtonSegment(
                  value: 'plastic',
                  label: Text(l10n.plastic),
                ),
              ],
              selected: {_backgroundFinish},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _backgroundFinish = newSelection.first;
                });
                _saveSettings();
              },
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          const Divider(),
          // Version
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.version,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  packageInfo,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          // Changelog
          ListTile(
            title: Text(l10n.changelog),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.changelog),
                  content: SingleChildScrollView(
                    child: Text(
                      l10n.changelogContent,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(MaterialLocalizations.of(context).okButtonLabel),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Long-press the display to copy the result to clipboard.',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicyTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.privacyPolicyTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.privacyPolicyContent,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
