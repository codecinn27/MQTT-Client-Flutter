import 'package:flutter/material.dart';
// import 'package:mqtt_led/providers/broker_provider.dart';
import 'package:mqtt_led/providers/mqttService_provider.dart';
import 'package:mqtt_led/widget/bottom_navigation_bar3.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context)=>MQTTProvider(),
      child: MaterialApp(
          home: BottomNavigationBar3(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
        )
    ),  
  );
}
