// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ContentResponseModel _$ContentResponseModelFromJson(Map<String, dynamic> json) {
  return _ContentResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ContentResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  ContentDataListModel get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentResponseModelCopyWith<ContentResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentResponseModelCopyWith<$Res> {
  factory $ContentResponseModelCopyWith(ContentResponseModel value,
          $Res Function(ContentResponseModel) then) =
      _$ContentResponseModelCopyWithImpl<$Res, ContentResponseModel>;
  @useResult
  $Res call(
      {bool result, String code, ContentDataListModel data, String? message});

  $ContentDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class _$ContentResponseModelCopyWithImpl<$Res,
        $Val extends ContentResponseModel>
    implements $ContentResponseModelCopyWith<$Res> {
  _$ContentResponseModelCopyWithImpl(this._value, this._then);

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
              as ContentDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ContentDataListModelCopyWith<$Res> get data {
    return $ContentDataListModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ContentResponseModelCopyWith<$Res>
    implements $ContentResponseModelCopyWith<$Res> {
  factory _$$_ContentResponseModelCopyWith(_$_ContentResponseModel value,
          $Res Function(_$_ContentResponseModel) then) =
      __$$_ContentResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result, String code, ContentDataListModel data, String? message});

  @override
  $ContentDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$_ContentResponseModelCopyWithImpl<$Res>
    extends _$ContentResponseModelCopyWithImpl<$Res, _$_ContentResponseModel>
    implements _$$_ContentResponseModelCopyWith<$Res> {
  __$$_ContentResponseModelCopyWithImpl(_$_ContentResponseModel _value,
      $Res Function(_$_ContentResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_ContentResponseModel(
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
              as ContentDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ContentResponseModel implements _ContentResponseModel {
  _$_ContentResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_ContentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_ContentResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final ContentDataListModel data;
  @override
  final String? message;

  @override
  String toString() {
    return 'ContentResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ContentResponseModel &&
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
  _$$_ContentResponseModelCopyWith<_$_ContentResponseModel> get copyWith =>
      __$$_ContentResponseModelCopyWithImpl<_$_ContentResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ContentResponseModelToJson(
      this,
    );
  }
}

abstract class _ContentResponseModel implements ContentResponseModel {
  factory _ContentResponseModel(
      {required final bool result,
      required final String code,
      required final ContentDataListModel data,
      final String? message}) = _$_ContentResponseModel;

  factory _ContentResponseModel.fromJson(Map<String, dynamic> json) =
      _$_ContentResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  ContentDataListModel get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_ContentResponseModelCopyWith<_$_ContentResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}
