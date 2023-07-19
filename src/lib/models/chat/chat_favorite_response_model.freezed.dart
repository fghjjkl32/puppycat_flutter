// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_favorite_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatFavoriteResponseModel _$ChatFavoriteResponseModelFromJson(
    Map<String, dynamic> json) {
  return _ChatFavoriteResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ChatFavoriteResponseModel {
  bool get result => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  DataListModel<ChatFavoriteModel> get data =>
      throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatFavoriteResponseModelCopyWith<ChatFavoriteResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatFavoriteResponseModelCopyWith<$Res> {
  factory $ChatFavoriteResponseModelCopyWith(ChatFavoriteResponseModel value,
          $Res Function(ChatFavoriteResponseModel) then) =
      _$ChatFavoriteResponseModelCopyWithImpl<$Res, ChatFavoriteResponseModel>;
  @useResult
  $Res call(
      {bool result,
      String code,
      DataListModel<ChatFavoriteModel> data,
      String? message});

  $DataListModelCopyWith<ChatFavoriteModel, $Res> get data;
}

/// @nodoc
class _$ChatFavoriteResponseModelCopyWithImpl<$Res,
        $Val extends ChatFavoriteResponseModel>
    implements $ChatFavoriteResponseModelCopyWith<$Res> {
  _$ChatFavoriteResponseModelCopyWithImpl(this._value, this._then);

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
              as DataListModel<ChatFavoriteModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DataListModelCopyWith<ChatFavoriteModel, $Res> get data {
    return $DataListModelCopyWith<ChatFavoriteModel, $Res>(_value.data,
        (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ChatFavoriteResponseModelCopyWith<$Res>
    implements $ChatFavoriteResponseModelCopyWith<$Res> {
  factory _$$_ChatFavoriteResponseModelCopyWith(
          _$_ChatFavoriteResponseModel value,
          $Res Function(_$_ChatFavoriteResponseModel) then) =
      __$$_ChatFavoriteResponseModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool result,
      String code,
      DataListModel<ChatFavoriteModel> data,
      String? message});

  @override
  $DataListModelCopyWith<ChatFavoriteModel, $Res> get data;
}

/// @nodoc
class __$$_ChatFavoriteResponseModelCopyWithImpl<$Res>
    extends _$ChatFavoriteResponseModelCopyWithImpl<$Res,
        _$_ChatFavoriteResponseModel>
    implements _$$_ChatFavoriteResponseModelCopyWith<$Res> {
  __$$_ChatFavoriteResponseModelCopyWithImpl(
      _$_ChatFavoriteResponseModel _value,
      $Res Function(_$_ChatFavoriteResponseModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? code = null,
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$_ChatFavoriteResponseModel(
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
              as DataListModel<ChatFavoriteModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatFavoriteResponseModel implements _ChatFavoriteResponseModel {
  _$_ChatFavoriteResponseModel(
      {required this.result,
      required this.code,
      required this.data,
      this.message});

  factory _$_ChatFavoriteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$$_ChatFavoriteResponseModelFromJson(json);

  @override
  final bool result;
  @override
  final String code;
  @override
  final DataListModel<ChatFavoriteModel> data;
  @override
  final String? message;

  @override
  String toString() {
    return 'ChatFavoriteResponseModel(result: $result, code: $code, data: $data, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatFavoriteResponseModel &&
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
  _$$_ChatFavoriteResponseModelCopyWith<_$_ChatFavoriteResponseModel>
      get copyWith => __$$_ChatFavoriteResponseModelCopyWithImpl<
          _$_ChatFavoriteResponseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatFavoriteResponseModelToJson(
      this,
    );
  }
}

abstract class _ChatFavoriteResponseModel implements ChatFavoriteResponseModel {
  factory _ChatFavoriteResponseModel(
      {required final bool result,
      required final String code,
      required final DataListModel<ChatFavoriteModel> data,
      final String? message}) = _$_ChatFavoriteResponseModel;

  factory _ChatFavoriteResponseModel.fromJson(Map<String, dynamic> json) =
      _$_ChatFavoriteResponseModel.fromJson;

  @override
  bool get result;
  @override
  String get code;
  @override
  DataListModel<ChatFavoriteModel> get data;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_ChatFavoriteResponseModelCopyWith<_$_ChatFavoriteResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}
