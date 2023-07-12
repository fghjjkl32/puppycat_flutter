// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  LoginStatus get loginStatus => throw _privateConstructorUsedError;
  int get idx => throw _privateConstructorUsedError;
  String get appKey => throw _privateConstructorUsedError;
  String get nick => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError; //email
  String get simpleId => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  int get isSimple => throw _privateConstructorUsedError;
  String get simpleType => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get passwordConfirm => throw _privateConstructorUsedError;
  String? get partner => throw _privateConstructorUsedError;
  String? get ci => throw _privateConstructorUsedError;
  String? get di => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get birth => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {LoginStatus loginStatus,
      int idx,
      String appKey,
      String nick,
      String id,
      String simpleId,
      String refreshToken,
      int isSimple,
      String simpleType,
      String accessToken,
      String password,
      String passwordConfirm,
      String? partner,
      String? ci,
      String? di,
      String? name,
      String? phone,
      String? birth,
      String? gender});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loginStatus = null,
    Object? idx = null,
    Object? appKey = null,
    Object? nick = null,
    Object? id = null,
    Object? simpleId = null,
    Object? refreshToken = null,
    Object? isSimple = null,
    Object? simpleType = null,
    Object? accessToken = null,
    Object? password = null,
    Object? passwordConfirm = null,
    Object? partner = freezed,
    Object? ci = freezed,
    Object? di = freezed,
    Object? name = freezed,
    Object? phone = freezed,
    Object? birth = freezed,
    Object? gender = freezed,
  }) {
    return _then(_value.copyWith(
      loginStatus: null == loginStatus
          ? _value.loginStatus
          : loginStatus // ignore: cast_nullable_to_non_nullable
              as LoginStatus,
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      appKey: null == appKey
          ? _value.appKey
          : appKey // ignore: cast_nullable_to_non_nullable
              as String,
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      simpleId: null == simpleId
          ? _value.simpleId
          : simpleId // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      isSimple: null == isSimple
          ? _value.isSimple
          : isSimple // ignore: cast_nullable_to_non_nullable
              as int,
      simpleType: null == simpleType
          ? _value.simpleType
          : simpleType // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirm: null == passwordConfirm
          ? _value.passwordConfirm
          : passwordConfirm // ignore: cast_nullable_to_non_nullable
              as String,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String?,
      ci: freezed == ci
          ? _value.ci
          : ci // ignore: cast_nullable_to_non_nullable
              as String?,
      di: freezed == di
          ? _value.di
          : di // ignore: cast_nullable_to_non_nullable
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
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$$_UserModelCopyWith(
          _$_UserModel value, $Res Function(_$_UserModel) then) =
      __$$_UserModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LoginStatus loginStatus,
      int idx,
      String appKey,
      String nick,
      String id,
      String simpleId,
      String refreshToken,
      int isSimple,
      String simpleType,
      String accessToken,
      String password,
      String passwordConfirm,
      String? partner,
      String? ci,
      String? di,
      String? name,
      String? phone,
      String? birth,
      String? gender});
}

