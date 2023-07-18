// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FollowResponseModel _$FollowResponseModelFromJson(Map<String, dynamic> json) {
  return _FollowResponseModel.fromJson(json);
}

/// @nodoc
mixin _$FollowResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  FollowDataListModel get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FollowResponseModelCopyWith<FollowResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowResponseModelCopyWith<$Res> {
  factory $FollowResponseModelCopyWith(
          FollowResponseModel value, $Res Function(FollowResponseModel) then) =
      _$FollowResponseModelCopyWithImpl<$Res, FollowResponseModel>;
  @useResult
  $Res call(
      {bool result, String code, FollowDataListModel data, String? message});

  $FollowDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class _$FollowResponseModelCopyWithImpl<$Res, $Val extends FollowResponseModel>
    implements $FollowResponseModelCopyWith<$Res> {
  _$FollowResponseModelCopyWithImpl(this._value, this._then);

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
              as FollowDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FollowDataListModelCopyWith<$Res> get data {
    return $FollowDataListModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FollowResponseModelCopyWith<$Res>
    implements $FollowResponseModelCopyWith<$Res> {
  factory _$$_FollowResponseModelCopyWith(_$_FollowResponseModel value,
          $Res Function(_$_FollowResponseModel) then) =
      __$$_FollowResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result, String code, FollowDataListModel data, String? message});

  @override
  $FollowDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$_FollowResponseModelCopyWithImpl<$Res>
    extends _$FollowResponseModelCopyWithImpl<$Res, _$_FollowResponseModel>
    implements _$$_FollowResponseModelCopyWith<$Res> {
  __$$_FollowResponseModelCopyWithImpl(_$_FollowResponseModel _value,
      $Res Function(_$_FollowResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_FollowResponseModel(
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
              as FollowDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FollowResponseModel implements _FollowResponseModel {
  _$_FollowResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_FollowResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_FollowResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final FollowDataListModel data;
  @override
  final String? message;

  @override
  String toString() {
    return 'FollowResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FollowResponseModel &&
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
  _$$_FollowResponseModelCopyWith<_$_FollowResponseModel> get copyWith =>
      __$$_FollowResponseModelCopyWithImpl<_$_FollowResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FollowResponseModelToJson(
      this,
    );
  }
}

abstract class _FollowResponseModel implements FollowResponseModel {
  factory _FollowResponseModel(
      {required final bool result,
      required final String code,
      required final FollowDataListModel data,
      final String? message}) = _$_FollowResponseModel;

  factory _FollowResponseModel.fromJson(Map<String, dynamic> json) =
      _$_FollowResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  FollowDataListModel get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_FollowResponseModelCopyWith<_$_FollowResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
