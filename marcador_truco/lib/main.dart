//! main.dart

import 'package:flutter/material.dart';
import 'package:marcador_truco/views/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.red, brightness: Brightness.dark),
    home: HomePage(),
  ));
}
