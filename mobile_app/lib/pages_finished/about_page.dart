import 'package:flutter/material.dart';
import 'package:mobile_app/models/about_widgets/about_page_widget.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AboutPageWidget(
      pageController: _pageController,
      currentPage: _currentPage,
      onPageChanged: _onPageChanged,
    );
  }
}