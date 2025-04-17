import 'package:flutter/material.dart';
import 'package:mqtt_led/providers/broker_provider.dart';
import 'package:mqtt_led/share/styled_text.dart';
import 'package:provider/provider.dart';

class PublishScreen extends StatelessWidget {
  const PublishScreen({super.key});

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
            child:Column(
              children: [
                const SizedBox(height: 15),
                StyledHeading("Publish Site"),
                StyledTitle(displayAddress), // Removed interpolation
              ],
            ),
        ),
      ),
    );
  }
}