import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/settings_model.dart';
import 'utils/number_formatter.dart';
import 'dart:ui' as ui;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WarmLightCalculatorApp());
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
    setState(() {
      _settingsLoaded = true;
    });
  }

  ThemeData _getTheme() {
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
    if (!_settingsLoaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Warm Light Calculator',
      theme: _getTheme(),
      home: CalculatorScreen(settings: _settings, onSettingsChanged: _loadSettings),
      debugShowCheckedModeBanner: false,
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

class _CalculatorScreenState extends State<CalculatorScreen> with SingleTickerProviderStateMixin {
  String _display = '0';
  String _previousValue = '';
  String _operation = '';
  bool _waitingForOperand = false;
  double _memory = 0.0;
  final FlutterTts _tts = FlutterTts();
  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
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

  Future<void> _playSound() async {
    if (widget.settings.soundEffects) {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _speakText(String text) async {
    if (widget.settings.textToSpeech && text != 'Error') {
      await _tts.speak(text);
    }
  }

  Future<void> _copyToClipboard() async {
    if (_display != 'Error') {
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
      
      final double tip = value * (percentage / 100);
      final double result = value + tip;
      
      setState(() {
        _display = _formatNumber(result);
        _waitingForOperand = true;
        _operation = ''; // Clear any pending operation
        _previousValue = ''; // Clear previous value
      });
      
      _playSound();
      _speakText(_display);
    } catch (e) {
      setState(() {
        _display = 'Error';
        _waitingForOperand = false;
      });
      _speakText('Error');
    }
  }

  String _formatNumber(double number) {
    if (number.isNaN || number.isInfinite) return 'Error';
    
    final String numberStr = number % 1 == 0 
        ? number.toInt().toString() 
        : number.toString();
    
    return NumberFormatter.formatNumber(numberStr);
  }

  Future<void> _onButtonPressed(String value) async {
    await _playSound();
    
    setState(() {
      if (value == 'C') {
        _display = '0';
        _previousValue = '';
        _operation = '';
        _waitingForOperand = false;
      } else if (value == '⌫') {
        if (_display != 'Error' && _display.length > 1) {
          String newDisplay = _display.substring(0, _display.length - 1).replaceAll(',', '');
          _display = NumberFormatter.formatNumber(newDisplay);
        } else {
          _display = '0';
        }
      } else if (value == '=') {
        _calculate();
      } else if (['+', '-', '×', '÷'].contains(value)) {
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
        if (_waitingForOperand || _display == 'Error') {
          _display = value;
          _waitingForOperand = false;
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

    if (['+', '-', '×', '÷', '='].contains(value)) {
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
            setState(() {
              _display = 'Error';
              _operation = '';
              _previousValue = '';
              _waitingForOperand = false;
            });
            _speakText('Error');
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
      setState(() {
        _display = 'Error';
        _operation = '';
        _previousValue = '';
        _waitingForOperand = false;
      });
      _speakText('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Warm Light Calculator',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(settings: widget.settings),
                ),
              );
              widget.onSettingsChanged();
              setState(() {}); // Refresh UI
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              flex: 2,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildTipButton('Add 10% tip', 10, theme),
                  const SizedBox(width: 8),
                  _buildTipButton('Add 15% tip', 15, theme),
                  const SizedBox(width: 8),
                  _buildTipButton('Add 20% tip', 20, theme),
                  const SizedBox(width: 8),
                  _buildTipButton('Add 25% tip', 25, theme),
                ],
              ),
            ),
            // Buttons
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
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
                    // Row 5: 1, 2, 3, Equals
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1', theme: theme),
                          _buildButton('2', theme: theme),
                          _buildButton('3', theme: theme),
                          _buildButton('=', isOperation: true, isEquals: true, theme: theme),
                        ],
                      ),
                    ),
                    // Row 6: 0 (spanning 2 columns), Decimal
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildButton('0', theme: theme),
                          ),
                          _buildButton('.', theme: theme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipButton(String label, double percentage, ThemeData theme) {
    final backgroundColor = _getButtonColor(false, false, false, true, theme);
    final textColor = _getButtonTextColor(false, false, false, theme);
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: ElevatedButton(
          onPressed: () => _applyTip(percentage),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: 2,
            minimumSize: const Size(0, 48), // Minimum touch target
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, {bool isOperation = false, bool isSpecial = false, bool isEquals = false, required ThemeData theme}) {
    final backgroundColor = _getButtonColor(isOperation, isSpecial, isEquals, false, theme);
    final textColor = _getButtonTextColor(isOperation, isSpecial, isEquals, theme);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: AnimatedBuilder(
          animation: _buttonAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 - (_buttonAnimationController.value * 0.05),
              child: ElevatedButton(
                onPressed: () async {
                  _buttonAnimationController.forward().then((_) {
                    _buttonAnimationController.reverse();
                  });
                  await _onButtonPressed(text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: textColor,
                  elevation: 2,
                  minimumSize: const Size(0, 48), // Minimum touch target for accessibility
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Text(text),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final AppSettings settings;

  const SettingsScreen({super.key, required this.settings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _textToSpeech;
  late bool _highContrast;
  late bool _soundEffects;
  late String _highContrastMode;

  @override
  void initState() {
    super.initState();
    _textToSpeech = widget.settings.textToSpeech;
    _highContrast = widget.settings.highContrast;
    _soundEffects = widget.settings.soundEffects;
    _highContrastMode = widget.settings.highContrastMode;
  }

  Future<void> _saveSettings() async {
    widget.settings.textToSpeech = _textToSpeech;
    widget.settings.highContrast = _highContrast;
    widget.settings.soundEffects = _soundEffects;
    widget.settings.highContrastMode = _highContrastMode;
    await widget.settings.saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Text-to-Speech'),
            subtitle: const Text('Speak numbers and operations'),
            value: _textToSpeech,
            onChanged: (value) {
              setState(() {
                _textToSpeech = value;
              });
              _saveSettings();
            },
          ),
          SwitchListTile(
            title: const Text('High Contrast Mode'),
            subtitle: const Text('Enhanced visibility for accessibility'),
            value: _highContrast,
            onChanged: (value) {
              setState(() {
                _highContrast = value;
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
                  const Text('High Contrast Style'),
                  RadioListTile<String>(
                    title: const Text('Dark (Black background, Yellow text)'),
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
                    title: const Text('Light (White background, Black text)'),
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
            title: const Text('Sound Effects'),
            subtitle: const Text('Haptic feedback on button press'),
            value: _soundEffects,
            onChanged: (value) {
              setState(() {
                _soundEffects = value;
              });
              _saveSettings();
            },
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Long-press the display to copy the result to clipboard.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
