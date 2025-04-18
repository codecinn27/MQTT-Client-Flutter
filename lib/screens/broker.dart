import 'package:flutter/material.dart';
import 'package:mqtt_led/providers/mqttService_provider.dart';
import 'package:mqtt_led/share/button.dart';
import 'package:mqtt_led/share/styled_text.dart';
import 'package:provider/provider.dart';

class BrokerScreen extends StatefulWidget {
  const BrokerScreen({super.key});

  @override
  State<BrokerScreen> createState() => _BrokerScreenState();
}

class _BrokerScreenState extends State<BrokerScreen> {

  final _brokerController = TextEditingController();
  final _portController = TextEditingController(); // Optional: Port support

  @override
  void dispose() {
    // clean up the controller when the widget is disposed
    _brokerController.dispose();
    _portController.dispose();
    super.dispose();
  } 


  void connectToBroker(String address) async {

    final mqtt = Provider.of<MQTTProvider>(context, listen: false);

    try {
      
      print("Trying to connect to broker at $address");
      await mqtt.connect(address);

      if (mqtt.isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connected to $address')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect')),
        );
      }    
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed: ${e.toString()}')),
      );// Optional: rethrow if you want calling code to handle the error
    }
  }
  


  @override
  Widget build(BuildContext context) {
    final brokerState = Provider.of<MQTTProvider>(context);
    final brokerAddress = brokerState.brokerAddress;
    final isConnected = brokerState.isConnected;

    return  Scaffold(
      appBar: AppBar(
        toolbarHeight: 120, // or any height that fits your content nicely
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const StyledHeading('MQTT Client'),
              if (brokerAddress?.isNotEmpty ?? false) ...[
                const SizedBox(height: 5),
                StyledTitle(brokerAddress!),
                if (isConnected) const StyledText("Connected"),
              ] else ...[
                const StyledText("Not connected"),
              ],
            ],
          )
        )    
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
                StyledTitle("Type Your Broker Address:"),
                TextField(
                  controller: _brokerController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.dns),
                    label:StyledText("Broker Address"),
                  ),
                ),

                const SizedBox(height:15),
                TextField(
                  controller: _portController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.live_tv_outlined),
                    label:StyledText("Port Number"),
                  ),
                ),
                const SizedBox(height: 15),
                GreyButton(text: "Submit", onPressed: (){

                  String brokerAddress = _brokerController.text.trim();
                  if(brokerAddress.isNotEmpty){
                    connectToBroker(brokerAddress);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a broker address")),
                    );
                  }

                })

            ],
          ),
        ),
      ),
    );
  }
}

