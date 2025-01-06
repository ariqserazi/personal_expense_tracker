import 'package:flutter/material.dart';

Color getColor(String category) {
  switch (category) {
    case 'FOOD':
      return Colors.blue;
    case 'TRANSPORT':
      return Colors.green;
    case 'SHOPPING':
      return Colors.purple;
    case 'ENTERTAINMENT':
      return Colors.yellow;
    case 'BILLS':
      return Colors.red;
    case 'EDUCATION':
      return Colors.pink;
    case 'HEALTH':
      return Colors.indigo;
    default:
      return Colors.orange;
  }
}
