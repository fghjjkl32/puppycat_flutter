// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_list_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MainListData _$MainListDataFromJson(Map<String, dynamic> json) {
  return _MainListData.fromJson(json);
}

/// @nodoc
mixin _$MainListData {
  String? get regDateTz => throw _privateConstructorUsedError;
  String? get regDate => throw _privateConstructorUsedError;
  int? get state => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;
  int? get idx => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MainListDataCopyWith<MainListData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainListDataCopyWith<$Res> {
  factory $MainListDataCopyWith(
          MainListData value, $Res Function(MainListData) then) =
      _$MainListDataCopyWithImpl<$Res, MainListData>;
  @useResult
  $Res call(
      {String? regDateTz, String? regDate, int? state, int? type, int? idx});
}

/// @nodoc
class _$MainListDataCopyWithImpl<$Res, $Val extends MainListData>
    implements $MainListDataCopyWith<$Res> {
  _$MainListDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? regDateTz = freezed,
    Object? regDate = freezed,
    Object? state = freezed,
    Object? type = freezed,
    Object? idx = freezed,
  }) {
    return _then(_value.copyWith(
      regDateTz: freezed == regDateTz
          ? _value.regDateTz
          : regDateTz // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: freezed == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MainListDataCopyWith<$Res>
    implements $MainListDataCopyWith<$Res> {
  factory _$$_MainListDataCopyWith(
          _$_MainListData value, $Res Function(_$_MainListData) then) =
      __$$_MainListDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? regDateTz, String? regDate, int? state, int? type, int? idx});
}

/// @nodoc
class __$$_MainListDataCopyWithImpl<$Res>
    extends _$MainListDataCopyWithImpl<$Res, _$_MainListData>
    implements _$$_MainListDataCopyWith<$Res> {
  __$$_MainListDataCopyWithImpl(
      _$_MainListData _value, $Res Function(_$_MainListData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? regDateTz = freezed,
    Object? regDate = freezed,
    Object? state = freezed,
    Object? type = freezed,
    Object? idx = freezed,
  }) {
    return _then(_$_MainListData(
      regDateTz: freezed == regDateTz
          ? _value.regDateTz
          : regDateTz // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: freezed == regDate
          ? _value.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
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
class _$_MainListData implements _MainListData {
  _$_MainListData(
      {this.regDateTz, this.regDate, this.state, this.type, this.idx});

  factory _$_MainListData.fromJson(Map<String, dynamic> json) =>
      _$$_MainListDataFromJson(json);

  @override
  final String? regDateTz;
  @override
  final String? regDate;
  @override
  final int? state;
  @override
  final int? type;
  @override
  final int? idx;

  @override
  String toString() {
    return 'MainListData(regDateTz: $regDateTz, regDate: $regDate, state: $state, type: $type, idx: $idx)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MainListData &&
            (identical(other.regDateTz, regDateTz) ||
                other.regDateTz == regDateTz) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.idx, idx) || other.idx == idx));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, regDateTz, regDate, state, type, idx);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MainListDataCopyWith<_$_MainListData> get copyWith =>
      __$$_MainListDataCopyWithImpl<_$_MainListData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MainListDataToJson(
      this,
    );
  }
}

abstract class _MainListData implements MainListData {
  factory _MainListData(
      {final String? regDateTz,
      final String? regDate,
      final int? state,
      final int? type,
      final int? idx}) = _$_MainListData;

  factory _MainListData.fromJson(Map<String, dynamic> json) =
      _$_MainListData.fromJson;

  @override
  String? get regDateTz;
  @override
  String? get regDate;
  @override
  int? get state;
  @override
  int? get type;
  @override
  int? get idx;
  @override
  @JsonKey(ignore: true)
  _$$_MainListDataCopyWith<_$_MainListData> get copyWith =>
      throw _privateConstructorUsedError;
}
