import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/common/converter/offset_converter.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag.dart';

part 'tag_images.freezed.dart';
part 'tag_images.g.dart';

@freezed
class TagImages with _$TagImages {
  @OffsetConverter()
  factory TagImages({
    required int index,
    required List<Tag> tag,
  }) = _TagImages;

  factory TagImages.fromJson(Map<String, dynamic> json) => _$TagImagesFromJson(json);
}
