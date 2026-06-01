import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    /// All code commented because I don't know how to implement many formats by it's
    /// country code, I think is neccessary to use an API or an librar, but that, is
    /// For the future
    
    // if (newValue.text.length > 12 && newValue.text.length < 14) {
    //   String part1 = newValue.text.substring(0, 3);
    //   String part2 = newValue.text.substring(3, 6);
    //   String part3 = newValue.text.substring(6, 9);
    //   String part4 = newValue.text.substring(9, newValue.text.length);
    //   String text = "+$part1 ($part2) $part3-$part4";

    //   return TextEditingValue(
    //     text: text,
    //     selection: TextSelection.collapsed(offset: text.length)
    //   );
    // }

    // if (newValue.text.length > 11 && newValue.text.length < 13) {
    //   String part1 = newValue.text.substring(0, 2);
    //   String part2 = newValue.text.substring(2, 5);
    //   String part3 = newValue.text.substring(5, 8);
    //   String part4 = newValue.text.substring(8, newValue.text.length);
    //   String text = "+$part1 ($part2) $part3-$part4";

    //   return TextEditingValue(
    //     text: text,
    //     selection: TextSelection.collapsed(offset: text.length)
    //   );
    // }

    // String part1 = newValue.text[0];

    // if (newValue.text.length > 7 && newValue.text.length < 12) {
    //   String part2 = newValue.text.substring(1, 4);
    //   String part3 = newValue.text.substring(4, 7);
    //   String part4 = newValue.text.substring(7, newValue.text.length);
    //   String text = "+$part1 ($part2) $part3-$part4";

    //   return TextEditingValue(
    //     text: text,
    //     selection: TextSelection.collapsed(offset: text.length)
    //   );
    // }

    // if (newValue.text.length > 3 && newValue.text.length < 8) {
    //   String part2 = newValue.text.substring(1, 4);
    //   String part3 = newValue.text.substring(4, newValue.text.length);
    //   String text = "+$part1 ($part2) $part3";

    //   return TextEditingValue(
    //     text: text,
    //     selection: TextSelection.collapsed(offset: text.length)
    //   );
    // }

    // if (newValue.text.length > 3 && newValue.text.length < 7) {
    //   String part2 = newValue.text.substring(1);
    //   String text = "+$part1 ($part2)";

    //   return TextEditingValue(
    //     text: text,
    //     selection: TextSelection.collapsed(offset: text.length)
    //   );
    // }

    // if (newValue.text.isNotEmpty && newValue.text.length < 4) {
    //   String text = "+${newValue.text}";
    //   return TextEditingValue(
    //     text: text,
    //     selection: TextSelection.collapsed(offset: text.length)
    //   );
    // }

    if (newValue.text.isNotEmpty) {
      String text = "+${newValue.text}";
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length)
      );
    }

    return newValue;
  }
}
