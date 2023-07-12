// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_msg_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) {
  return _ChatMessageModel.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageModel {
  bool get isMine => throw _privateConstructorUsedError;
  String get userID => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  String get msg => throw _privateConstructorUsedError;
  String get dateTime => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  int get reaction => throw _privateConstructorUsedError;
  bool get isReply => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageModelCopyWith<ChatMessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageModelCopyWith<$Res> {
  factory $ChatMessageModelCopyWith(
          ChatMessageModel value, $Res Function(ChatMessageModel) then) =
      _$ChatMessageModelCopyWithImpl<$Res, ChatMessageModel>;
  @useResult
  $Res call(
      {bool isMine,
      String userID,
      String avatarUrl,
      String msg,
      String dateTime,
      bool isEdited,
      int reaction,
      bool isReply,
      bool isRead});
}

/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res, $Val extends ChatMessageModel>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMine = null,
    Object? userID = null,
    Object? avatarUrl = null,
    Object? msg = null,
    Object? dateTime = null,
    Object? isEdited = null,
    Object? reaction = null,
    Object? isReply = null,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      isMine: null == isMine
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool,
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      reaction: null == reaction
          ? _value.reaction
          : reaction // ignore: cast_nullable_to_non_nullable
              as int,
      isReply: null == isReply
          ? _value.isReply
          : isReply // ignore: cast_nullable_to_non_nullable
              as bool,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatMessageModelCopyWith<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  factory _$$_ChatMessageModelCopyWith(
          _$_ChatMessageModel value, $Res Function(_$_ChatMessageModel) then) =
      __$$_ChatMessageModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isMine,
      String userID,
      String avatarUrl,
      String msg,
      String dateTime,
      bool isEdited,
      int reaction,
      bool isReply,
      bool isRead});
}

/// @nodoc
class __$$_ChatMessageModelCopyWithImpl<$Res>
    extends _$ChatMessageModelCopyWithImpl<$Res, _$_ChatMessageModel>
    implements _$$_ChatMessageModelCopyWith<$Res> {
  __$$_ChatMessageModelCopyWithImpl(
      _$_ChatMessageModel _value, $Res Function(_$_ChatMessageModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isMine = null,
    Object? userID = null,
    Object? avatarUrl = null,
    Object? msg = null,
    Object? dateTime = null,
    Object? isEdited = null,
    Object? reaction = null,
    Object? isReply = null,
    Object? isRead = null,
  }) {
    return _then(_$_ChatMessageModel(
      isMine: null == isMine
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool,
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as String,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      reaction: null == reaction
          ? _value.reaction
          : reaction // ignore: cast_nullable_to_non_nullable
              as int,
      isReply: null == isReply
          ? _value.isReply
          : isReply // ignore: cast_nullable_to_non_nullable
              as bool,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatMessageModel implements _ChatMessageModel {
  _$_ChatMessageModel(
      {required this.isMine,
      required this.userID,
      required this.avatarUrl,
      required this.msg,
      required this.dateTime,
      required this.isEdited,
      required this.reaction,
      required this.isReply,
      required this.isRead});

  factory _$_ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$$_ChatMessageModelFromJson(json);

  @override
  final bool isMine;
  @override
  final String userID;
  @override
  final String avatarUrl;
  @override
  final String msg;
  @override
  final String dateTime;
  @override
  final bool isEdited;
  @override
  final int reaction;
  @override
  final bool isReply;
  @override
  final bool isRead;

  @override
  String toString() {
    return 'ChatMessageModel(isMine: $isMine, userID: $userID, avatarUrl: $avatarUrl, msg: $msg, dateTime: $dateTime, isEdited: $isEdited, reaction: $reaction, isReply: $isReply, isRead: $isRead)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatMessageModel &&
            (identical(other.isMine, isMine) || other.isMine == isMine) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction) &&
            (identical(other.isReply, isReply) || other.isReply == isReply) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isMine, userID, avatarUrl, msg,
      dateTime, isEdited, reaction, isReply, isRead);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatMessageModelCopyWith<_$_ChatMessageModel> get copyWith =>
      __$$_ChatMessageModelCopyWithImpl<_$_ChatMessageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatMessageModelToJson(
      this,
    );
  }
}

abstract class _ChatMessageModel implements ChatMessageModel {
  factory _ChatMessageModel(
      {required final bool isMine,
      required final String userID,
      required final String avatarUrl,
      required final String msg,
      required final String dateTime,
      required final bool isEdited,
      required final int reaction,
      required final bool isReply,
      required final bool isRead}) = _$_ChatMessageModel;

  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) =
      _$_ChatMessageModel.fromJson;

  @override
  bool get isMine;
  @override
  String get userID;
  @override
  String get avatarUrl;
  @override
  String get msg;
  @override
  String get dateTime;
  @override
  bool get isEdited;
  @override
  int get reaction;
  @override
  bool get isReply;
  @override
  bool get isRead;
  @override
  @JsonKey(ignore: true)
  _$$_ChatMessageModelCopyWith<_$_ChatMessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}
