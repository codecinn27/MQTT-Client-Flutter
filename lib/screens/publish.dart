import 'package:flutter/material.dart';
import 'package:mqtt_led/providers/mqttService_provider.dart';
import 'package:mqtt_led/share/styled_text.dart';
import 'package:provider/provider.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  final _topicController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose(); //prevent memory leak
    _messageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final mqtt = Provider.of<MQTTProvider>(context, listen: false);
    
    final brokerAddress = mqtt.brokerAddress;
    final displayAddress = brokerAddress.isEmpty ? 'Not connected': brokerAddress;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                StyledHeading("Publish Site"),
                StyledTitle(displayAddress), 
                const SizedBox(height: 15),
              ],
            ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SampleCard(
              topicController: _topicController,
              messageController: _messageController,
            ),
          ],
        ),
      ) ,
    );
  }
}


class _SampleCard extends StatelessWidget {
  const _SampleCard({
    required this.topicController,
    required this.messageController,
  });

  final TextEditingController topicController;
  final TextEditingController messageController;

  void publishMqttMessage(BuildContext context) {
    final mqttProvider = Provider.of<MQTTProvider>(context, listen: false);
    final topic = topicController.text.trim();
    final message = messageController.text.trim();

    if (topic.isNotEmpty && message.isNotEmpty && mqttProvider.isConnected) {
      mqttProvider.publish(topic, message);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message Published!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter topic & message, and ensure you are connected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15), // 10 padding on top + bottom = +20px
    color: const Color.fromARGB(255, 218, 218, 217), // 🌈 Add your desired color here
    
    child: Center(
      child: Column(
        children: [
          TextField(
            controller: topicController,
            decoration: const InputDecoration(
              labelText: 'Topic',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: messageController,
            decoration: const InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                 onPressed: () => publishMqttMessage(context),
                child: const Text('Publish'),
              ),
            ],
          ),

        ],
      ),
    ),
  );}
  
}