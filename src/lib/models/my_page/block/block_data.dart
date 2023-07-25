import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_data.freezed.dart';
part 'block_data.g.dart';

@freezed
class BlockData with _$BlockData {
  factory BlockData({
    String? nick,
    int? memberIdx,
    String? intro,
    String? profileImgUrl,
    int? isBadge,
  }) = _BlockData;

  factory BlockData.fromJson(Map<String, dynamic> json) =>
      _$BlockDataFromJson(json);
}
