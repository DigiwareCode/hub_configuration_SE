import 'package:json_annotation/json_annotation.dart';
import 'dart:core';
part 'input_data.g.dart';

@JsonSerializable()
class InputData {
  late String clientID;
  late String hubSerialNumber;
  late String hubIP;

  late String broker;

  late int port;
  late String provisionTopic;
  late String provisionDeviceKey;
  late String provisionDeviceSecret;

  late String credentialsType;

  late String successTopic;
  late String dataTopic;

  late String ssid;
  late String password;

  InputData(
      this.clientID,
      this.hubSerialNumber,
      this.hubIP,
      this.broker,
      this.port,
      this.provisionTopic,
      this.provisionDeviceKey,
      this.provisionDeviceSecret,
      this.credentialsType,
      this.successTopic,
      this.dataTopic,
      this.ssid,
      this.password);

  InputData.myInput();

  factory InputData.fromJson(Map<String, dynamic> json) => _$InputDataFromJson(json);
  Map<String, dynamic> toJson() => _$InputDataToJson(this);



}

abstract class InputDataProvider {
  InputData getInputData();
}
