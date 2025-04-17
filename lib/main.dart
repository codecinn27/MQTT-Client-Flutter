import 'package:flutter/material.dart';
import 'package:mqtt_led/widget/bottom_navigation_bar3.dart';


void main() {
  runApp(MaterialApp(
  home: BottomNavigationBar3(),
  debugShowCheckedModeBanner: false,
  theme: ThemeData(useMaterial3: true),
 ));
}
