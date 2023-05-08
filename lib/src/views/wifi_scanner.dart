import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

Future<List<String>> loadWiFiNetworks() async {
  final result = await WiFiScan.instance.getScannedResults();
  if (!result.hasError) {
    final value = result.value;
    if (value != null) {
      final wifiNames = <String>[];
      for (var element in value) {
        wifiNames.add(element.ssid);
      }

      return wifiNames;
    }
  }
  return [];
}

Future<bool> requestLocationPermission() async {
  final status = await Permission.location.status;
  if (!status.isGranted) {
    final permission = await Permission.location.request();

    if (permission.isDenied) return false;
  }

  try {
    final locationServiceStatus =
        await Permission.locationWhenInUse.serviceStatus;
    if (locationServiceStatus.isDisabled) {
      await Geolocator.getCurrentPosition();
    }
    return true;
  } catch (e) {
    return false;
  }
}
