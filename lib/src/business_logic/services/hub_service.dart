import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:hub_config/src/business_logic/utils/api_utils.dart';

part 'hub_service.chopper.dart';

@ChopperApi()
abstract class HubService extends ChopperService {
  static HubService? _instance;

  @Put(path: '${ApiUtils.endPoint}/hub/configure')
  Future<Response> configureHub(
    @Body() Map<String, dynamic> data,
    @Header('Authorization') String token,
  );

  @Get(path: '${ApiUtils.endPoint}/hub/{serialNumber}', optionalBody: true)
  Future<Response> findBySerialNumber(
    @Path('serialNumber') String serialNumber,
    @Header('Authorization') String token,
  );

  @Get(path: '${ApiUtils.hubAddress}/setting', optionalBody: true)
  Future<Response> configureWifi(
      @Query('ssid') String wifiName,
      @Query('password') String wifiPassword,
      );

  static HubService getInstance() {
    if (_instance == null) {
      final client = ChopperClient(
          interceptors: [HttpLoggingInterceptor()],
          converter: const JsonConverter(),
          errorConverter: const JsonConverter(),
          services: [
            _$HubService(),
          ]);

      _instance = _$HubService(client);
    }

    return _instance!;
  }
}
