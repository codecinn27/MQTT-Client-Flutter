//old version material 2 version

import 'package:flutter/material.dart';
import 'package:mqtt_led/screens/broker.dart';
import 'package:mqtt_led/screens/connected.dart';
import 'package:mqtt_led/screens/publish.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<MainNavigation> {

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BrokerScreen(),
    MyApp(),
    const PublishScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items:const [
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Broker'),
          BottomNavigationBarItem(icon: Icon(Icons.subject), label: 'Subscribe'),
          BottomNavigationBarItem(icon: Icon(Icons.wifi_tethering), label: 'Publish'),

        ],
      ),
    );
  }
}