import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/common/converter/offset_converter.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

@freezed
class Tag with _$Tag {
  @OffsetConverter()
  factory Tag({
    required String username,
    required String memberUuid,
    required Offset position,
    required int imageIndex,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
