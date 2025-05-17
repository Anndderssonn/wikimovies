import 'package:intl/intl.dart';

class HumanFormat {
  static String number(double number) {
    double corrected = number * 1000;
    final formatted = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en_US',
    ).format(corrected);
    return formatted;
  }
}
