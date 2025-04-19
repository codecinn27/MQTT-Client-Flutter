import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  final List<String> _subscribedTopics = [];

  List<Map<String, String>> get messages => _messages;
  List<String> get subscribedTopics => _subscribedTopics;

  void addMessage(String topic, String message) {
    _messages.insert(0, {
      'title': topic,
      'subtitle': message,
    });
    notifyListeners();
  }

  void addSubscribedTopic(String topic) {
    if (!_subscribedTopics.contains(topic)) {
      _subscribedTopics.add(topic);
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
