import 'package:flutter/services.dart';

class CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String input = newValue.text.replaceAll("-", "");

    StringBuffer formattedValue = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedValue.write('-');
      }
      formattedValue.write(input[i]);
    }

    return TextEditingValue(
      text: formattedValue.toString(),
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
