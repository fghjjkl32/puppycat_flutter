// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'policy_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PolicyItemModel _$PolicyItemModelFromJson(Map<String, dynamic> json) {
  return _PolicyItemModel.fromJson(json);
}

/// @nodoc
mixin _$PolicyItemModel {
  int get idx => throw _privateConstructorUsedError;
  String get required => throw _privateConstructorUsedError;
  String? get detail => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  bool get isAgreed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PolicyItemModelCopyWith<PolicyItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolicyItemModelCopyWith<$Res> {
  factory $PolicyItemModelCopyWith(
          PolicyItemModel value, $Res Function(PolicyItemModel) then) =
      _$PolicyItemModelCopyWithImpl<$Res, PolicyItemModel>;
  @useResult
  $Res call(
      {int idx, String required, String? detail, String? title, bool isAgreed});
}

/// @nodoc
class _$PolicyItemModelCopyWithImpl<$Res, $Val extends PolicyItemModel>
    implements $PolicyItemModelCopyWith<$Res> {
  _$PolicyItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = null,
    Object? required = null,
    Object? detail = freezed,
    Object? title = freezed,
    Object? isAgreed = null,
  }) {
    return _then(_value.copyWith(
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as String,
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      isAgreed: null == isAgreed
          ? _value.isAgreed
          : isAgreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PolicyItemModelCopyWith<$Res>
    implements $PolicyItemModelCopyWith<$Res> {
  factory _$$_PolicyItemModelCopyWith(
          _$_PolicyItemModel value, $Res Function(_$_PolicyItemModel) then) =
      __$$_PolicyItemModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int idx, String required, String? detail, String? title, bool isAgreed});
}

/// @nodoc
class __$$_PolicyItemModelCopyWithImpl<$Res>
    extends _$PolicyItemModelCopyWithImpl<$Res, _$_PolicyItemModel>
    implements _$$_PolicyItemModelCopyWith<$Res> {
  __$$_PolicyItemModelCopyWithImpl(
      _$_PolicyItemModel _value, $Res Function(_$_PolicyItemModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = null,
    Object? required = null,
    Object? detail = freezed,
    Object? title = freezed,
    Object? isAgreed = null,
  }) {
    return _then(_$_PolicyItemModel(
      idx: null == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as int,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as String,
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      isAgreed: null == isAgreed
          ? _value.isAgreed
          : isAgreed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PolicyItemModel implements _PolicyItemModel {
  _$_PolicyItemModel(
      {required this.idx,
      required this.required,
      this.detail,
      this.title,
      this.isAgreed = false});

  factory _$_PolicyItemModel.fromJson(Map<String, dynamic> json) =>
      _$$_PolicyItemModelFromJson(json);

  @override
  final int idx;
  @override
  final String required;
  @override
  final String? detail;
  @override
  final String? title;
  @override
  @JsonKey()
  final bool isAgreed;

  @override
  String toString() {
    return 'PolicyItemModel(idx: $idx, required: $required, detail: $detail, title: $title, isAgreed: $isAgreed)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PolicyItemModel &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isAgreed, isAgreed) ||
                other.isAgreed == isAgreed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idx, required, detail, title, isAgreed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PolicyItemModelCopyWith<_$_PolicyItemModel> get copyWith =>
      __$$_PolicyItemModelCopyWithImpl<_$_PolicyItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PolicyItemModelToJson(
      this,
    );
  }
}

abstract class _PolicyItemModel implements PolicyItemModel {
  factory _PolicyItemModel(
      {required final int idx,
      required final String required,
      final String? detail,
      final String? title,
      final bool isAgreed}) = _$_PolicyItemModel;

  factory _PolicyItemModel.fromJson(Map<String, dynamic> json) =
      _$_PolicyItemModel.fromJson;

  @override
  int get idx;
  @override
  String get required;
  @override
  String? get detail;
  @override
  String? get title;
  @override
  bool get isAgreed;
  @override
  @JsonKey(ignore: true)
  _$$_PolicyItemModelCopyWith<_$_PolicyItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}
