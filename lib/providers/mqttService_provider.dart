import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_led/providers/messageProvider.dart';

class MQTTProvider with ChangeNotifier {
  late MqttServerClient _client;
  bool _isConnected = false;
  String _brokerAddress = '';

  bool get isConnected => _isConnected;
  String get brokerAddress => _brokerAddress;

  // to received message
  Function(String, String)? _onMessageReceived;

  // 🧠 Register message callback
  void setOnMessageReceived(Function(String topic, String message) callback) {
    _onMessageReceived = callback;
  }


  Future<void> connect(String address, {int port = 1883}) async {
    _brokerAddress = address;
     _client = MqttServerClient(address, 'flutter_client_${DateTime.now().millisecondsSinceEpoch}');
    _client.port = port; // Now uses port
    _client.keepAlivePeriod = 20;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onSubscribed = (topic) {
      print('✅ Subscribed to topic: $topic');
    };
    _client.logging(on: true);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atMostOnce); // QoS 0
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
      print('✅ MQTT Connected');

      // 🧠 Only after connection
      _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      for (final message in event) {
          _onMessage(message);
        }
      });

      _isConnected = true;
      notifyListeners();
    } catch (e) {
      print('❌ MQTT Connection failed: $e');
      _client.disconnect();
    }
  }

  void onConnected() {
    print("✅ Connected to broker");
    _isConnected = true;
    notifyListeners();

    // Immediately publish to topic `test`
    publish('test', 'successful connection');
  }

  void onDisconnected() {
    print("❌ Disconnected from broker");
    _isConnected = false;
    notifyListeners();
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print("📤 Published: '$message' to topic '$topic'");
  }

  // ✅ New subscribe function
  void subscribe(String topic) {
    _client.subscribe(topic, MqttQos.atMostOnce); // QoS 0
    print("📡 Subscribing to topic: $topic");
  }

  late MessageProvider messageProvider;

  void attachMessageProvider(MessageProvider provider) {
    messageProvider = provider;
  }

  // ✅ Internal handler for incoming messages
  void _onMessage(MqttReceivedMessage<MqttMessage> event) {
    final topic = event.topic;
    final payloadMessage = event.payload as MqttPublishMessage;

    // Correct way to decode the payload
    final payloadString = MqttPublishPayload.bytesToStringAsString(payloadMessage.payload.message);

    print('📥 Message received: [$topic] Payload: $payloadString');

    // Save to provider
    messageProvider.addMessage(topic, payloadString);

    // Optional: call additional callback if needed
    _onMessageReceived?.call(topic, payloadString);
  }

}