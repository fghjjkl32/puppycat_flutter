import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_item.freezed.dart';
part 'location_item.g.dart';

@freezed
class LocationItem with _$LocationItem {
  factory LocationItem({
    required String name,
    required String subName,
  }) = _LocationItem;

  factory LocationItem.fromJson(Map<String, dynamic> json) =>
      _$LocationItemFromJson(json);
}
