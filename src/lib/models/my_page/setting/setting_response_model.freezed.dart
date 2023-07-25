// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SettingResponseModel _$SettingResponseModelFromJson(Map<String, dynamic> json) {
  return _SettingResponseModel.fromJson(json);
}

/// @nodoc
mixin _$SettingResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  SettingDataListModel get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingResponseModelCopyWith<SettingResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingResponseModelCopyWith<$Res> {
  factory $SettingResponseModelCopyWith(SettingResponseModel value,
          $Res Function(SettingResponseModel) then) =
      _$SettingResponseModelCopyWithImpl<$Res, SettingResponseModel>;
  @useResult
  $Res call(
      {bool result, String code, SettingDataListModel data, String? message});

  $SettingDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class _$SettingResponseModelCopyWithImpl<$Res,
        $Val extends SettingResponseModel>
    implements $SettingResponseModelCopyWith<$Res> {
  _$SettingResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as bool,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SettingDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SettingDataListModelCopyWith<$Res> get data {
    return $SettingDataListModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SettingResponseModelCopyWith<$Res>
    implements $SettingResponseModelCopyWith<$Res> {
  factory _$$_SettingResponseModelCopyWith(_$_SettingResponseModel value,
          $Res Function(_$_SettingResponseModel) then) =
      __$$_SettingResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result, String code, SettingDataListModel data, String? message});

  @override
  $SettingDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$_SettingResponseModelCopyWithImpl<$Res>
    extends _$SettingResponseModelCopyWithImpl<$Res, _$_SettingResponseModel>
    implements _$$_SettingResponseModelCopyWith<$Res> {
  __$$_SettingResponseModelCopyWithImpl(_$_SettingResponseModel _value,
      $Res Function(_$_SettingResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_SettingResponseModel(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as bool,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SettingDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SettingResponseModel implements _SettingResponseModel {
  _$_SettingResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_SettingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_SettingResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final SettingDataListModel data;
  @override
  final String? message;

  @override
  String toString() {
    return 'SettingResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SettingResponseModel &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, result, code, data, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingResponseModelCopyWith<_$_SettingResponseModel> get copyWith =>
      __$$_SettingResponseModelCopyWithImpl<_$_SettingResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SettingResponseModelToJson(
      this,
    );
  }
}

abstract class _SettingResponseModel implements SettingResponseModel {
  factory _SettingResponseModel(
      {required final bool result,
      required final String code,
      required final SettingDataListModel data,
      final String? message}) = _$_SettingResponseModel;

  factory _SettingResponseModel.fromJson(Map<String, dynamic> json) =
      _$_SettingResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  SettingDataListModel get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_SettingResponseModelCopyWith<_$_SettingResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
