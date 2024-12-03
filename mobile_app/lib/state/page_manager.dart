import 'package:flutter/material.dart';
import 'package:mobile_app/models/toasts/predefined_toast.dart';
import 'package:mobile_app/pages_finished/home_page.dart';

class PageManager {
  final List<Widget> _pageStack = [const HomePage()];
  Widget get currentPage => _pageStack.last;
  bool isCameraPage = false;

  void updatePage(Widget page) {
    _pageStack.add(page);
  }

  void goBack() {
    if (_pageStack.length > 1) {
      _pageStack.removeLast();
    } else {
      PredefinedToast.showToast("There's nowhere to go back!", ToastType.error);
    }
  }

  void toggleCameraPage() {
    isCameraPage = !isCameraPage;
  }
}
