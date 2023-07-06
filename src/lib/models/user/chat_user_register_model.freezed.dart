// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_user_register_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatUserRegisterModel _$ChatUserRegisterModelFromJson(
    Map<String, dynamic> json) {
  return _ChatUserRegisterModel.fromJson(json);
}

/// @nodoc
mixin _$ChatUserRegisterModel {
  String? get chatMemberId => throw _privateConstructorUsedError;
  String? get homeServer => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatUserRegisterModelCopyWith<ChatUserRegisterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatUserRegisterModelCopyWith<$Res> {
  factory $ChatUserRegisterModelCopyWith(ChatUserRegisterModel value,
          $Res Function(ChatUserRegisterModel) then) =
      _$ChatUserRegisterModelCopyWithImpl<$Res, ChatUserRegisterModel>;
  @useResult
  $Res call(
      {String? chatMemberId,
      String? homeServer,
      String? accessToken,
      String? deviceId});
}

/// @nodoc
class _$ChatUserRegisterModelCopyWithImpl<$Res,
        $Val extends ChatUserRegisterModel>
    implements $ChatUserRegisterModelCopyWith<$Res> {
  _$ChatUserRegisterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatMemberId = freezed,
    Object? homeServer = freezed,
    Object? accessToken = freezed,
    Object? deviceId = freezed,
  }) {
    return _then(_value.copyWith(
      chatMemberId: freezed == chatMemberId
          ? _value.chatMemberId
          : chatMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      homeServer: freezed == homeServer
          ? _value.homeServer
          : homeServer // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatUserRegisterModelCopyWith<$Res>
    implements $ChatUserRegisterModelCopyWith<$Res> {
  factory _$$_ChatUserRegisterModelCopyWith(_$_ChatUserRegisterModel value,
          $Res Function(_$_ChatUserRegisterModel) then) =
      __$$_ChatUserRegisterModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? chatMemberId,
      String? homeServer,
      String? accessToken,
      String? deviceId});
}

/// @nodoc
class __$$_ChatUserRegisterModelCopyWithImpl<$Res>
    extends _$ChatUserRegisterModelCopyWithImpl<$Res, _$_ChatUserRegisterModel>
    implements _$$_ChatUserRegisterModelCopyWith<$Res> {
  __$$_ChatUserRegisterModelCopyWithImpl(_$_ChatUserRegisterModel _value,
      $Res Function(_$_ChatUserRegisterModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatMemberId = freezed,
    Object? homeServer = freezed,
    Object? accessToken = freezed,
    Object? deviceId = freezed,
  }) {
    return _then(_$_ChatUserRegisterModel(
      chatMemberId: freezed == chatMemberId
          ? _value.chatMemberId
          : chatMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      homeServer: freezed == homeServer
          ? _value.homeServer
          : homeServer // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
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
class _$_ChatUserRegisterModel implements _ChatUserRegisterModel {
  _$_ChatUserRegisterModel(
      {this.chatMemberId, this.homeServer, this.accessToken, this.deviceId});

  factory _$_ChatUserRegisterModel.fromJson(Map<String, dynamic> json) =>
      _$$_ChatUserRegisterModelFromJson(json);

  @override
  final String? chatMemberId;
  @override
  final String? homeServer;
  @override
  final String? accessToken;
  @override
  final String? deviceId;

  @override
  String toString() {
    return 'ChatUserRegisterModel(chatMemberId: $chatMemberId, homeServer: $homeServer, accessToken: $accessToken, deviceId: $deviceId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatUserRegisterModel &&
            (identical(other.chatMemberId, chatMemberId) ||
                other.chatMemberId == chatMemberId) &&
            (identical(other.homeServer, homeServer) ||
                other.homeServer == homeServer) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, chatMemberId, homeServer, accessToken, deviceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatUserRegisterModelCopyWith<_$_ChatUserRegisterModel> get copyWith =>
      __$$_ChatUserRegisterModelCopyWithImpl<_$_ChatUserRegisterModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatUserRegisterModelToJson(
      this,
    );
  }
}

abstract class _ChatUserRegisterModel implements ChatUserRegisterModel {
  factory _ChatUserRegisterModel(
      {final String? chatMemberId,
      final String? homeServer,
      final String? accessToken,
      final String? deviceId}) = _$_ChatUserRegisterModel;

  factory _ChatUserRegisterModel.fromJson(Map<String, dynamic> json) =
      _$_ChatUserRegisterModel.fromJson;

  @override
  String? get chatMemberId;
  @override
  String? get homeServer;
  @override
  String? get accessToken;
  @override
  String? get deviceId;
  @override
  @JsonKey(ignore: true)
  _$$_ChatUserRegisterModelCopyWith<_$_ChatUserRegisterModel> get copyWith =>
      throw _privateConstructorUsedError;
}
