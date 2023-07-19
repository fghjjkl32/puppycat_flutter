// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BlockResponseModel _$BlockResponseModelFromJson(Map<String, dynamic> json) {
  return _BlockResponseModel.fromJson(json);
}

/// @nodoc
mixin _$BlockResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  BlockDataListModel get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlockResponseModelCopyWith<BlockResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockResponseModelCopyWith<$Res> {
  factory $BlockResponseModelCopyWith(
          BlockResponseModel value, $Res Function(BlockResponseModel) then) =
      _$BlockResponseModelCopyWithImpl<$Res, BlockResponseModel>;
  @useResult
  $Res call(
      {bool result, String code, BlockDataListModel data, String? message});

  $BlockDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class _$BlockResponseModelCopyWithImpl<$Res, $Val extends BlockResponseModel>
    implements $BlockResponseModelCopyWith<$Res> {
  _$BlockResponseModelCopyWithImpl(this._value, this._then);

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
              as BlockDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BlockDataListModelCopyWith<$Res> get data {
    return $BlockDataListModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BlockResponseModelCopyWith<$Res>
    implements $BlockResponseModelCopyWith<$Res> {
  factory _$$_BlockResponseModelCopyWith(_$_BlockResponseModel value,
          $Res Function(_$_BlockResponseModel) then) =
      __$$_BlockResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result, String code, BlockDataListModel data, String? message});

  @override
  $BlockDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$_BlockResponseModelCopyWithImpl<$Res>
    extends _$BlockResponseModelCopyWithImpl<$Res, _$_BlockResponseModel>
    implements _$$_BlockResponseModelCopyWith<$Res> {
  __$$_BlockResponseModelCopyWithImpl(
      _$_BlockResponseModel _value, $Res Function(_$_BlockResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_BlockResponseModel(
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
              as BlockDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BlockResponseModel implements _BlockResponseModel {
  _$_BlockResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_BlockResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_BlockResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final BlockDataListModel data;
  @override
  final String? message;

  @override
  String toString() {
    return 'BlockResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BlockResponseModel &&
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
  _$$_BlockResponseModelCopyWith<_$_BlockResponseModel> get copyWith =>
      __$$_BlockResponseModelCopyWithImpl<_$_BlockResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BlockResponseModelToJson(
      this,
    );
  }
}

abstract class _BlockResponseModel implements BlockResponseModel {
  factory _BlockResponseModel(
      {required final bool result,
      required final String code,
      required final BlockDataListModel data,
      final String? message}) = _$_BlockResponseModel;

  factory _BlockResponseModel.fromJson(Map<String, dynamic> json) =
      _$_BlockResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  BlockDataListModel get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_BlockResponseModelCopyWith<_$_BlockResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
