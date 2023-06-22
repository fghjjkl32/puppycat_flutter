// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LoginRequestModel _$LoginRequestModelFromJson(Map<String, dynamic> json) {
  return _LoginRequestModel.fromJson(json);
}

/// @nodoc
mixin _$LoginRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get simpleId => throw _privateConstructorUsedError;
  int get isSimple => throw _privateConstructorUsedError;
  String get simpleType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginRequestModelCopyWith<LoginRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestModelCopyWith<$Res> {
  factory $LoginRequestModelCopyWith(
          LoginRequestModel value, $Res Function(LoginRequestModel) then) =
      _$LoginRequestModelCopyWithImpl<$Res, LoginRequestModel>;
  @useResult
  $Res call({String id, String simpleId, int isSimple, String simpleType});
}

/// @nodoc
class _$LoginRequestModelCopyWithImpl<$Res, $Val extends LoginRequestModel>
    implements $LoginRequestModelCopyWith<$Res> {
  _$LoginRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? simpleId = null,
    Object? isSimple = null,
    Object? simpleType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      simpleId: null == simpleId
          ? _value.simpleId
          : simpleId // ignore: cast_nullable_to_non_nullable
              as String,
      isSimple: null == isSimple
          ? _value.isSimple
          : isSimple // ignore: cast_nullable_to_non_nullable
              as int,
      simpleType: null == simpleType
          ? _value.simpleType
          : simpleType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LoginRequestModelCopyWith<$Res>
    implements $LoginRequestModelCopyWith<$Res> {
  factory _$$_LoginRequestModelCopyWith(_$_LoginRequestModel value,
          $Res Function(_$_LoginRequestModel) then) =
      __$$_LoginRequestModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String simpleId, int isSimple, String simpleType});
}

/// @nodoc
class __$$_LoginRequestModelCopyWithImpl<$Res>
    extends _$LoginRequestModelCopyWithImpl<$Res, _$_LoginRequestModel>
    implements _$$_LoginRequestModelCopyWith<$Res> {
  __$$_LoginRequestModelCopyWithImpl(
      _$_LoginRequestModel _value, $Res Function(_$_LoginRequestModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? simpleId = null,
    Object? isSimple = null,
    Object? simpleType = null,
  }) {
    return _then(_$_LoginRequestModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      simpleId: null == simpleId
          ? _value.simpleId
          : simpleId // ignore: cast_nullable_to_non_nullable
              as String,
      isSimple: null == isSimple
          ? _value.isSimple
          : isSimple // ignore: cast_nullable_to_non_nullable
              as int,
      simpleType: null == simpleType
          ? _value.simpleType
          : simpleType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LoginRequestModel implements _LoginRequestModel {
  _$_LoginRequestModel(
      {required this.id,
      required this.simpleId,
      this.isSimple = 1,
      required this.simpleType});

  factory _$_LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$$_LoginRequestModelFromJson(json);

  @override
  final String id;
  @override
  final String simpleId;
  @override
  @JsonKey()
  final int isSimple;
  @override
  final String simpleType;

  @override
  String toString() {
    return 'LoginRequestModel(id: $id, simpleId: $simpleId, isSimple: $isSimple, simpleType: $simpleType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoginRequestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.simpleId, simpleId) ||
                other.simpleId == simpleId) &&
            (identical(other.isSimple, isSimple) ||
                other.isSimple == isSimple) &&
            (identical(other.simpleType, simpleType) ||
                other.simpleType == simpleType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, simpleId, isSimple, simpleType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LoginRequestModelCopyWith<_$_LoginRequestModel> get copyWith =>
      __$$_LoginRequestModelCopyWithImpl<_$_LoginRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LoginRequestModelToJson(
      this,
    );
  }
}

abstract class _LoginRequestModel implements LoginRequestModel {
  factory _LoginRequestModel(
      {required final String id,
      required final String simpleId,
      final int isSimple,
      required final String simpleType}) = _$_LoginRequestModel;

  factory _LoginRequestModel.fromJson(Map<String, dynamic> json) =
      _$_LoginRequestModel.fromJson;

  @override
  String get id;
  @override
  String get simpleId;
  @override
  int get isSimple;
  @override
  String get simpleType;
  @override
  @JsonKey(ignore: true)
  _$$_LoginRequestModelCopyWith<_$_LoginRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}
