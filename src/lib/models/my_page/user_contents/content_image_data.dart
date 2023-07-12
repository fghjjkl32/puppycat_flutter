import 'package:freezed_annotation/freezed_annotation.dart';
part 'content_image_data.freezed.dart';
part 'content_image_data.g.dart';

@freezed
class ContentImageData with _$ContentImageData {
  const factory ContentImageData({
    required String imgUrl,
    required int idx,
    int? commentCnt,
    int? likeCnt,
    required int imageCnt,
  }) = _ContentImageData;

  factory ContentImageData.fromJson(Map<String, dynamic> json) =>
      _$ContentImageDataFromJson(json);
}
