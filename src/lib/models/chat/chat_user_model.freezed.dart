// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatUserModel _$ChatUserModelFromJson(Map<String, dynamic> json) {
  return _ChatUserModel.fromJson(json);
}

/// @nodoc
mixin _$ChatUserModel {
  @JsonKey(name: 'user_id')
  String? get chatMemberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_token')
  String? get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'home_server')
  String? get homeServer => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_id')
  String? get deviceId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatUserModelCopyWith<ChatUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatUserModelCopyWith<$Res> {
  factory $ChatUserModelCopyWith(
          ChatUserModel value, $Res Function(ChatUserModel) then) =
      _$ChatUserModelCopyWithImpl<$Res, ChatUserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String? chatMemberId,
      @JsonKey(name: 'access_token') String? accessToken,
      @JsonKey(name: 'home_server') String? homeServer,
      @JsonKey(name: 'device_id') String? deviceId});
}

/// @nodoc
class _$ChatUserModelCopyWithImpl<$Res, $Val extends ChatUserModel>
    implements $ChatUserModelCopyWith<$Res> {
  _$ChatUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatMemberId = freezed,
    Object? accessToken = freezed,
    Object? homeServer = freezed,
    Object? deviceId = freezed,
  }) {
    return _then(_value.copyWith(
      chatMemberId: freezed == chatMemberId
          ? _value.chatMemberId
          : chatMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      homeServer: freezed == homeServer
          ? _value.homeServer
          : homeServer // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatUserModelCopyWith<$Res>
    implements $ChatUserModelCopyWith<$Res> {
  factory _$$_ChatUserModelCopyWith(
          _$_ChatUserModel value, $Res Function(_$_ChatUserModel) then) =
      __$$_ChatUserModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String? chatMemberId,
      @JsonKey(name: 'access_token') String? accessToken,
      @JsonKey(name: 'home_server') String? homeServer,
      @JsonKey(name: 'device_id') String? deviceId});
}

/// @nodoc
class __$$_ChatUserModelCopyWithImpl<$Res>
    extends _$ChatUserModelCopyWithImpl<$Res, _$_ChatUserModel>
    implements _$$_ChatUserModelCopyWith<$Res> {
  __$$_ChatUserModelCopyWithImpl(
      _$_ChatUserModel _value, $Res Function(_$_ChatUserModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatMemberId = freezed,
    Object? accessToken = freezed,
    Object? homeServer = freezed,
    Object? deviceId = freezed,
  }) {
    return _then(_$_ChatUserModel(
      chatMemberId: freezed == chatMemberId
          ? _value.chatMemberId
          : chatMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      homeServer: freezed == homeServer
          ? _value.homeServer
          : homeServer // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatUserModel implements _ChatUserModel {
  _$_ChatUserModel(
      {@JsonKey(name: 'user_id') this.chatMemberId,
      @JsonKey(name: 'access_token') this.accessToken,
      @JsonKey(name: 'home_server') this.homeServer,
      @JsonKey(name: 'device_id') this.deviceId});

  factory _$_ChatUserModel.fromJson(Map<String, dynamic> json) =>
      _$$_ChatUserModelFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String? chatMemberId;
  @override
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @override
  @JsonKey(name: 'home_server')
  final String? homeServer;
  @override
  @JsonKey(name: 'device_id')
  final String? deviceId;

  @override
  String toString() {
    return 'ChatUserModel(chatMemberId: $chatMemberId, accessToken: $accessToken, homeServer: $homeServer, deviceId: $deviceId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatUserModel &&
            (identical(other.chatMemberId, chatMemberId) ||
                other.chatMemberId == chatMemberId) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.homeServer, homeServer) ||
                other.homeServer == homeServer) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, chatMemberId, accessToken, homeServer, deviceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatUserModelCopyWith<_$_ChatUserModel> get copyWith =>
      __$$_ChatUserModelCopyWithImpl<_$_ChatUserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatUserModelToJson(
      this,
    );
  }
}

abstract class _ChatUserModel implements ChatUserModel {
  factory _ChatUserModel(
      {@JsonKey(name: 'user_id') final String? chatMemberId,
      @JsonKey(name: 'access_token') final String? accessToken,
      @JsonKey(name: 'home_server') final String? homeServer,
      @JsonKey(name: 'device_id') final String? deviceId}) = _$_ChatUserModel;

  factory _ChatUserModel.fromJson(Map<String, dynamic> json) =
      _$_ChatUserModel.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String? get chatMemberId;
  @override
  @JsonKey(name: 'access_token')
  String? get accessToken;
  @override
  @JsonKey(name: 'home_server')
  String? get homeServer;
  @override
  @JsonKey(name: 'device_id')
  String? get deviceId;
  @override
  @JsonKey(ignore: true)
  _$$_ChatUserModelCopyWith<_$_ChatUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}