/// @nodoc
class __$$_UserModelCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$_UserModel>
    implements _$$_UserModelCopyWith<$Res> {
  __$$_UserModelCopyWithImpl(
      _$_UserModel _value, $Res Function(_$_UserModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loginStatus = null,
    Object? idx = null,
    Object? appKey = null,
    Object? nick = null,
    Object? id = null,
    Object? simpleId = null,
    Object? refreshToken = null,
    Object? isSimple = null,
    Object? simpleType = null,
    Object? accessToken = null,
    Object? password = null,
    Object? passwordConfirm = null,
    Object? partner = freezed,
    Object? ci = freezed,
    Object? di = freezed,
    Object? name = freezed,
    Object? phone = freezed,
    Object? birth = freezed,
    Object? gender = freezed,
  }) {
    return _then(_$_UserModel(
      loginStatus: null == loginStatus
          ? _value.loginStatus
          : loginStatus // ignore: cast_nullable_to_non_nullable
              as LoginStatus,
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      appKey: null == appKey
          ? _value.appKey
          : appKey // ignore: cast_nullable_to_non_nullable
              as String,
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      simpleId: null == simpleId
          ? _value.simpleId
          : simpleId // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      isSimple: null == isSimple
          ? _value.isSimple
          : isSimple // ignore: cast_nullable_to_non_nullable
              as int,
      simpleType: null == simpleType
          ? _value.simpleType
          : simpleType // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirm: null == passwordConfirm
          ? _value.passwordConfirm
          : passwordConfirm // ignore: cast_nullable_to_non_nullable
              as String,
      partner: freezed == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as String?,
      ci: freezed == ci
          ? _value.ci
          : ci // ignore: cast_nullable_to_non_nullable
              as String?,
      di: freezed == di
          ? _value.di
          : di // ignore: cast_nullable_to_non_nullable
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
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserModel implements _UserModel {
  _$_UserModel(
      {required this.loginStatus,
      required this.idx,
      this.appKey = '',
      required this.nick,
      required this.id,
      required this.simpleId,
      required this.refreshToken,
      required this.isSimple,
      required this.simpleType,
      required this.accessToken,
      required this.password,
      required this.passwordConfirm,
      this.partner = '',
      this.ci,
      this.di,
      this.name,
      this.phone,
      this.birth,
      this.gender});

  factory _$_UserModel.fromJson(Map<String, dynamic> json) =>
      _$$_UserModelFromJson(json);

  @override
  final LoginStatus loginStatus;
  @override
  final int idx;
  @override
  @JsonKey()
  final String appKey;
  @override
  final String nick;
  @override
  final String id;
//email
  @override
  final String simpleId;
  @override
  final String refreshToken;
  @override
  final int isSimple;
  @override
  final String simpleType;
  @override
  final String accessToken;
  @override
  final String password;
  @override
  final String passwordConfirm;
  @override
  @JsonKey()
  final String? partner;
  @override
  final String? ci;
  @override
  final String? di;
  @override
  final String? name;
  @override
  final String? phone;
  @override
  final String? birth;
  @override
  final String? gender;

  @override
  String toString() {
    return 'UserModel(loginStatus: $loginStatus, idx: $idx, appKey: $appKey, nick: $nick, id: $id, simpleId: $simpleId, refreshToken: $refreshToken, isSimple: $isSimple, simpleType: $simpleType, accessToken: $accessToken, password: $password, passwordConfirm: $passwordConfirm, partner: $partner, ci: $ci, di: $di, name: $name, phone: $phone, birth: $birth, gender: $gender)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserModel &&
            (identical(other.loginStatus, loginStatus) ||
                other.loginStatus == loginStatus) &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.appKey, appKey) || other.appKey == appKey) &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.simpleId, simpleId) ||
                other.simpleId == simpleId) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.isSimple, isSimple) ||
                other.isSimple == isSimple) &&
            (identical(other.simpleType, simpleType) ||
                other.simpleType == simpleType) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordConfirm, passwordConfirm) ||
                other.passwordConfirm == passwordConfirm) &&
            (identical(other.partner, partner) || other.partner == partner) &&
            (identical(other.ci, ci) || other.ci == ci) &&
            (identical(other.di, di) || other.di == di) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.birth, birth) || other.birth == birth) &&
            (identical(other.gender, gender) || other.gender == gender));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        loginStatus,
        idx,
        appKey,
        nick,
        id,
        simpleId,
        refreshToken,
        isSimple,
        simpleType,
        accessToken,
        password,
        passwordConfirm,
        partner,
        ci,
        di,
        name,
        phone,
        birth,
        gender
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserModelCopyWith<_$_UserModel> get copyWith =>
      __$$_UserModelCopyWithImpl<_$_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserModelToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  factory _UserModel(
      {required final LoginStatus loginStatus,
      required final int idx,
      final String appKey,
      required final String nick,
      required final String id,
      required final String simpleId,
      required final String refreshToken,
      required final int isSimple,
      required final String simpleType,
      required final String accessToken,
      required final String password,
      required final String passwordConfirm,
      final String? partner,
      final String? ci,
      final String? di,
      final String? name,
      final String? phone,
      final String? birth,
      final String? gender}) = _$_UserModel;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$_UserModel.fromJson;

  @override
  LoginStatus get loginStatus;
  @override
  int get idx;
  @override
  String get appKey;
  @override
  String get nick;
  @override
  String get id;
  @override //email
  String get simpleId;
  @override
  String get refreshToken;
  @override
  int get isSimple;
  @override
  String get simpleType;
  @override
  String get accessToken;
  @override
  String get password;
  @override
  String get passwordConfirm;
  @override
  String? get partner;
  @override
  String? get ci;
  @override
  String? get di;
  @override
  String? get name;
  @override
  String? get phone;
  @override
  String? get birth;
  @override
  String? get gender;
  @override
  @JsonKey(ignore: true)
  _$$_UserModelCopyWith<_$_UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}
