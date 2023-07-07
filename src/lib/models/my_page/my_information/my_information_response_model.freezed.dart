// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_information_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MyInformationResponseModel _$MyInformationResponseModelFromJson(
    Map<String, dynamic> json) {
  return _MyInformationResponseModel.fromJson(json);
}

/// @nodoc
mixin _$MyInformationResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  DataListModel<MyInformationItemModel> get data =>
      throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MyInformationResponseModelCopyWith<MyInformationResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyInformationResponseModelCopyWith<$Res> {
  factory $MyInformationResponseModelCopyWith(MyInformationResponseModel value,
          $Res Function(MyInformationResponseModel) then) =
      _$MyInformationResponseModelCopyWithImpl<$Res,
          MyInformationResponseModel>;
  @useResult
  $Res call(
      {bool result,
      String code,
      DataListModel<MyInformationItemModel> data,
      String? message});

  $DataListModelCopyWith<MyInformationItemModel, $Res> get data;
}

/// @nodoc
class _$MyInformationResponseModelCopyWithImpl<$Res,
        $Val extends MyInformationResponseModel>
    implements $MyInformationResponseModelCopyWith<$Res> {
  _$MyInformationResponseModelCopyWithImpl(this._value, this._then);

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
              as DataListModel<MyInformationItemModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DataListModelCopyWith<MyInformationItemModel, $Res> get data {
    return $DataListModelCopyWith<MyInformationItemModel, $Res>(_value.data,
        (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MyInformationResponseModelCopyWith<$Res>
    implements $MyInformationResponseModelCopyWith<$Res> {
  factory _$$_MyInformationResponseModelCopyWith(
          _$_MyInformationResponseModel value,
          $Res Function(_$_MyInformationResponseModel) then) =
      __$$_MyInformationResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result,
      String code,
      DataListModel<MyInformationItemModel> data,
      String? message});

  @override
  $DataListModelCopyWith<MyInformationItemModel, $Res> get data;
}

/// @nodoc
class __$$_MyInformationResponseModelCopyWithImpl<$Res>
    extends _$MyInformationResponseModelCopyWithImpl<$Res,
        _$_MyInformationResponseModel>
    implements _$$_MyInformationResponseModelCopyWith<$Res> {
  __$$_MyInformationResponseModelCopyWithImpl(
      _$_MyInformationResponseModel _value,
      $Res Function(_$_MyInformationResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_MyInformationResponseModel(
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
              as DataListModel<MyInformationItemModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MyInformationResponseModel implements _MyInformationResponseModel {
  _$_MyInformationResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_MyInformationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_MyInformationResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final DataListModel<MyInformationItemModel> data;
  @override
  final String? message;

  @override
  String toString() {
    return 'MyInformationResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MyInformationResponseModel &&
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
  _$$_MyInformationResponseModelCopyWith<_$_MyInformationResponseModel>
      get copyWith => __$$_MyInformationResponseModelCopyWithImpl<
          _$_MyInformationResponseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MyInformationResponseModelToJson(
      this,
    );
  }
}

abstract class _MyInformationResponseModel
    implements MyInformationResponseModel {
  factory _MyInformationResponseModel(
      {required final bool result,
      required final String code,
      required final DataListModel<MyInformationItemModel> data,
      final String? message}) = _$_MyInformationResponseModel;

  factory _MyInformationResponseModel.fromJson(Map<String, dynamic> json) =
      _$_MyInformationResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  DataListModel<MyInformationItemModel> get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_MyInformationResponseModelCopyWith<_$_MyInformationResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}
