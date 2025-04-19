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

  void _handleSubscribe() {
    final topic = _subscribeTopicController.text.trim();
    if (topic.isEmpty) return;

    final mqtt = Provider.of<MQTTProvider>(context, listen: false);
    final messages = Provider.of<MessageProvider>(context, listen: false);

    if (mqtt.isConnected) {
      mqtt.subscribe(topic);
      messages.addSubscribedTopic(topic); // <-- Store in MessageProvider
      _subscribeTopicController.clear();
    }
  }

  @override

  Widget build(BuildContext context) {
    final mqtt = Provider.of<MQTTProvider>(context);
    final brokerAddress = mqtt.brokerAddress;
    final displayAddress = brokerAddress.isEmpty? 'Not connected': brokerAddress;
    final messageProvider = Provider.of<MessageProvider>(context);
    final isConnected = mqtt.isConnected;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const StyledHeading("Subscribe Topic"),
              // StyledTitle(displayAddress),
              if (brokerAddress.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  StyledTitle(displayAddress),
                  StyledText(isConnected ? "Connected" : "Disconnected")
                ] else ...[
                  const StyledText("Not connected"),
                ],
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
                  onPressed: _handleSubscribe,
                  child: const Text('Subscribe'),
                ),
              ],
            ),
            const SizedBox(height:10),
            StyledTitle("Topic Subscribe"),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: messageProvider.subscribedTopics.length,
                itemBuilder: (context, index) {
                  final topic = messageProvider.subscribedTopics[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.topic),
                      title: Text(topic),
                    ),
                  );
                },
              ),
            ),            
          ],
        ),
      ),
    );
  }
}


