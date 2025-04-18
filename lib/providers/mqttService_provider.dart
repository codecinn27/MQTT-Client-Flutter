import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTProvider with ChangeNotifier {
  late MqttServerClient _client;
  bool _isConnected = false;
  String _brokerAddress = '';

  bool get isConnected => _isConnected;
  String get brokerAddress => _brokerAddress;

  Future<void> connect(String address, {int port = 1883}) async {
    _brokerAddress = address;
    _client = MqttServerClient(address, 'flutter_client');
    _client.port = port; // Now uses port
    _client.keepAlivePeriod = 20;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.logging(on: false);

    try {
      await _client.connect();
    } catch (e) {
      _client.disconnect();
    }
  }

  void onConnected() {
    print("Connected to broker");
    _isConnected = true;
    notifyListeners();

    // Immediately publish to topic `test`
    publish('test', 'successful connection');
  }

  void onDisconnected() {
    print("Disconnected from broker");
    _isConnected = false;
    notifyListeners();
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

}