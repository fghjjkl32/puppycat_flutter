// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_favorite_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatFavoriteModel _$ChatFavoriteModelFromJson(Map<String, dynamic> json) {
  return _ChatFavoriteModel.fromJson(json);
}

/// @nodoc
mixin _$ChatFavoriteModel {
  int get memberIdx => throw _privateConstructorUsedError;
  int get isBadge => throw _privateConstructorUsedError;
  String get nick => throw _privateConstructorUsedError;
  String get profileImgUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo)
  ChatUserModel get chatInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatFavoriteModelCopyWith<ChatFavoriteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatFavoriteModelCopyWith<$Res> {
  factory $ChatFavoriteModelCopyWith(
          ChatFavoriteModel value, $Res Function(ChatFavoriteModel) then) =
      _$ChatFavoriteModelCopyWithImpl<$Res, ChatFavoriteModel>;
  @useResult
  $Res call(
      {int memberIdx,
      int isBadge,
      String nick,
      String profileImgUrl,
      @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo)
      ChatUserModel chatInfo});

  $ChatUserModelCopyWith<$Res> get chatInfo;
}

/// @nodoc
class _$ChatFavoriteModelCopyWithImpl<$Res, $Val extends ChatFavoriteModel>
    implements $ChatFavoriteModelCopyWith<$Res> {
  _$ChatFavoriteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberIdx = null,
    Object? isBadge = null,
    Object? nick = null,
    Object? profileImgUrl = null,
    Object? chatInfo = null,
  }) {
    return _then(_value.copyWith(
      memberIdx: null == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int,
      isBadge: null == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int,
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      profileImgUrl: null == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String,
      chatInfo: null == chatInfo
          ? _value.chatInfo
          : chatInfo // ignore: cast_nullable_to_non_nullable
              as ChatUserModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChatUserModelCopyWith<$Res> get chatInfo {
    return $ChatUserModelCopyWith<$Res>(_value.chatInfo, (value) {
      return _then(_value.copyWith(chatInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ChatFavoriteModelCopyWith<$Res>
    implements $ChatFavoriteModelCopyWith<$Res> {
  factory _$$_ChatFavoriteModelCopyWith(_$_ChatFavoriteModel value,
          $Res Function(_$_ChatFavoriteModel) then) =
      __$$_ChatFavoriteModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int memberIdx,
      int isBadge,
      String nick,
      String profileImgUrl,
      @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo)
      ChatUserModel chatInfo});

  @override
  $ChatUserModelCopyWith<$Res> get chatInfo;
}

/// @nodoc
class __$$_ChatFavoriteModelCopyWithImpl<$Res>
    extends _$ChatFavoriteModelCopyWithImpl<$Res, _$_ChatFavoriteModel>
    implements _$$_ChatFavoriteModelCopyWith<$Res> {
  __$$_ChatFavoriteModelCopyWithImpl(
      _$_ChatFavoriteModel _value, $Res Function(_$_ChatFavoriteModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberIdx = null,
    Object? isBadge = null,
    Object? nick = null,
    Object? profileImgUrl = null,
    Object? chatInfo = null,
  }) {
    return _then(_$_ChatFavoriteModel(
      memberIdx: null == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int,
      isBadge: null == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int,
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      profileImgUrl: null == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String,
      chatInfo: null == chatInfo
          ? _value.chatInfo
          : chatInfo // ignore: cast_nullable_to_non_nullable
              as ChatUserModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatFavoriteModel implements _ChatFavoriteModel {
  _$_ChatFavoriteModel(
      {required this.memberIdx,
      required this.isBadge,
      required this.nick,
      required this.profileImgUrl,
      @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo)
      required this.chatInfo});

  factory _$_ChatFavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$$_ChatFavoriteModelFromJson(json);

  @override
  final int memberIdx;
  @override
  final int isBadge;
  @override
  final String nick;
  @override
  final String profileImgUrl;
  @override
  @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo)
  final ChatUserModel chatInfo;

  @override
  String toString() {
    return 'ChatFavoriteModel(memberIdx: $memberIdx, isBadge: $isBadge, nick: $nick, profileImgUrl: $profileImgUrl, chatInfo: $chatInfo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatFavoriteModel &&
            (identical(other.memberIdx, memberIdx) ||
                other.memberIdx == memberIdx) &&
            (identical(other.isBadge, isBadge) || other.isBadge == isBadge) &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.profileImgUrl, profileImgUrl) ||
                other.profileImgUrl == profileImgUrl) &&
            (identical(other.chatInfo, chatInfo) ||
                other.chatInfo == chatInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, memberIdx, isBadge, nick, profileImgUrl, chatInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatFavoriteModelCopyWith<_$_ChatFavoriteModel> get copyWith =>
      __$$_ChatFavoriteModelCopyWithImpl<_$_ChatFavoriteModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatFavoriteModelToJson(
      this,
    );
  }
}

abstract class _ChatFavoriteModel implements ChatFavoriteModel {
  factory _ChatFavoriteModel(
      {required final int memberIdx,
      required final int isBadge,
      required final String nick,
      required final String profileImgUrl,
      @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo)
      required final ChatUserModel chatInfo}) = _$_ChatFavoriteModel;

  factory _ChatFavoriteModel.fromJson(Map<String, dynamic> json) =
      _$_ChatFavoriteModel.fromJson;

  @override
  int get memberIdx;
  @override
  int get isBadge;
  @override
  String get nick;
  @override
  String get profileImgUrl;
  @override
  @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo)
  ChatUserModel get chatInfo;
  @override
  @JsonKey(ignore: true)
  _$$_ChatFavoriteModelCopyWith<_$_ChatFavoriteModel> get copyWith =>
      throw _privateConstructorUsedError;
}
