import 'dart:async';
import 'dart:io';
import 'package:chopper/src/response.dart';
import 'package:hub_config/src/business_logic/models/input_data.dart';

import 'package:hub_config/src/business_logic/utils/result.dart';


import '../../views/messenger.dart';
import '../models/hub.dart';
import '../utils/api_utils.dart';
import 'hub_repository.dart';
import 'hub_service.dart';

class HttpHubRepository implements HubRepository {
  final InputDataProvider inputDataProvider;

  HttpHubRepository(this.inputDataProvider);

  final _service = HubService.getInstance();

  HttpHubRepository._privateConstructor(this.inputDataProvider);

  static HttpHubRepository? _instance;

  static HttpHubRepository get instance {
    _instance ??= HttpHubRepository._privateConstructor(
      InputDataProviderImpl(),
    );
    return _instance!;
  }

  @override
  Future<Result> configureWifi(
      {required String wifiName, required String wifiPassword}) async {
    try {
      final inputData = inputDataProvider.getInputData();
      final response = await _service
          .configureWifi(wifiName, wifiPassword, inputData)
          .timeout(ApiUtils.timeOutDuration);
      if (response.isSuccessful) {
        return Result.success(data: null);
      }
      return Result.error(message: response.statusCode.toString());
    } on TimeoutException catch (e) {
      return Result.error(
          message: e.toString(), errorCode: ErrorCode.requestTimeout);
    } catch (e) {
      final result = await verifyConnection(destination: ApiUtils.hubAddress);
      if (result) {
        return Result.error(message: 'Did not connect the Hub To WiFi');
      } else {
        return Result.success(data: null);
      }
    }
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

  @override
  Future<Result<Hub>> findBySerialNumber(String serialNumber) async {
    try {
      final response = await _service
          .findBySerialNumber(
            serialNumber,
            // Session.instance.token,
          )
          .timeout(ApiUtils.timeOutDuration);
      return _analyzeFindHubResponse(response);
    } on TimeoutException catch (e) {
      return Result.error(
          message: e.toString(), errorCode: ErrorCode.requestTimeout);
    } on SocketException catch (e) {
      return Result.error(
          message: e.toString(), errorCode: ErrorCode.noInternet);
    } on Exception catch (e) {
      return Result.error(message: e.toString());
    }
  }

  Future<Result<Hub>> _analyzeFindHubResponse(
      Response<dynamic> response) async {
    switch (response.statusCode) {
      case 200:
        return Result.success(data: Hub.fromJson(response.body));
      case 404:
        return Result.error(errorCode: ErrorCode.noHub);
      default:
        return Result.error(message: response.statusCode.toString());
    }
  }

  @override
  Future<Result<void>> configure(Hub hub) async {
    try {
      final response = await _service
          .configureHub(
            hub.toJson(),
            //Session.instance.token,
          )
          .timeout(ApiUtils.timeOutDuration);
      return _analyzeConfigureHubResponse(response);
    } on TimeoutException catch (e) {
      return Result.error(
          message: e.toString(), errorCode: ErrorCode.requestTimeout);
    } on SocketException catch (e) {
      return Result.error(
          message: e.toString(), errorCode: ErrorCode.noInternet);
    } on Exception catch (e) {
      return Result.error(message: e.toString());
    }
  }

  Future<Result<void>> _analyzeConfigureHubResponse(
      Response<dynamic> response) async {
    switch (response.statusCode) {
      case 200:
        return Result.success(data: null);
      case 404:
        return Result.error(errorCode: ErrorCode.noHub);
      default:
        return Result.error(message: response.statusCode.toString());
    }
  }
}

class InputDataProviderImpl implements InputDataProvider{
  @override
  InputData getInputData() {
    return InputData(
        'abc123',
        '12345',
        '192.168.0.1',
        '13.38.208.129',
        1883,
        '/provision',
        'yk5xkafkvznfsunjnitv',
        '7i4dpjxu5cesacxwjw3v',
        'MQTT_BASIC',
        'successTopicValue',
        'v1/devices/me/telemetry',
        '',
        ''
    );
  }
}
