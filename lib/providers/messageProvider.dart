import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => _messages;

  void addMessage(String topic, String message) {
    _messages.insert(0, {
      'title': topic,
      'subtitle': message,
    });
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
