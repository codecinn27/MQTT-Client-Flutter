import 'package:flutter/material.dart';
import 'package:mqtt_led/share/styled_text.dart';
import 'package:mqtt_led/widget/card_list.dart';

class Subscribe_screen extends StatefulWidget {
  const Subscribe_screen({super.key});

  @override
  State<Subscribe_screen> createState() => _Subscribe_screenState();
}

class _Subscribe_screenState extends State<Subscribe_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const StyledHeading("Subscribe Topic"),
            ]
          ),
        ),
      ),
      body: Column(
        children: [
          SubcribeMessage(title: "haha", subtitle: "Hello world"),
        ],
      ),
    );
  }
}

