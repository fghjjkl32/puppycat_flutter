// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FeedResponseModel _$FeedResponseModelFromJson(Map<String, dynamic> json) {
  return _FeedResponseModel.fromJson(json);
}

/// @nodoc
mixin _$FeedResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  FeedDataListModel get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedResponseModelCopyWith<FeedResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedResponseModelCopyWith<$Res> {
  factory $FeedResponseModelCopyWith(
          FeedResponseModel value, $Res Function(FeedResponseModel) then) =
      _$FeedResponseModelCopyWithImpl<$Res, FeedResponseModel>;
  @useResult
  $Res call(
      {bool result, String code, FeedDataListModel data, String? message});

  $FeedDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class _$FeedResponseModelCopyWithImpl<$Res, $Val extends FeedResponseModel>
    implements $FeedResponseModelCopyWith<$Res> {
  _$FeedResponseModelCopyWithImpl(this._value, this._then);

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
              as FeedDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FeedDataListModelCopyWith<$Res> get data {
    return $FeedDataListModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FeedResponseModelCopyWith<$Res>
    implements $FeedResponseModelCopyWith<$Res> {
  factory _$$_FeedResponseModelCopyWith(_$_FeedResponseModel value,
          $Res Function(_$_FeedResponseModel) then) =
      __$$_FeedResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result, String code, FeedDataListModel data, String? message});

  @override
  $FeedDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$_FeedResponseModelCopyWithImpl<$Res>
    extends _$FeedResponseModelCopyWithImpl<$Res, _$_FeedResponseModel>
    implements _$$_FeedResponseModelCopyWith<$Res> {
  __$$_FeedResponseModelCopyWithImpl(
      _$_FeedResponseModel _value, $Res Function(_$_FeedResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_FeedResponseModel(
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
              as FeedDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedResponseModel implements _FeedResponseModel {
  _$_FeedResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_FeedResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_FeedResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final FeedDataListModel data;
  @override
  final String? message;

  @override
  String toString() {
    return 'FeedResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedResponseModel &&
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
  _$$_FeedResponseModelCopyWith<_$_FeedResponseModel> get copyWith =>
      __$$_FeedResponseModelCopyWithImpl<_$_FeedResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedResponseModelToJson(
      this,
    );
  }
}

abstract class _FeedResponseModel implements FeedResponseModel {
  factory _FeedResponseModel(
      {required final bool result,
      required final String code,
      required final FeedDataListModel data,
      final String? message}) = _$_FeedResponseModel;

  factory _FeedResponseModel.fromJson(Map<String, dynamic> json) =
      _$_FeedResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  FeedDataListModel get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_FeedResponseModelCopyWith<_$_FeedResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
