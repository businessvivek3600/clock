import 'package:flutter/material.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key, this.data});
  final dynamic data;
  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      body: Center(
        child: Text('Page 1 - Alarm App ${widget.data}'),
      ),
    );
  }
}
