import 'package:flutter/material.dart';
import 'package:mobile_app/models/home_widgets/home_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return HomePageWidget();
  }
}
