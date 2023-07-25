// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_list_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SubListData _$SubListDataFromJson(Map<String, dynamic> json) {
  return _SubListData.fromJson(json);
}

/// @nodoc
mixin _$SubListData {
  String? get regDateTz => throw _privateConstructorUsedError;
  int? get notiType => throw _privateConstructorUsedError;
  String? get regDate => throw _privateConstructorUsedError;
  int? get subType => throw _privateConstructorUsedError;
  int? get state => throw _privateConstructorUsedError;
  int? get idx => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubListDataCopyWith<SubListData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubListDataCopyWith<$Res> {
  factory $SubListDataCopyWith(
          SubListData value, $Res Function(SubListData) then) =
      _$SubListDataCopyWithImpl<$Res, SubListData>;
  @useResult
  $Res call(
      {String? regDateTz,
      int? notiType,
      String? regDate,
      int? subType,
      int? state,
      int? idx});
}

/// @nodoc
class _$SubListDataCopyWithImpl<$Res, $Val extends SubListData>
    implements $SubListDataCopyWith<$Res> {
  _$SubListDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? regDateTz = freezed,
    Object? notiType = freezed,
    Object? regDate = freezed,
    Object? subType = freezed,
    Object? state = freezed,
    Object? idx = freezed,
  }) {
    return _then(_value.copyWith(
      regDateTz: freezed == regDateTz
          ? _value.regDateTz
          : regDateTz // ignore: cast_nullable_to_non_nullable
              as String?,
      notiType: freezed == notiType
          ? _value.notiType
          : notiType // ignore: cast_nullable_to_non_nullable
              as int?,
      regDate: freezed == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      subType: freezed == subType
          ? _value.subType
          : subType // ignore: cast_nullable_to_non_nullable
              as int?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SubListDataCopyWith<$Res>
    implements $SubListDataCopyWith<$Res> {
  factory _$$_SubListDataCopyWith(
          _$_SubListData value, $Res Function(_$_SubListData) then) =
      __$$_SubListDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? regDateTz,
      int? notiType,
      String? regDate,
      int? subType,
      int? state,
      int? idx});
}

/// @nodoc
class __$$_SubListDataCopyWithImpl<$Res>
    extends _$SubListDataCopyWithImpl<$Res, _$_SubListData>
    implements _$$_SubListDataCopyWith<$Res> {
  __$$_SubListDataCopyWithImpl(
      _$_SubListData _value, $Res Function(_$_SubListData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? regDateTz = freezed,
    Object? notiType = freezed,
    Object? regDate = freezed,
    Object? subType = freezed,
    Object? state = freezed,
    Object? idx = freezed,
  }) {
    return _then(_$_SubListData(
      regDateTz: freezed == regDateTz
          ? _value.regDateTz
          : regDateTz // ignore: cast_nullable_to_non_nullable
              as String?,
      notiType: freezed == notiType
          ? _value.notiType
          : notiType // ignore: cast_nullable_to_non_nullable
              as int?,
      regDate: freezed == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      subType: freezed == subType
          ? _value.subType
          : subType // ignore: cast_nullable_to_non_nullable
              as int?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SubListData implements _SubListData {
  _$_SubListData(
      {this.regDateTz,
      this.notiType,
      this.regDate,
      this.subType,
      this.state,
      this.idx});

  factory _$_SubListData.fromJson(Map<String, dynamic> json) =>
      _$$_SubListDataFromJson(json);

  @override
  final String? regDateTz;
  @override
  final int? notiType;
  @override
  final String? regDate;
  @override
  final int? subType;
  @override
  final int? state;
  @override
  final int? idx;

  @override
  String toString() {
    return 'SubListData(regDateTz: $regDateTz, notiType: $notiType, regDate: $regDate, subType: $subType, state: $state, idx: $idx)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SubListData &&
            (identical(other.regDateTz, regDateTz) ||
                other.regDateTz == regDateTz) &&
            (identical(other.notiType, notiType) ||
                other.notiType == notiType) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.subType, subType) || other.subType == subType) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.idx, idx) || other.idx == idx));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, regDateTz, notiType, regDate, subType, state, idx);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SubListDataCopyWith<_$_SubListData> get copyWith =>
      __$$_SubListDataCopyWithImpl<_$_SubListData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SubListDataToJson(
      this,
    );
  }
}

abstract class _SubListData implements SubListData {
  factory _SubListData(
      {final String? regDateTz,
      final int? notiType,
      final String? regDate,
      final int? subType,
      final int? state,
      final int? idx}) = _$_SubListData;

  factory _SubListData.fromJson(Map<String, dynamic> json) =
      _$_SubListData.fromJson;

  @override
  String? get regDateTz;
  @override
  int? get notiType;
  @override
  String? get regDate;
  @override
  int? get subType;
  @override
  int? get state;
  @override
  int? get idx;
  @override
  @JsonKey(ignore: true)
  _$$_SubListDataCopyWith<_$_SubListData> get copyWith =>
      throw _privateConstructorUsedError;
}
