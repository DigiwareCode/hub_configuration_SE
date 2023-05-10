import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hub_config/src/business_logic/services/hub_repository.dart';

import '../business_logic/models/session.dart';
import '../business_logic/utils/result.dart';
import '../views/wifi_scanner.dart';

class HubManager with ChangeNotifier {
  final HubRepository _hubRepository;

  HubManager(this._hubRepository);

  bool _onScanSerialNumber = false;
  bool _onOpenWifiSetting = false;
  bool _onScanNeighborWifi = false;
  bool _onSetHubWifi = false;

  String get wifiSSID => _wifiSSID;

  String _wifiSSID = '';

  bool get onScanSerialNumber => _onScanSerialNumber;

  bool get onScanNeighborWifi => _onScanNeighborWifi;

  bool get onOpenWifiSetting => _onOpenWifiSetting;

  bool get onSetHubWifi => _onSetHubWifi;

  Future<void> init() async {
    final hubSerialNumber = Session.instance.hubSerialNumber;
    if (hubSerialNumber.isEmpty) {
      _onScanSerialNumber = true;
    } else {
      final response = await _hubRepository.findBySerialNumber(hubSerialNumber);
      if (!response.isSuccessful()) return;
    }
  }

  void reset() {
    _onScanSerialNumber = false;
    _onOpenWifiSetting = false;
    _onScanNeighborWifi = false;
  }

  void scanSerialNumber() {
    _onScanSerialNumber = true;
    notifyListeners();
  }

  Future<Result<List<String>>> scanAvailableNetworks() async {
    final permissionGranted = await requestLocationPermission();
    if (permissionGranted) {
      final result = await loadWiFiNetworks();

      final networkSSIDs = <String>[];
      result.forEach((element) {
        if (!element.toString().startsWith('SenergyM')) {
          networkSSIDs.add(element.toString());
        }
      });
      return Result.success(data: networkSSIDs);
    } else {
      return Result.error(message: 'Permission not granted');
    }
  }

  void hasConnectedToHub() {
    _onOpenWifiSetting = false;
    _onScanNeighborWifi = true;
    notifyListeners();
  }

  void configureHubWifi() {
    _onOpenWifiSetting = true;
    notifyListeners();
  }

  void quitScanWifi() {
    _onScanNeighborWifi = false;
    notifyListeners();
  }

  void quitHubWifiSetting() {
    _onSetHubWifi = false;
    _onScanNeighborWifi = true;
    notifyListeners();
  }

  void quitSerialNumberScan() {
    _onScanSerialNumber = false;
    notifyListeners();
  }

  void quitHubConnection() {
    _onOpenWifiSetting = false;
    notifyListeners();
  }

  void enterWifiPassword(String ssid) {
    _wifiSSID = ssid;
    _onScanNeighborWifi = false;
    _onSetHubWifi = true;
    notifyListeners();
  }

  Future<bool> verifyConnection({String destination = 'google.com'}) async {
    try {
      final result = await InternetAddress.lookup(destination);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException {
      return false;
    }
  }

  Future<Result> connectHub(String ssid, String password) async {
    final result = await _hubRepository.configureWifi(
        wifiName: ssid, wifiPassword: password);

    if (result.isSuccessful()) {
      Timer.periodic(const Duration(milliseconds: 10), (timer) async {
        final isConnectedToInternet = await verifyConnection();

        if (isConnectedToInternet) {
          _onSetHubWifi = false;
          notifyListeners();
          timer.cancel();
        }
      });
    }
    return result;
  }
}
