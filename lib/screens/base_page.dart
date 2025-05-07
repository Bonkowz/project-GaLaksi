import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// [BasePage] will act as a Parent of the following pages through a [BottomNavigationBar]:
///
class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: []),
      body: Center(child: Text("Find People Page")),
    );
  }
}
