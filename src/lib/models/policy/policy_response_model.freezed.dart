// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'policy_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PolicyResponseModel _$PolicyResponseModelFromJson(Map<String, dynamic> json) {
  return _PolicyResponseModel.fromJson(json);
}

/// @nodoc
mixin _$PolicyResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  DataListModel<PolicyItemModel> get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PolicyResponseModelCopyWith<PolicyResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyResponseModelCopyWith<$Res> {
  factory $PolicyResponseModelCopyWith(
          PolicyResponseModel value, $Res Function(PolicyResponseModel) then) =
      _$PolicyResponseModelCopyWithImpl<$Res, PolicyResponseModel>;
  @useResult
  $Res call(
      {bool result,
      String code,
      DataListModel<PolicyItemModel> data,
      String? message});

  $DataListModelCopyWith<PolicyItemModel, $Res> get data;
}

/// @nodoc
class _$PolicyResponseModelCopyWithImpl<$Res, $Val extends PolicyResponseModel>
    implements $PolicyResponseModelCopyWith<$Res> {
  _$PolicyResponseModelCopyWithImpl(this._value, this._then);

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
              as DataListModel<PolicyItemModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DataListModelCopyWith<PolicyItemModel, $Res> get data {
    return $DataListModelCopyWith<PolicyItemModel, $Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PolicyResponseModelCopyWith<$Res>
    implements $PolicyResponseModelCopyWith<$Res> {
  factory _$$_PolicyResponseModelCopyWith(_$_PolicyResponseModel value,
          $Res Function(_$_PolicyResponseModel) then) =
      __$$_PolicyResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result,
      String code,
      DataListModel<PolicyItemModel> data,
      String? message});

  @override
  $DataListModelCopyWith<PolicyItemModel, $Res> get data;
}

/// @nodoc
class __$$_PolicyResponseModelCopyWithImpl<$Res>
    extends _$PolicyResponseModelCopyWithImpl<$Res, _$_PolicyResponseModel>
    implements _$$_PolicyResponseModelCopyWith<$Res> {
  __$$_PolicyResponseModelCopyWithImpl(_$_PolicyResponseModel _value,
      $Res Function(_$_PolicyResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_PolicyResponseModel(
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
              as DataListModel<PolicyItemModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PolicyResponseModel implements _PolicyResponseModel {
  _$_PolicyResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_PolicyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_PolicyResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final DataListModel<PolicyItemModel> data;
  @override
  final String? message;

  @override
  String toString() {
    return 'PolicyResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PolicyResponseModel &&
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
  _$$_PolicyResponseModelCopyWith<_$_PolicyResponseModel> get copyWith =>
      __$$_PolicyResponseModelCopyWithImpl<_$_PolicyResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PolicyResponseModelToJson(
      this,
    );
  }
}

abstract class _PolicyResponseModel implements PolicyResponseModel {
  factory _PolicyResponseModel(
      {required final bool result,
      required final String code,
      required final DataListModel<PolicyItemModel> data,
      final String? message}) = _$_PolicyResponseModel;

  factory _PolicyResponseModel.fromJson(Map<String, dynamic> json) =
      _$_PolicyResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  DataListModel<PolicyItemModel> get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_PolicyResponseModelCopyWith<_$_PolicyResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
