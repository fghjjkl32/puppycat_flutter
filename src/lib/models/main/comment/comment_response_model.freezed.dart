// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CommentResponseModel _$CommentResponseModelFromJson(Map<String, dynamic> json) {
  return _CommentResponseModel.fromJson(json);
}

/// @nodoc
mixin _$CommentResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  CommentDataListModel get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentResponseModelCopyWith<CommentResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentResponseModelCopyWith<$Res> {
  factory $CommentResponseModelCopyWith(CommentResponseModel value,
          $Res Function(CommentResponseModel) then) =
      _$CommentResponseModelCopyWithImpl<$Res, CommentResponseModel>;
  @useResult
  $Res call(
      {bool result, String code, CommentDataListModel data, String? message});

  $CommentDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class _$CommentResponseModelCopyWithImpl<$Res,
        $Val extends CommentResponseModel>
    implements $CommentResponseModelCopyWith<$Res> {
  _$CommentResponseModelCopyWithImpl(this._value, this._then);

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
              as CommentDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CommentDataListModelCopyWith<$Res> get data {
    return $CommentDataListModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_CommentResponseModelCopyWith<$Res>
    implements $CommentResponseModelCopyWith<$Res> {
  factory _$$_CommentResponseModelCopyWith(_$_CommentResponseModel value,
          $Res Function(_$_CommentResponseModel) then) =
      __$$_CommentResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result, String code, CommentDataListModel data, String? message});

  @override
  $CommentDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$_CommentResponseModelCopyWithImpl<$Res>
    extends _$CommentResponseModelCopyWithImpl<$Res, _$_CommentResponseModel>
    implements _$$_CommentResponseModelCopyWith<$Res> {
  __$$_CommentResponseModelCopyWithImpl(_$_CommentResponseModel _value,
      $Res Function(_$_CommentResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_CommentResponseModel(
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
              as CommentDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CommentResponseModel implements _CommentResponseModel {
  _$_CommentResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_CommentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_CommentResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final CommentDataListModel data;
  @override
  final String? message;

  @override
  String toString() {
    return 'CommentResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CommentResponseModel &&
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
  _$$_CommentResponseModelCopyWith<_$_CommentResponseModel> get copyWith =>
      __$$_CommentResponseModelCopyWithImpl<_$_CommentResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommentResponseModelToJson(
      this,
    );
  }
}

abstract class _CommentResponseModel implements CommentResponseModel {
  factory _CommentResponseModel(
      {required final bool result,
      required final String code,
      required final CommentDataListModel data,
      final String? message}) = _$_CommentResponseModel;

  factory _CommentResponseModel.fromJson(Map<String, dynamic> json) =
      _$_CommentResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  CommentDataListModel get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_CommentResponseModelCopyWith<_$_CommentResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
