// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firebase_cloud_message_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirebaseCloudMessagePayload _$FirebaseCloudMessagePayloadFromJson(
    Map<String, dynamic> json) {
  return _FirebaseCloudMessagePayload.fromJson(json);
}

/// @nodoc
mixin _$FirebaseCloudMessagePayload {
  @JsonKey(name: 'url')
  String get url => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get content_id => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirebaseCloudMessagePayloadCopyWith<FirebaseCloudMessagePayload>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirebaseCloudMessagePayloadCopyWith<$Res> {
  factory $FirebaseCloudMessagePayloadCopyWith(
          FirebaseCloudMessagePayload value,
          $Res Function(FirebaseCloudMessagePayload) then) =
      _$FirebaseCloudMessagePayloadCopyWithImpl<$Res,
          FirebaseCloudMessagePayload>;
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      String? body,
      String? title,
      String? type,
      String? content_id,
      String? image});
}

/// @nodoc
class _$FirebaseCloudMessagePayloadCopyWithImpl<$Res,
        $Val extends FirebaseCloudMessagePayload>
    implements $FirebaseCloudMessagePayloadCopyWith<$Res> {
  _$FirebaseCloudMessagePayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? body = freezed,
    Object? title = freezed,
    Object? type = freezed,
    Object? content_id = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      content_id: freezed == content_id
          ? _value.content_id
          : content_id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirebaseCloudMessagePayloadCopyWith<$Res>
    implements $FirebaseCloudMessagePayloadCopyWith<$Res> {
  factory _$$_FirebaseCloudMessagePayloadCopyWith(
          _$_FirebaseCloudMessagePayload value,
          $Res Function(_$_FirebaseCloudMessagePayload) then) =
      __$$_FirebaseCloudMessagePayloadCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'url') String url,
      String? body,
      String? title,
      String? type,
      String? content_id,
      String? image});
}

/// @nodoc
class __$$_FirebaseCloudMessagePayloadCopyWithImpl<$Res>
    extends _$FirebaseCloudMessagePayloadCopyWithImpl<$Res,
        _$_FirebaseCloudMessagePayload>
    implements _$$_FirebaseCloudMessagePayloadCopyWith<$Res> {
  __$$_FirebaseCloudMessagePayloadCopyWithImpl(
      _$_FirebaseCloudMessagePayload _value,
      $Res Function(_$_FirebaseCloudMessagePayload) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? body = freezed,
    Object? title = freezed,
    Object? type = freezed,
    Object? content_id = freezed,
    Object? image = freezed,
  }) {
    return _then(_$_FirebaseCloudMessagePayload(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      content_id: freezed == content_id
          ? _value.content_id
          : content_id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FirebaseCloudMessagePayload implements _FirebaseCloudMessagePayload {
  _$_FirebaseCloudMessagePayload(
      {@JsonKey(name: 'url') required this.url,
      required this.body,
      required this.title,
      required this.type,
      required this.content_id,
      required this.image});

  factory _$_FirebaseCloudMessagePayload.fromJson(Map<String, dynamic> json) =>
      _$$_FirebaseCloudMessagePayloadFromJson(json);

  @override
  @JsonKey(name: 'url')
  final String url;
  @override
  final String? body;
  @override
  final String? title;
  @override
  final String? type;
  @override
  final String? content_id;
  @override
  final String? image;

  @override
  String toString() {
    return 'FirebaseCloudMessagePayload(url: $url, body: $body, title: $title, type: $type, content_id: $content_id, image: $image)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirebaseCloudMessagePayload &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content_id, content_id) ||
                other.content_id == content_id) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, url, body, title, type, content_id, image);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirebaseCloudMessagePayloadCopyWith<_$_FirebaseCloudMessagePayload>
      get copyWith => __$$_FirebaseCloudMessagePayloadCopyWithImpl<
          _$_FirebaseCloudMessagePayload>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirebaseCloudMessagePayloadToJson(
      this,
    );
  }
}

abstract class _FirebaseCloudMessagePayload
    implements FirebaseCloudMessagePayload {
  factory _FirebaseCloudMessagePayload(
      {@JsonKey(name: 'url') required final String url,
      required final String? body,
      required final String? title,
      required final String? type,
      required final String? content_id,
      required final String? image}) = _$_FirebaseCloudMessagePayload;

  factory _FirebaseCloudMessagePayload.fromJson(Map<String, dynamic> json) =
      _$_FirebaseCloudMessagePayload.fromJson;

  @override
  @JsonKey(name: 'url')
  String get url;
  @override
  String? get body;
  @override
  String? get title;
  @override
  String? get type;
  @override
  String? get content_id;
  @override
  String? get image;
  @override
  @JsonKey(ignore: true)
  _$$_FirebaseCloudMessagePayloadCopyWith<_$_FirebaseCloudMessagePayload>
      get copyWith => throw _privateConstructorUsedError;
}
