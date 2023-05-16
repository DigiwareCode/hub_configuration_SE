// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputData _$InputDataFromJson(Map<String, dynamic> json) => InputData(
      json['clientID'] as String,
      json['hubSerialNumber'] as String,
      json['hubIP'] as String,
      json['broker'] as String,
      json['port'] as int,
      json['provisionTopic'] as String,
      json['provisionDeviceKey'] as String,
      json['provisionDeviceSecret'] as String,
      json['credentialsType'] as String,
      json['successTopic'] as String,
      json['dataTopic'] as String,
      json['ssid'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$InputDataToJson(InputData instance) => <String, dynamic>{
      'clientID': instance.clientID,
      'hubSerialNumber': instance.hubSerialNumber,
      'hubIP': instance.hubIP,
      'broker': instance.broker,
      'port': instance.port,
      'provisionTopic': instance.provisionTopic,
      'provisionDeviceKey': instance.provisionDeviceKey,
      'provisionDeviceSecret': instance.provisionDeviceSecret,
      'credentialsType': instance.credentialsType,
      'successTopic': instance.successTopic,
      'dataTopic': instance.dataTopic,
      'ssid': instance.ssid,
      'password': instance.password,
    };
