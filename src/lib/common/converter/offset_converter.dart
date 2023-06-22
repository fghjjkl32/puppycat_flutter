import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class OffsetConverter implements JsonConverter<Offset, Map<String, double>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, double> json) {
    return Offset(json['dx']!, json['dy']!);
  }

  @override
  Map<String, double> toJson(Offset offset) {
    return {'dx': offset.dx, 'dy': offset.dy};
  }
}
