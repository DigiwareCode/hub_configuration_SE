// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hub _$HubFromJson(Map<String, dynamic> json) => Hub(
      id: json['id'] as String? ?? '',
      serialNumber: json['serialNumber'] as String? ?? '',
      configured: json['configured'] as bool? ?? false,
    );

Map<String, dynamic> _$HubToJson(Hub instance) => <String, dynamic>{
      'id': instance.id,
      'serialNumber': instance.serialNumber,
      'configured': instance.configured,
    };
