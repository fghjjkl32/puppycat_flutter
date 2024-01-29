import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_cloud_message_payload.freezed.dart';
part 'firebase_cloud_message_payload.g.dart';

enum PushType {
  unknown,
  follow,
  new_contents,
  mention_contents,
  img_tag,
  like_contents,
  new_comment,
  mention_comment,
  new_reply,
  like_comment,
  notice,
  event,
}

@freezed
class FirebaseCloudMessagePayload with _$FirebaseCloudMessagePayload {
  factory FirebaseCloudMessagePayload({
    String? push_idx, //어드민
    String? title,
    required String body,
    required String type,
    @JsonKey(name: 'contents_type') String? contentsType,
    @JsonKey(name: 'contents_idx') required String contentsIdx,
    @JsonKey(name: 'imageUrl') required String image,
    @JsonKey(name: 'comment_idx') String? commentIdx,
  }) = _FirebaseCloudMessagePayload;

  factory FirebaseCloudMessagePayload.fromJson(Map<String, dynamic> json) => _$FirebaseCloudMessagePayloadFromJson(json);
}
