import 'package:flutter/material.dart';

class SubcribeMessage extends StatelessWidget {
  const SubcribeMessage({
    super.key,
    required this.title,
    required this.subtitle,
    });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          
          leading: Icon(Icons.notifications_sharp),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      );
  }
}