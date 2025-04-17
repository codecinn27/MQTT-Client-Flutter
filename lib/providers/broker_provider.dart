import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
 String _brokerAddress = '';
 int? _portNumber; // Use int? for nullable integer
 bool _isConnected = false; // Add connection status flag
  

 String get brokerAddress => _brokerAddress;
 int? get portNumber => _portNumber;
 bool get isConnected => _isConnected; // Getter for connection status

 void setBrokerAddress(String address) {
   _brokerAddress = address;
   notifyListeners();
 }

 void setPortNumber(int no){
  _portNumber = no;
  notifyListeners();
 }

   // Add methods to manage connection status
  void connect() {
    _isConnected = true;
    notifyListeners();
  }

  void disconnect() {
    _isConnected = false;
    notifyListeners();
  }

  // Optional: Combined method
  void setConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }
}
