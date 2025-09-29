import 'package:flutter/material.dart';



class VideocallView extends StatefulWidget {
  const VideocallView({super.key});

  @override
  State<VideocallView> createState() => _VideocallViewState();
}

class _VideocallViewState extends State<VideocallView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Videocall"),
      ),
    );
  }
}