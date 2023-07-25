// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BlockData _$BlockDataFromJson(Map<String, dynamic> json) {
  return _BlockData.fromJson(json);
}

/// @nodoc
mixin _$BlockData {
  String? get nick => throw _privateConstructorUsedError;
  int? get memberIdx => throw _privateConstructorUsedError;
  String? get intro => throw _privateConstructorUsedError;
  String? get profileImgUrl => throw _privateConstructorUsedError;
  int? get isBadge => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlockDataCopyWith<BlockData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockDataCopyWith<$Res> {
  factory $BlockDataCopyWith(BlockData value, $Res Function(BlockData) then) =
      _$BlockDataCopyWithImpl<$Res, BlockData>;
  @useResult
  $Res call(
      {String? nick,
      int? memberIdx,
      String? intro,
      String? profileImgUrl,
      int? isBadge});
}

/// @nodoc
class _$BlockDataCopyWithImpl<$Res, $Val extends BlockData>
    implements $BlockDataCopyWith<$Res> {
  _$BlockDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = freezed,
    Object? memberIdx = freezed,
    Object? intro = freezed,
    Object? profileImgUrl = freezed,
    Object? isBadge = freezed,
  }) {
    return _then(_value.copyWith(
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      intro: freezed == intro
          ? _value.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isBadge: freezed == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BlockDataCopyWith<$Res> implements $BlockDataCopyWith<$Res> {
  factory _$$_BlockDataCopyWith(
          _$_BlockData value, $Res Function(_$_BlockData) then) =
      __$$_BlockDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? nick,
      int? memberIdx,
      String? intro,
      String? profileImgUrl,
      int? isBadge});
}

/// @nodoc
class __$$_BlockDataCopyWithImpl<$Res>
    extends _$BlockDataCopyWithImpl<$Res, _$_BlockData>
    implements _$$_BlockDataCopyWith<$Res> {
  __$$_BlockDataCopyWithImpl(
      _$_BlockData _value, $Res Function(_$_BlockData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = freezed,
    Object? memberIdx = freezed,
    Object? intro = freezed,
    Object? profileImgUrl = freezed,
    Object? isBadge = freezed,
  }) {
    return _then(_$_BlockData(
      nick: freezed == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String?,
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      intro: freezed == intro
          ? _value.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImgUrl: freezed == profileImgUrl
          ? _value.profileImgUrl
          : profileImgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isBadge: freezed == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BlockData implements _BlockData {
  _$_BlockData(
      {this.nick,
      this.memberIdx,
      this.intro,
      this.profileImgUrl,
      this.isBadge});

  factory _$_BlockData.fromJson(Map<String, dynamic> json) =>
      _$$_BlockDataFromJson(json);

  @override
  final String? nick;
  @override
  final int? memberIdx;
  @override
  final String? intro;
  @override
  final String? profileImgUrl;
  @override
  final int? isBadge;

  @override
  String toString() {
    return 'BlockData(nick: $nick, memberIdx: $memberIdx, intro: $intro, profileImgUrl: $profileImgUrl, isBadge: $isBadge)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BlockData &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.memberIdx, memberIdx) ||
                other.memberIdx == memberIdx) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.profileImgUrl, profileImgUrl) ||
                other.profileImgUrl == profileImgUrl) &&
            (identical(other.isBadge, isBadge) || other.isBadge == isBadge));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, nick, memberIdx, intro, profileImgUrl, isBadge);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BlockDataCopyWith<_$_BlockData> get copyWith =>
      __$$_BlockDataCopyWithImpl<_$_BlockData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BlockDataToJson(
      this,
    );
  }
}

abstract class _BlockData implements BlockData {
  factory _BlockData(
      {final String? nick,
      final int? memberIdx,
      final String? intro,
      final String? profileImgUrl,
      final int? isBadge}) = _$_BlockData;

  factory _BlockData.fromJson(Map<String, dynamic> json) =
      _$_BlockData.fromJson;

  @override
  String? get nick;
  @override
  int? get memberIdx;
  @override
  String? get intro;
  @override
  String? get profileImgUrl;
  @override
  int? get isBadge;
  @override
  @JsonKey(ignore: true)
  _$$_BlockDataCopyWith<_$_BlockData> get copyWith =>
      throw _privateConstructorUsedError;
}
