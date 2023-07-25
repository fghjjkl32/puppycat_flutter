// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CommentData _$CommentDataFromJson(Map<String, dynamic> json) {
  return _CommentData.fromJson(json);
}

/// @nodoc
mixin _$CommentData {
  String get nick => throw _privateConstructorUsedError;
  int get likeCnt => throw _privateConstructorUsedError;
  int get isBadge => throw _privateConstructorUsedError;
  int get memberIdx => throw _privateConstructorUsedError;
  String get contents => throw _privateConstructorUsedError;
  int get parentIdx => throw _privateConstructorUsedError;
  int get contentsIdx => throw _privateConstructorUsedError;
  String get regDate => throw _privateConstructorUsedError;
  int get state => throw _privateConstructorUsedError;
  int get idx => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  ChildCommentData? get childCommentData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentDataCopyWith<CommentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentDataCopyWith<$Res> {
  factory $CommentDataCopyWith(
          CommentData value, $Res Function(CommentData) then) =
      _$CommentDataCopyWithImpl<$Res, CommentData>;
  @useResult
  $Res call(
      {String nick,
      int likeCnt,
      int isBadge,
      int memberIdx,
      String contents,
      int parentIdx,
      int contentsIdx,
      String regDate,
      int state,
      int idx,
      String uuid,
      String? url,
      ChildCommentData? childCommentData});

  $ChildCommentDataCopyWith<$Res>? get childCommentData;
}

/// @nodoc
class _$CommentDataCopyWithImpl<$Res, $Val extends CommentData>
    implements $CommentDataCopyWith<$Res> {
  _$CommentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = null,
    Object? likeCnt = null,
    Object? isBadge = null,
    Object? memberIdx = null,
    Object? contents = null,
    Object? parentIdx = null,
    Object? contentsIdx = null,
    Object? regDate = null,
    Object? state = null,
    Object? idx = null,
    Object? uuid = null,
    Object? url = freezed,
    Object? childCommentData = freezed,
  }) {
    return _then(_value.copyWith(
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      likeCnt: null == likeCnt
          ? _value.likeCnt
          : likeCnt // ignore: cast_nullable_to_non_nullable
              as int,
      isBadge: null == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int,
      memberIdx: null == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int,
      contents: null == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String,
      parentIdx: null == parentIdx
          ? _value.parentIdx
          : parentIdx // ignore: cast_nullable_to_non_nullable
              as int,
      contentsIdx: null == contentsIdx
          ? _value.contentsIdx
          : contentsIdx // ignore: cast_nullable_to_non_nullable
              as int,
      regDate: null == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as int,
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      childCommentData: freezed == childCommentData
          ? _value.childCommentData
          : childCommentData // ignore: cast_nullable_to_non_nullable
              as ChildCommentData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChildCommentDataCopyWith<$Res>? get childCommentData {
    if (_value.childCommentData == null) {
      return null;
    }

    return $ChildCommentDataCopyWith<$Res>(_value.childCommentData!, (value) {
      return _then(_value.copyWith(childCommentData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_CommentDataCopyWith<$Res>
    implements $CommentDataCopyWith<$Res> {
  factory _$$_CommentDataCopyWith(
          _$_CommentData value, $Res Function(_$_CommentData) then) =
      __$$_CommentDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String nick,
      int likeCnt,
      int isBadge,
      int memberIdx,
      String contents,
      int parentIdx,
      int contentsIdx,
      String regDate,
      int state,
      int idx,
      String uuid,
      String? url,
      ChildCommentData? childCommentData});

  @override
  $ChildCommentDataCopyWith<$Res>? get childCommentData;
}

/// @nodoc
class __$$_CommentDataCopyWithImpl<$Res>
    extends _$CommentDataCopyWithImpl<$Res, _$_CommentData>
    implements _$$_CommentDataCopyWith<$Res> {
  __$$_CommentDataCopyWithImpl(
      _$_CommentData _value, $Res Function(_$_CommentData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nick = null,
    Object? likeCnt = null,
    Object? isBadge = null,
    Object? memberIdx = null,
    Object? contents = null,
    Object? parentIdx = null,
    Object? contentsIdx = null,
    Object? regDate = null,
    Object? state = null,
    Object? idx = null,
    Object? uuid = null,
    Object? url = freezed,
    Object? childCommentData = freezed,
  }) {
    return _then(_$_CommentData(
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      likeCnt: null == likeCnt
          ? _value.likeCnt
          : likeCnt // ignore: cast_nullable_to_non_nullable
              as int,
      isBadge: null == isBadge
          ? _value.isBadge
          : isBadge // ignore: cast_nullable_to_non_nullable
              as int,
      memberIdx: null == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int,
      contents: null == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as String,
      parentIdx: null == parentIdx
          ? _value.parentIdx
          : parentIdx // ignore: cast_nullable_to_non_nullable
              as int,
      contentsIdx: null == contentsIdx
          ? _value.contentsIdx
          : contentsIdx // ignore: cast_nullable_to_non_nullable
              as int,
      regDate: null == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as int,
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      childCommentData: freezed == childCommentData
          ? _value.childCommentData
          : childCommentData // ignore: cast_nullable_to_non_nullable
              as ChildCommentData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CommentData implements _CommentData {
  _$_CommentData(
      {required this.nick,
      required this.likeCnt,
      required this.isBadge,
      required this.memberIdx,
      required this.contents,
      required this.parentIdx,
      required this.contentsIdx,
      required this.regDate,
      required this.state,
      required this.idx,
      required this.uuid,
      this.url,
      this.childCommentData});

  factory _$_CommentData.fromJson(Map<String, dynamic> json) =>
      _$$_CommentDataFromJson(json);

  @override
  final String nick;
  @override
  final int likeCnt;
  @override
  final int isBadge;
  @override
  final int memberIdx;
  @override
  final String contents;
  @override
  final int parentIdx;
  @override
  final int contentsIdx;
  @override
  final String regDate;
  @override
  final int state;
  @override
  final int idx;
  @override
  final String uuid;
  @override
  final String? url;
  @override
  final ChildCommentData? childCommentData;

  @override
  String toString() {
    return 'CommentData(nick: $nick, likeCnt: $likeCnt, isBadge: $isBadge, memberIdx: $memberIdx, contents: $contents, parentIdx: $parentIdx, contentsIdx: $contentsIdx, regDate: $regDate, state: $state, idx: $idx, uuid: $uuid, url: $url, childCommentData: $childCommentData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CommentData &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.likeCnt, likeCnt) || other.likeCnt == likeCnt) &&
            (identical(other.isBadge, isBadge) || other.isBadge == isBadge) &&
            (identical(other.memberIdx, memberIdx) ||
                other.memberIdx == memberIdx) &&
            (identical(other.contents, contents) ||
                other.contents == contents) &&
            (identical(other.parentIdx, parentIdx) ||
                other.parentIdx == parentIdx) &&
            (identical(other.contentsIdx, contentsIdx) ||
                other.contentsIdx == contentsIdx) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.childCommentData, childCommentData) ||
                other.childCommentData == childCommentData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      nick,
      likeCnt,
      isBadge,
      memberIdx,
      contents,
      parentIdx,
      contentsIdx,
      regDate,
      state,
      idx,
      uuid,
      url,
      childCommentData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CommentDataCopyWith<_$_CommentData> get copyWith =>
      __$$_CommentDataCopyWithImpl<_$_CommentData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommentDataToJson(
      this,
    );
  }
}

abstract class _CommentData implements CommentData {
  factory _CommentData(
      {required final String nick,
      required final int likeCnt,
      required final int isBadge,
      required final int memberIdx,
      required final String contents,
      required final int parentIdx,
      required final int contentsIdx,
      required final String regDate,
      required final int state,
      required final int idx,
      required final String uuid,
      final String? url,
      final ChildCommentData? childCommentData}) = _$_CommentData;

  factory _CommentData.fromJson(Map<String, dynamic> json) =
      _$_CommentData.fromJson;

  @override
  String get nick;
  @override
  int get likeCnt;
  @override
  int get isBadge;
  @override
  int get memberIdx;
  @override
  String get contents;
  @override
  int get parentIdx;
  @override
  int get contentsIdx;
  @override
  String get regDate;
  @override
  int get state;
  @override
  int get idx;
  @override
  String get uuid;
  @override
  String? get url;
  @override
  ChildCommentData? get childCommentData;
  @override
  @JsonKey(ignore: true)
  _$$_CommentDataCopyWith<_$_CommentData> get copyWith =>
      throw _privateConstructorUsedError;
}

ChildCommentData _$ChildCommentDataFromJson(Map<String, dynamic> json) {
  return _ChildCommentData.fromJson(json);
}

/// @nodoc
mixin _$ChildCommentData {
  ParamsModel get params => throw _privateConstructorUsedError;
  List<CommentData> get list => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChildCommentDataCopyWith<ChildCommentData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildCommentDataCopyWith<$Res> {
  factory $ChildCommentDataCopyWith(
          ChildCommentData value, $Res Function(ChildCommentData) then) =
      _$ChildCommentDataCopyWithImpl<$Res, ChildCommentData>;
  @useResult
  $Res call({ParamsModel params, List<CommentData> list});

  $ParamsModelCopyWith<$Res> get params;
}

/// @nodoc
class _$ChildCommentDataCopyWithImpl<$Res, $Val extends ChildCommentData>
    implements $ChildCommentDataCopyWith<$Res> {
  _$ChildCommentDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? params = null,
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      params: null == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as ParamsModel,
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<CommentData>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ParamsModelCopyWith<$Res> get params {
    return $ParamsModelCopyWith<$Res>(_value.params, (value) {
      return _then(_value.copyWith(params: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ChildCommentDataCopyWith<$Res>
    implements $ChildCommentDataCopyWith<$Res> {
  factory _$$_ChildCommentDataCopyWith(
          _$_ChildCommentData value, $Res Function(_$_ChildCommentData) then) =
      __$$_ChildCommentDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ParamsModel params, List<CommentData> list});

  @override
  $ParamsModelCopyWith<$Res> get params;
}

/// @nodoc
class __$$_ChildCommentDataCopyWithImpl<$Res>
    extends _$ChildCommentDataCopyWithImpl<$Res, _$_ChildCommentData>
    implements _$$_ChildCommentDataCopyWith<$Res> {
  __$$_ChildCommentDataCopyWithImpl(
      _$_ChildCommentData _value, $Res Function(_$_ChildCommentData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? params = null,
    Object? list = null,
  }) {
    return _then(_$_ChildCommentData(
      params: null == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as ParamsModel,
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<CommentData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChildCommentData implements _ChildCommentData {
  const _$_ChildCommentData(
      {required this.params, required final List<CommentData> list})
      : _list = list;

  factory _$_ChildCommentData.fromJson(Map<String, dynamic> json) =>
      _$$_ChildCommentDataFromJson(json);

  @override
  final ParamsModel params;
  final List<CommentData> _list;
  @override
  List<CommentData> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'ChildCommentData(params: $params, list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChildCommentData &&
            (identical(other.params, params) || other.params == params) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, params, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChildCommentDataCopyWith<_$_ChildCommentData> get copyWith =>
      __$$_ChildCommentDataCopyWithImpl<_$_ChildCommentData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChildCommentDataToJson(
      this,
    );
  }
}

abstract class _ChildCommentData implements ChildCommentData {
  const factory _ChildCommentData(
      {required final ParamsModel params,
      required final List<CommentData> list}) = _$_ChildCommentData;

  factory _ChildCommentData.fromJson(Map<String, dynamic> json) =
      _$_ChildCommentData.fromJson;

  @override
  ParamsModel get params;
  @override
  List<CommentData> get list;
  @override
  @JsonKey(ignore: true)
  _$$_ChildCommentDataCopyWith<_$_ChildCommentData> get copyWith =>
      throw _privateConstructorUsedError;
}
