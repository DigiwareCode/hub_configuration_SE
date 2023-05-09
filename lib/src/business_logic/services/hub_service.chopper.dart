// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$HubService extends HubService {
  _$HubService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = HubService;

  @override
  Future<Response<dynamic>> configureWifi(
      String wifiName, String wifiPassword) {
    final $url = 'http://192.168.4.1/setting';
    final $params = <String, dynamic>{
      'ssid': wifiName,
      'password': wifiPassword,

    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);

    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> findBySerialNumber(
      String serialNumber, String token) {
    final $url = 'http://192.168.1.84:8080/api/v1/hub/${serialNumber}';
    /*
    final $headers = {
      'Authorization': token,
    };*/

    //final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    final $request = Request('GET', $url, client.baseUrl);

    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> configureHub(
      Map<String, dynamic> data, String token) {
    final $url = 'http://192.168.1.84:8080/api/v1/hub/configure';
    final $headers = {
      'Authorization': token,
    };

    final $body = data;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }
}
