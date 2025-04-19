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


  void connectToBroker(String address, String portText) async {

    final mqtt = Provider.of<MQTTProvider>(context, listen: false);

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❗ Please enter a broker address")),
      );
      return;
    }

    int? port = int.tryParse(portText);
    if (port == null || port < 0 || port > 65535) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❗ Invalid port number (0–65535)")),
      );
      return;
    }

    try {
      int port = int.tryParse(portText) ?? 1883; // default to 1883 if parsing fails
      print("Trying to connect to broker at $address");
      await mqtt.connect(address, port: port);

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
      String errorMsg = e.toString();

      if (errorMsg.contains("SocketException") ||
          errorMsg.contains("Connection refused") ||
          errorMsg.contains("No route to host") ||
          errorMsg.contains("Failed host lookup")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '❌ Could not connect. Please check broker address or port number.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Connection failed: $errorMsg')),
        );
      }
    }
  }

  void disconnectToBroker() async {
    final mqtt = Provider.of<MQTTProvider>(context, listen: false);
    try{
      if (mqtt.isConnected) {
        mqtt.disconnect();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Disconnected from broker")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Not connected")),
        );
      }

    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Disconnect failed: ${e.toString()}')),
      );
    };
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
                StyledText(isConnected ? "Connected" : "Disconnected")
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Pushes content to the right
                  children: [
                    GreyButton(text: "Disconnect", onPressed: (){disconnectToBroker();}),
                    const SizedBox(width: 10),
                    GreyButton(text: "Connect", onPressed: (){
                    
                      String brokerAddress = _brokerController.text.trim();
                      String port = _portController.text.trim();
                      if(brokerAddress.isNotEmpty){
                        connectToBroker(brokerAddress, port);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a broker address")),
                        );
                      }
                    
                    }),
                  ],
                )

            ],
          ),
        ),
      ),
    );
  }
}

