import 'package:flutter/material.dart';
import 'package:mqtt_led/providers/messageProvider.dart';
import 'package:mqtt_led/providers/mqttService_provider.dart';
import 'package:mqtt_led/share/styled_text.dart';
import 'package:mqtt_led/widget/card_list.dart';
import 'package:provider/provider.dart';

class Subscribe_screen extends StatefulWidget {
  const Subscribe_screen({super.key});

  @override
  State<Subscribe_screen> createState() => _Subscribe_screenState();
}

class _Subscribe_screenState extends State<Subscribe_screen> {
  final TextEditingController _subscribeTopicController = TextEditingController();
  
  @override
  void initState() {
    super.initState();

    // Delay so context is fully available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mqtt = Provider.of<MQTTProvider>(context, listen: false);
      final messages = Provider.of<MessageProvider>(context, listen: false);

      if (mqtt.isConnected) {
        mqtt.attachMessageProvider(messages); // Important!
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mqtt = Provider.of<MQTTProvider>(context, listen: false);
    final messages = Provider.of<MessageProvider>(context); // listen: true by default
    final brokerAddress = mqtt.brokerAddress;
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
       body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subscribeTopicController,
                    decoration: const InputDecoration(
                      labelText: 'Enter topic to subscribe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (){
                    if (mqtt.isConnected) {
                      mqtt.subscribe(_subscribeTopicController.text);
                    }
                  },
                  child: const Text('Subscribe'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: mqtt.isConnected
                ? ListView.builder(
                    itemCount: messages.messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages.messages[index];
                      return SubcribeMessage(
                        title: msg['title']!,
                        subtitle: msg['subtitle']!,
                      );
                    },
                  )
              : const Center(child: Text('Waiting for connection...')),
            ),
          ],
        ),
      ),
    );
  }
}


