import 'package:intl/intl.dart';

class CurrencyFormat {
  CurrencyFormat(double? balance, double i);

  static String convertToIdr(dynamic number, double decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'PKR: ',
      decimalDigits: decimalDigit.toInt(),
    );
    return currencyFormatter.format(number);
  }

  static String convertToUsd(dynamic number, double decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'en',
      symbol: 'USD: ',
      decimalDigits: decimalDigit.toInt(),
    );
    return currencyFormatter.format(number);
  }

   static currencyFormat(double value) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'PKR: ',
    ).format(value);
  }
}


class NumberToWord {
  String convert(int number) {
    if (number == 0) {
      return "Zero";
    }
    if (number < 0) {
      return "minus ${convert(-number)}";
    }
    String words = "";
    if ((number / 1000000).floor() > 0) {
      words += "${convert(number ~/ 1000000)} million ";
      number %= 1000000;
    }
    if ((number / 1000).floor() > 0) {
      words += "${convert(number ~/ 1000)} Thousand ";
      number %= 1000;
    }
    if ((number / 100).floor() > 0) {
      words += "${convert(number ~/ 100)} Hundred ";
      number %= 100;
    }
    if (number > 0) {
      if (words != "") {
        words += "and ";
      }
      var unitsMap = [
        "",
        "One",
        "Two",
        "Three",
        "Four",
        "Five",
        "Six",
        "Seven",
        "Eight",
        "Nine"
      ];
      var tensMap = [
        "",
        "",
        "Twenty",
        "Thirty",
        "Forty",
        "Fifty",
        "Sixty",
        "Seventy",
        "Eighty",
        "Ninety"
      ];
      if (number < 10) {
        words += unitsMap[number];
      } else if (number < 20) {
        var units = number % 10;
        words += [
          "Ten",
          "Eleven",
          "Twelve",
          "Thirteen",
          "Fourteen",
          "Fifteen",
          "Sixteen",
          "Seventeen",
          "Eighteen",
          "Nineteen"
        ][units];
      } else {
        var units = number % 10;
        var tens = (number ~/ 10);
        words += "${tensMap[tens]} ${unitsMap[units]}";
      }
    }
    return words;
  }
}
