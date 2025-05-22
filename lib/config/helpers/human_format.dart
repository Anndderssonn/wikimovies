import 'package:intl/intl.dart';

class HumanFormat {
  static String number(double number, [int decimals = 0]) {
    double corrected = decimals == 0 ? number * 1000 : number;
    final formatted = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en_US',
    ).format(corrected);
    return formatted;
  }
}
