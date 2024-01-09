import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
/// Contains commonly used methods
class GlobalHelper {
  static double getPreferredWidth(BuildContext context) {
    return min(400, MediaQuery.of(context).size.width/2);
  }

  static String calculateSHA256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  } 
}