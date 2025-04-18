import 'package:flutter/material.dart';
import 'package:mqtt_led/providers/messageProvider.dart';
// import 'package:mqtt_led/providers/broker_provider.dart';
import 'package:mqtt_led/providers/mqttService_provider.dart';
import 'package:mqtt_led/widget/bottom_navigation_bar3.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MQTTProvider()),
      ChangeNotifierProvider(create: (_) => MessageProvider()),
    ],
    child: MaterialApp(
          home: BottomNavigationBar3(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
        )
    ),
  );
}
