// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_like_user_list_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ContentLikeUserListResponseModel _$ContentLikeUserListResponseModelFromJson(
    Map<String, dynamic> json) {
  return _ContentLikeUserListResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ContentLikeUserListResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  ContentLikeUserListDataListModel get data =>
      throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentLikeUserListResponseModelCopyWith<ContentLikeUserListResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentLikeUserListResponseModelCopyWith<$Res> {
  factory $ContentLikeUserListResponseModelCopyWith(
          ContentLikeUserListResponseModel value,
          $Res Function(ContentLikeUserListResponseModel) then) =
      _$ContentLikeUserListResponseModelCopyWithImpl<$Res,
          ContentLikeUserListResponseModel>;
  @useResult
  $Res call(
      {bool result,
      String code,
      ContentLikeUserListDataListModel data,
      String? message});

  $ContentLikeUserListDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class _$ContentLikeUserListResponseModelCopyWithImpl<$Res,
        $Val extends ContentLikeUserListResponseModel>
    implements $ContentLikeUserListResponseModelCopyWith<$Res> {
  _$ContentLikeUserListResponseModelCopyWithImpl(this._value, this._then);

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
              as ContentLikeUserListDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ContentLikeUserListDataListModelCopyWith<$Res> get data {
    return $ContentLikeUserListDataListModelCopyWith<$Res>(_value.data,
        (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ContentLikeUserListResponseModelCopyWith<$Res>
    implements $ContentLikeUserListResponseModelCopyWith<$Res> {
  factory _$$_ContentLikeUserListResponseModelCopyWith(
          _$_ContentLikeUserListResponseModel value,
          $Res Function(_$_ContentLikeUserListResponseModel) then) =
      __$$_ContentLikeUserListResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result,
      String code,
      ContentLikeUserListDataListModel data,
      String? message});

  @override
  $ContentLikeUserListDataListModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$_ContentLikeUserListResponseModelCopyWithImpl<$Res>
    extends _$ContentLikeUserListResponseModelCopyWithImpl<$Res,
        _$_ContentLikeUserListResponseModel>
    implements _$$_ContentLikeUserListResponseModelCopyWith<$Res> {
  __$$_ContentLikeUserListResponseModelCopyWithImpl(
      _$_ContentLikeUserListResponseModel _value,
      $Res Function(_$_ContentLikeUserListResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_ContentLikeUserListResponseModel(
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
              as ContentLikeUserListDataListModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ContentLikeUserListResponseModel
    implements _ContentLikeUserListResponseModel {
  _$_ContentLikeUserListResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_ContentLikeUserListResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$$_ContentLikeUserListResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final ContentLikeUserListDataListModel data;
  @override
  final String? message;

  @override
  String toString() {
    return 'ContentLikeUserListResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ContentLikeUserListResponseModel &&
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
  _$$_ContentLikeUserListResponseModelCopyWith<
          _$_ContentLikeUserListResponseModel>
      get copyWith => __$$_ContentLikeUserListResponseModelCopyWithImpl<
          _$_ContentLikeUserListResponseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ContentLikeUserListResponseModelToJson(
      this,
    );
  }
}

abstract class _ContentLikeUserListResponseModel
    implements ContentLikeUserListResponseModel {
  factory _ContentLikeUserListResponseModel(
      {required final bool result,
      required final String code,
      required final ContentLikeUserListDataListModel data,
      final String? message}) = _$_ContentLikeUserListResponseModel;

  factory _ContentLikeUserListResponseModel.fromJson(
      Map<String, dynamic> json) = _$_ContentLikeUserListResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  ContentLikeUserListDataListModel get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_ContentLikeUserListResponseModelCopyWith<
          _$_ContentLikeUserListResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}
