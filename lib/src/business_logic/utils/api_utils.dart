class ApiUtils {
  static const endPoint = 'http://192.168.1.84:8080';
  static const rootPath = '${endPoint}/api/v1';

  static const hubIP = '192.168.4.1';
  static const hubAddress = 'http://${hubIP}';
  static const hubWifiSettings = '$hubAddress/setting';

  static const timeOutDuration = Duration(seconds: 10);
}
