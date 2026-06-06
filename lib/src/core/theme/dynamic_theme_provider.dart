import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dynamicThemeProvider = Provider<ThemeData>((ref) {
  return ThemeData.dark();
});
