import 'package:flutter/material.dart';
import 'package:mqtt_led/providers/broker_provider.dart';
import 'package:mqtt_led/share/styled_text.dart';
import 'package:mqtt_led/widget/card_list.dart';
import 'package:provider/provider.dart';

class Subscribe_screen extends StatefulWidget {
  const Subscribe_screen({super.key});

  @override
  State<Subscribe_screen> createState() => _Subscribe_screenState();
}

class _Subscribe_screenState extends State<Subscribe_screen> {
  @override
  Widget build(BuildContext context) {
    final brokerAddress = Provider.of<GlobalState>(context).brokerAddress;
    final displayAddress = brokerAddress.isEmpty 
        ? 'Not connected' 
        : brokerAddress!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const StyledHeading("Subscribe Topic"),
              StyledTitle(displayAddress),
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

