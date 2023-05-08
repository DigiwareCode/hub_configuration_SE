import 'package:flutter/material.dart';

import '../provider_manager/app_state_manager.dart';
import '../provider_manager/hub_manager.dart';
import '../views/hub_connection_screen.dart';
import '../views/scan_wifi_screen.dart';
import '../views/serial_number_scan_screen.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final HubManager hubSettingManager;

  AppRouter({
    required this.appStateManager,
    required this.hubSettingManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    hubSettingManager.addListener(notifyListeners);
  }

  List<Page<dynamic>> _getPages() {
    final pages = <Page>[];

    if (!appStateManager.isInitialized) {
      pages.add(const MaterialPage(
          child: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
        ),
      )));

    } else if (hubSettingManager.onScanSerialNumber) {
      pages.add(SerialNumberScanScreen.page());
    } else if (hubSettingManager.onOpenWifiSetting) {
      pages.add(HubConnectionScreen.page());
    } else if (hubSettingManager.onScanNeighborWifi) {
      pages.add(ScanWifiScreen.page());
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _getPages(),
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    return;
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    hubSettingManager.removeListener(notifyListeners);
    super.dispose();
  }

  bool _onPopPage(Route<dynamic> route, result) {
    return true;
  }
}
