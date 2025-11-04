class NumberFormatter {
  static String formatNumber(String number) {
    if (number == 'Error' || number.isEmpty) return number;
    
    try {
      // Remove existing commas
      String cleanNumber = number.replaceAll(',', '');
      
      // Check if it's a valid number
      final double value = double.parse(cleanNumber);
      
      // Split integer and decimal parts
      final parts = cleanNumber.split('.');
      final integerPart = parts[0];
      final decimalPart = parts.length > 1 ? parts[1] : '';
      
      // Add commas to integer part (handle negative sign)
      String formatted = integerPart;
      bool isNegative = formatted.startsWith('-');
      if (isNegative) {
        formatted = formatted.substring(1);
      }
      
      if (formatted.length > 3) {
        final reversed = formatted.split('').reversed.join('');
        final buffer = StringBuffer();
        for (int i = 0; i < reversed.length; i++) {
          if (i > 0 && i % 3 == 0) {
            buffer.write(',');
          }
          buffer.write(reversed[i]);
        }
        formatted = buffer.toString().split('').reversed.join('');
      }
      
      // Add back negative sign if needed
      if (isNegative) {
        formatted = '-$formatted';
      }
      
      // Rejoin with decimal if present (limit to 10 decimal places for display)
      if (decimalPart.isNotEmpty) {
        final limitedDecimal = decimalPart.length > 10 ? decimalPart.substring(0, 10) : decimalPart;
        return '$formatted.$limitedDecimal';
      }
      return formatted;
    } catch (e) {
      return number;
    }
  }
}

