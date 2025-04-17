import 'package:flutter/material.dart';
import 'package:mqtt_led/screens/broker.dart';
import 'package:mqtt_led/screens/connected.dart';
import 'package:mqtt_led/screens/publish.dart';
import 'package:mqtt_led/screens/subscribe.dart';

class BottomNavigationBar3 extends StatefulWidget {
  const BottomNavigationBar3({super.key});

  @override
  State<BottomNavigationBar3> createState() => _BottomNavigationBar3State();
}

class _BottomNavigationBar3State extends State<BottomNavigationBar3> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications_sharp),
            icon: Icon(Icons.notifications_outlined),
            label: 'Subcribe',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.message),
            icon: Icon(Icons.messenger_outline),
            label: 'Publish',
          ),
        ],
      ),
      body:
          <Widget>[
            /// Home page
            BrokerScreen(),
            Subscribe_screen(),
            PublishScreen()
          ][currentPageIndex],
    );
  }
}