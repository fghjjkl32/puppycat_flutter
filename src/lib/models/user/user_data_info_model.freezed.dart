// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DataInfoModel<T> {
  List<T> get info => throw _privateConstructorUsedError;
  String? get imgDomain => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DataInfoModelCopyWith<T, DataInfoModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataInfoModelCopyWith<T, $Res> {
  factory $DataInfoModelCopyWith(
          DataInfoModel<T> value, $Res Function(DataInfoModel<T>) then) =
      _$DataInfoModelCopyWithImpl<T, $Res, DataInfoModel<T>>;
  @useResult
  $Res call({List<T> info, String? imgDomain});
}

/// @nodoc
class _$DataInfoModelCopyWithImpl<T, $Res, $Val extends DataInfoModel<T>>
    implements $DataInfoModelCopyWith<T, $Res> {
  _$DataInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
    Object? imgDomain = freezed,
  }) {
    return _then(_value.copyWith(
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as List<T>,
      imgDomain: freezed == imgDomain
          ? _value.imgDomain
          : imgDomain // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DataInfoModelCopyWith<T, $Res>
    implements $DataInfoModelCopyWith<T, $Res> {
  factory _$$_DataInfoModelCopyWith(
          _$_DataInfoModel<T> value, $Res Function(_$_DataInfoModel<T>) then) =
      __$$_DataInfoModelCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> info, String? imgDomain});
}

/// @nodoc
class __$$_DataInfoModelCopyWithImpl<T, $Res>
    extends _$DataInfoModelCopyWithImpl<T, $Res, _$_DataInfoModel<T>>
    implements _$$_DataInfoModelCopyWith<T, $Res> {
  __$$_DataInfoModelCopyWithImpl(
      _$_DataInfoModel<T> _value, $Res Function(_$_DataInfoModel<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? info = null,
    Object? imgDomain = freezed,
  }) {
    return _then(_$_DataInfoModel<T>(
      info: null == info
          ? _value._info
          : info // ignore: cast_nullable_to_non_nullable
              as List<T>,
      imgDomain: freezed == imgDomain
          ? _value.imgDomain
          : imgDomain // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DataInfoModel<T> implements _DataInfoModel<T> {
  _$_DataInfoModel({required final List<T> info, this.imgDomain})
      : _info = info;

  final List<T> _info;
  @override
  List<T> get info {
    if (_info is EqualUnmodifiableListView) return _info;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_info);
  }

  @override
  final String? imgDomain;

  @override
  String toString() {
    return 'DataInfoModel<$T>(info: $info, imgDomain: $imgDomain)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DataInfoModel<T> &&
            const DeepCollectionEquality().equals(other._info, _info) &&
            (identical(other.imgDomain, imgDomain) ||
                other.imgDomain == imgDomain));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_info), imgDomain);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DataInfoModelCopyWith<T, _$_DataInfoModel<T>> get copyWith =>
      __$$_DataInfoModelCopyWithImpl<T, _$_DataInfoModel<T>>(this, _$identity);
}

abstract class _DataInfoModel<T> implements DataInfoModel<T> {
  factory _DataInfoModel(
      {required final List<T> info,
      final String? imgDomain}) = _$_DataInfoModel<T>;

  @override
  List<T> get info;
  @override
  String? get imgDomain;
  @override
  @JsonKey(ignore: true)
  _$$_DataInfoModelCopyWith<T, _$_DataInfoModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
