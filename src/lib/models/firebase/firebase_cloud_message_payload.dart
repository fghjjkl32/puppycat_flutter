import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_cloud_message_payload.freezed.dart';
part 'firebase_cloud_message_payload.g.dart';

@freezed
class FirebaseCloudMessagePayload with _$FirebaseCloudMessagePayload{
  factory FirebaseCloudMessagePayload({
    @JsonKey(name: 'url')
    required String url,
    required String? body,
    required String? title,
    required String? type,
    required String? content_id,
    required String? image,
  }) = _FirebaseCloudMessagePayload;

  factory FirebaseCloudMessagePayload.fromJson(Map<String, dynamic> json) =>
      _$FirebaseCloudMessagePayloadFromJson(json);
}