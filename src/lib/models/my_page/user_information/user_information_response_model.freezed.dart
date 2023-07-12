// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_information_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserInformationResponseModel _$UserInformationResponseModelFromJson(
    Map<String, dynamic> json) {
  return _UserInformationResponseModel.fromJson(json);
}

/// @nodoc
mixin _$UserInformationResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  DataInfoModel<UserInformationItemModel> get data =>
      throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserInformationResponseModelCopyWith<UserInformationResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInformationResponseModelCopyWith<$Res> {
  factory $UserInformationResponseModelCopyWith(
          UserInformationResponseModel value,
          $Res Function(UserInformationResponseModel) then) =
      _$UserInformationResponseModelCopyWithImpl<$Res,
          UserInformationResponseModel>;
  @useResult
  $Res call(
      {bool result,
      String code,
      DataInfoModel<UserInformationItemModel> data,
      String? message});

  $DataInfoModelCopyWith<UserInformationItemModel, $Res> get data;
}

/// @nodoc
class _$UserInformationResponseModelCopyWithImpl<$Res,
        $Val extends UserInformationResponseModel>
    implements $UserInformationResponseModelCopyWith<$Res> {
  _$UserInformationResponseModelCopyWithImpl(this._value, this._then);

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
              as DataInfoModel<UserInformationItemModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DataInfoModelCopyWith<UserInformationItemModel, $Res> get data {
    return $DataInfoModelCopyWith<UserInformationItemModel, $Res>(_value.data,
        (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UserInformationResponseModelCopyWith<$Res>
    implements $UserInformationResponseModelCopyWith<$Res> {
  factory _$$_UserInformationResponseModelCopyWith(
          _$_UserInformationResponseModel value,
          $Res Function(_$_UserInformationResponseModel) then) =
      __$$_UserInformationResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result,
      String code,
      DataInfoModel<UserInformationItemModel> data,
      String? message});

  @override
  $DataInfoModelCopyWith<UserInformationItemModel, $Res> get data;
}

/// @nodoc
class __$$_UserInformationResponseModelCopyWithImpl<$Res>
    extends _$UserInformationResponseModelCopyWithImpl<$Res,
        _$_UserInformationResponseModel>
    implements _$$_UserInformationResponseModelCopyWith<$Res> {
  __$$_UserInformationResponseModelCopyWithImpl(
      _$_UserInformationResponseModel _value,
      $Res Function(_$_UserInformationResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_UserInformationResponseModel(
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
              as DataInfoModel<UserInformationItemModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserInformationResponseModel implements _UserInformationResponseModel {
  _$_UserInformationResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_UserInformationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_UserInformationResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final DataInfoModel<UserInformationItemModel> data;
  @override
  final String? message;

  @override
  String toString() {
    return 'UserInformationResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserInformationResponseModel &&
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
  _$$_UserInformationResponseModelCopyWith<_$_UserInformationResponseModel>
      get copyWith => __$$_UserInformationResponseModelCopyWithImpl<
          _$_UserInformationResponseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserInformationResponseModelToJson(
      this,
    );
  }
}

abstract class _UserInformationResponseModel
    implements UserInformationResponseModel {
  factory _UserInformationResponseModel(
      {required final bool result,
      required final String code,
      required final DataInfoModel<UserInformationItemModel> data,
      final String? message}) = _$_UserInformationResponseModel;

  factory _UserInformationResponseModel.fromJson(Map<String, dynamic> json) =
      _$_UserInformationResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  DataInfoModel<UserInformationItemModel> get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_UserInformationResponseModelCopyWith<_$_UserInformationResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}
