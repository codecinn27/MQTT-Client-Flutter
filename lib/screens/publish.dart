import 'package:flutter/material.dart';

class PublishScreen extends StatelessWidget {
  const PublishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Center(
            child:Column(
              children: [
                const SizedBox(height: 15),
                Text("testing"),
              ],
            ),
        ),
      ),
    );
  }
}