import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

part 'hub.g.dart';

@JsonSerializable()
class Hub {
  String id;
  String serialNumber;
  bool configured;

  Hub({
    this.id = '',
    this.serialNumber = '',
    this.configured = false,
  });

  factory Hub.fromJson(Map<String, dynamic> json) => _$HubFromJson(json);

  Map<String, dynamic> toJson() => _$HubToJson(this);

  @override
  String toString() {
    return 'Hub{id: $id, serialNumber: $serialNumber,'
        'configured: $configured}';
  }
}
