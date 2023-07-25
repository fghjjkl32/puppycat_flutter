// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_information_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserInformationListModel _$UserInformationListModelFromJson(
    Map<String, dynamic> json) {
  return _UserInformationListModel.fromJson(json);
}

/// @nodoc
mixin _$UserInformationListModel {
  List<UserInformationItemModel> get list => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserInformationListModelCopyWith<UserInformationListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInformationListModelCopyWith<$Res> {
  factory $UserInformationListModelCopyWith(UserInformationListModel value,
          $Res Function(UserInformationListModel) then) =
      _$UserInformationListModelCopyWithImpl<$Res, UserInformationListModel>;
  @useResult
  $Res call({List<UserInformationItemModel> list, bool isLoading});
}

/// @nodoc
class _$UserInformationListModelCopyWithImpl<$Res,
        $Val extends UserInformationListModel>
    implements $UserInformationListModelCopyWith<$Res> {
  _$UserInformationListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<UserInformationItemModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserInformationListModelCopyWith<$Res>
    implements $UserInformationListModelCopyWith<$Res> {
  factory _$$_UserInformationListModelCopyWith(
          _$_UserInformationListModel value,
          $Res Function(_$_UserInformationListModel) then) =
      __$$_UserInformationListModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserInformationItemModel> list, bool isLoading});
}

/// @nodoc
class __$$_UserInformationListModelCopyWithImpl<$Res>
    extends _$UserInformationListModelCopyWithImpl<$Res,
        _$_UserInformationListModel>
    implements _$$_UserInformationListModelCopyWith<$Res> {
  __$$_UserInformationListModelCopyWithImpl(_$_UserInformationListModel _value,
      $Res Function(_$_UserInformationListModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? isLoading = null,
  }) {
    return _then(_$_UserInformationListModel(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<UserInformationItemModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserInformationListModel implements _UserInformationListModel {
  const _$_UserInformationListModel(
      {final List<UserInformationItemModel> list = const [],
      this.isLoading = true})
      : _list = list;

  factory _$_UserInformationListModel.fromJson(Map<String, dynamic> json) =>
      _$$_UserInformationListModelFromJson(json);

  final List<UserInformationItemModel> _list;
  @override
  @JsonKey()
  List<UserInformationItemModel> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'UserInformationListModel(list: $list, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserInformationListModel &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_list), isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserInformationListModelCopyWith<_$_UserInformationListModel>
      get copyWith => __$$_UserInformationListModelCopyWithImpl<
          _$_UserInformationListModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserInformationListModelToJson(
      this,
    );
  }
}

abstract class _UserInformationListModel implements UserInformationListModel {
  const factory _UserInformationListModel(
      {final List<UserInformationItemModel> list,
      final bool isLoading}) = _$_UserInformationListModel;

  factory _UserInformationListModel.fromJson(Map<String, dynamic> json) =
      _$_UserInformationListModel.fromJson;

  @override
  List<UserInformationItemModel> get list;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$_UserInformationListModelCopyWith<_$_UserInformationListModel>
      get copyWith => throw _privateConstructorUsedError;
}
