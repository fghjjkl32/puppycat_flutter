// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_cloud_message_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FirebaseCloudMessagePayload _$$_FirebaseCloudMessagePayloadFromJson(
        Map<String, dynamic> json) =>
    _$_FirebaseCloudMessagePayload(
      url: json['url'] as String,
      body: json['body'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      content_id: json['content_id'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$_FirebaseCloudMessagePayloadToJson(
        _$_FirebaseCloudMessagePayload instance) =>
    <String, dynamic>{
      'url': instance.url,
      'body': instance.body,
      'title': instance.title,
      'type': instance.type,
      'content_id': instance.content_id,
      'image': instance.image,
    };
