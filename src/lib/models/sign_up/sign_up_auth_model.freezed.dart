// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SignUpAuthModel _$SignUpAuthModelFromJson(Map<String, dynamic> json) {
  return _SignUpAuthModel.fromJson(json);
}

/// @nodoc
mixin _$SignUpAuthModel {
  String? get ci => throw _privateConstructorUsedError;
  String? get di => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get birth => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SignUpAuthModelCopyWith<SignUpAuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpAuthModelCopyWith<$Res> {
  factory $SignUpAuthModelCopyWith(
          SignUpAuthModel value, $Res Function(SignUpAuthModel) then) =
      _$SignUpAuthModelCopyWithImpl<$Res, SignUpAuthModel>;
  @useResult
  $Res call(
      {String? ci,
      String? di,
      String? gender,
      String? name,
      String? phone,
      String? birth});
}

/// @nodoc
class _$SignUpAuthModelCopyWithImpl<$Res, $Val extends SignUpAuthModel>
    implements $SignUpAuthModelCopyWith<$Res> {
  _$SignUpAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ci = freezed,
    Object? di = freezed,
    Object? gender = freezed,
    Object? name = freezed,
    Object? phone = freezed,
    Object? birth = freezed,
  }) {
    return _then(_value.copyWith(
      ci: freezed == ci
          ? _value.ci
          : ci // ignore: cast_nullable_to_non_nullable
              as String?,
      di: freezed == di
          ? _value.di
          : di // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      birth: freezed == birth
          ? _value.birth
          : birth // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SignUpAuthModelCopyWith<$Res>
    implements $SignUpAuthModelCopyWith<$Res> {
  factory _$$_SignUpAuthModelCopyWith(
          _$_SignUpAuthModel value, $Res Function(_$_SignUpAuthModel) then) =
      __$$_SignUpAuthModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? ci,
      String? di,
      String? gender,
      String? name,
      String? phone,
      String? birth});
}

/// @nodoc
class __$$_SignUpAuthModelCopyWithImpl<$Res>
    extends _$SignUpAuthModelCopyWithImpl<$Res, _$_SignUpAuthModel>
    implements _$$_SignUpAuthModelCopyWith<$Res> {
  __$$_SignUpAuthModelCopyWithImpl(
      _$_SignUpAuthModel _value, $Res Function(_$_SignUpAuthModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ci = freezed,
    Object? di = freezed,
    Object? gender = freezed,
    Object? name = freezed,
    Object? phone = freezed,
    Object? birth = freezed,
  }) {
    return _then(_$_SignUpAuthModel(
      ci: freezed == ci
          ? _value.ci
          : ci // ignore: cast_nullable_to_non_nullable
              as String?,
      di: freezed == di
          ? _value.di
          : di // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      birth: freezed == birth
          ? _value.birth
          : birth // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SignUpAuthModel implements _SignUpAuthModel {
  _$_SignUpAuthModel(
      {this.ci, this.di, this.gender, this.name, this.phone, this.birth});

  factory _$_SignUpAuthModel.fromJson(Map<String, dynamic> json) =>
      _$$_SignUpAuthModelFromJson(json);

  @override
  final String? ci;
  @override
  final String? di;
  @override
  final String? gender;
  @override
  final String? name;
  @override
  final String? phone;
  @override
  final String? birth;

  @override
  String toString() {
    return 'SignUpAuthModel(ci: $ci, di: $di, gender: $gender, name: $name, phone: $phone, birth: $birth)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SignUpAuthModel &&
            (identical(other.ci, ci) || other.ci == ci) &&
            (identical(other.di, di) || other.di == di) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.birth, birth) || other.birth == birth));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, ci, di, gender, name, phone, birth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SignUpAuthModelCopyWith<_$_SignUpAuthModel> get copyWith =>
      __$$_SignUpAuthModelCopyWithImpl<_$_SignUpAuthModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SignUpAuthModelToJson(
      this,
    );
  }
}

abstract class _SignUpAuthModel implements SignUpAuthModel {
  factory _SignUpAuthModel(
      {final String? ci,
      final String? di,
      final String? gender,
      final String? name,
      final String? phone,
      final String? birth}) = _$_SignUpAuthModel;

  factory _SignUpAuthModel.fromJson(Map<String, dynamic> json) =
      _$_SignUpAuthModel.fromJson;

  @override
  String? get ci;
  @override
  String? get di;
  @override
  String? get gender;
  @override
  String? get name;
  @override
  String? get phone;
  @override
  String? get birth;
  @override
  @JsonKey(ignore: true)
  _$$_SignUpAuthModelCopyWith<_$_SignUpAuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}
