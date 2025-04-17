import 'package:flutter/material.dart';
import 'package:mqtt_led/share/button.dart';
import 'package:mqtt_led/share/styled_text.dart';
import 'package:mqtt_led/services/mqttService.dart';

class BrokerScreen extends StatefulWidget {
  const BrokerScreen({super.key});

  @override
  State<BrokerScreen> createState() => _BrokerScreenState();
}

class _BrokerScreenState extends State<BrokerScreen> {

  final _brokerController = TextEditingController();
  final _portController = TextEditingController(); // Optional: Port support

  String? _connectedBroker; // stores the broker address when connected

  @override
  void dispose() {
    // clean up the controller when the widget is disposed
    _brokerController.dispose();
    _portController.dispose();
    super.dispose();
  } 


  void connectToBroker(String address){

    final MqttService mqttService = MqttService(address,'flutter_client');
    // Optional: Show a snackbar or print to debug
    print("Trying to connect to broker at $address");

    // You might want to save the service or call connect here
    mqttService.connect();
    setState(() {
      _connectedBroker = address;
    });
  }
  


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        toolbarHeight: 120, // or any height that fits your content nicely
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const StyledHeading('MQTT Client'),
              if(_connectedBroker != null)...[
                const SizedBox(height: 5),
                StyledHeading(_connectedBroker!),
                const StyledText("Connected"),
              ]
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

