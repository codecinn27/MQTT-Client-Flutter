import 'package:flutter/material.dart';
import 'package:mqtt_led/services/mqttService.dart';

class MyApp extends StatelessWidget {
  
  final MqttService mqttService = MqttService('20.2.65.144','flutter_client');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('MQTT Flutter Example'),),
        body: Center(child: ElevatedButton(
          onPressed: () async{
            await mqttService.connect();
            mqttService.publish('test/topic', 'Hello Mqtt');
          },
          child: Text('Connect & Publish')),
          )
      ),
      
    );
  }
}