import 'dart:async';

import 'package:flutter/material.dart';

import 'hub_manager.dart';

class AppStateManager extends ChangeNotifier {
  int _selectedTab = 0;
  bool _isInitialized = false;

  int get selectedTab => _selectedTab;

  bool get isInitialized => _isInitialized;

  final HubManager _hubManager;

  AppStateManager(
    this._hubManager,
  ) {}

  void reset() {
    _selectedTab = 0;
    _hubManager.reset();
  }

  Future<void> init() async {
    await initHubData();
    initializationDone();
  }

  Future<void> initHubData() async {
    await _hubManager.init();
  }

  void goToTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void goToHomePage() {
    _selectedTab = 0;
  }

  void goToDashboard() {
    goToTab(1);
  }

  void goToHome() {
    goToTab(0);
  }

  void initializationDone() {
    _isInitialized = true;
    notifyListeners();
  }
}
