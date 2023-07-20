// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_data_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SettingDataListModel _$SettingDataListModelFromJson(Map<String, dynamic> json) {
  return _SettingDataListModel.fromJson(json);
}

/// @nodoc
mixin _$SettingDataListModel {
  List<MainListData> get mainList => throw _privateConstructorUsedError;
  List<SubListData> get subList => throw _privateConstructorUsedError;
  Map<String, int> get switchState => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingDataListModelCopyWith<SettingDataListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingDataListModelCopyWith<$Res> {
  factory $SettingDataListModelCopyWith(SettingDataListModel value,
          $Res Function(SettingDataListModel) then) =
      _$SettingDataListModelCopyWithImpl<$Res, SettingDataListModel>;
  @useResult
  $Res call(
      {List<MainListData> mainList,
      List<SubListData> subList,
      Map<String, int> switchState});
}

/// @nodoc
class _$SettingDataListModelCopyWithImpl<$Res,
        $Val extends SettingDataListModel>
    implements $SettingDataListModelCopyWith<$Res> {
  _$SettingDataListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mainList = null,
    Object? subList = null,
    Object? switchState = null,
  }) {
    return _then(_value.copyWith(
      mainList: null == mainList
          ? _value.mainList
          : mainList // ignore: cast_nullable_to_non_nullable
              as List<MainListData>,
      subList: null == subList
          ? _value.subList
          : subList // ignore: cast_nullable_to_non_nullable
              as List<SubListData>,
      switchState: null == switchState
          ? _value.switchState
          : switchState // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SettingDataListModelCopyWith<$Res>
    implements $SettingDataListModelCopyWith<$Res> {
  factory _$$_SettingDataListModelCopyWith(_$_SettingDataListModel value,
          $Res Function(_$_SettingDataListModel) then) =
      __$$_SettingDataListModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MainListData> mainList,
      List<SubListData> subList,
      Map<String, int> switchState});
}

/// @nodoc
class __$$_SettingDataListModelCopyWithImpl<$Res>
    extends _$SettingDataListModelCopyWithImpl<$Res, _$_SettingDataListModel>
    implements _$$_SettingDataListModelCopyWith<$Res> {
  __$$_SettingDataListModelCopyWithImpl(_$_SettingDataListModel _value,
      $Res Function(_$_SettingDataListModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mainList = null,
    Object? subList = null,
    Object? switchState = null,
  }) {
    return _then(_$_SettingDataListModel(
      mainList: null == mainList
          ? _value._mainList
          : mainList // ignore: cast_nullable_to_non_nullable
              as List<MainListData>,
      subList: null == subList
          ? _value._subList
          : subList // ignore: cast_nullable_to_non_nullable
              as List<SubListData>,
      switchState: null == switchState
          ? _value._switchState
          : switchState // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SettingDataListModel implements _SettingDataListModel {
  const _$_SettingDataListModel(
      {final List<MainListData> mainList = const [],
      final List<SubListData> subList = const [],
      final Map<String, int> switchState = const {}})
      : _mainList = mainList,
        _subList = subList,
        _switchState = switchState;

  factory _$_SettingDataListModel.fromJson(Map<String, dynamic> json) =>
      _$$_SettingDataListModelFromJson(json);

  final List<MainListData> _mainList;
  @override
  @JsonKey()
  List<MainListData> get mainList {
    if (_mainList is EqualUnmodifiableListView) return _mainList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mainList);
  }

  final List<SubListData> _subList;
  @override
  @JsonKey()
  List<SubListData> get subList {
    if (_subList is EqualUnmodifiableListView) return _subList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subList);
  }

  final Map<String, int> _switchState;
  @override
  @JsonKey()
  Map<String, int> get switchState {
    if (_switchState is EqualUnmodifiableMapView) return _switchState;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_switchState);
  }

  @override
  String toString() {
    return 'SettingDataListModel(mainList: $mainList, subList: $subList, switchState: $switchState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SettingDataListModel &&
            const DeepCollectionEquality().equals(other._mainList, _mainList) &&
            const DeepCollectionEquality().equals(other._subList, _subList) &&
            const DeepCollectionEquality()
                .equals(other._switchState, _switchState));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_mainList),
      const DeepCollectionEquality().hash(_subList),
      const DeepCollectionEquality().hash(_switchState));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingDataListModelCopyWith<_$_SettingDataListModel> get copyWith =>
      __$$_SettingDataListModelCopyWithImpl<_$_SettingDataListModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SettingDataListModelToJson(
      this,
    );
  }
}

abstract class _SettingDataListModel implements SettingDataListModel {
  const factory _SettingDataListModel(
      {final List<MainListData> mainList,
      final List<SubListData> subList,
      final Map<String, int> switchState}) = _$_SettingDataListModel;

  factory _SettingDataListModel.fromJson(Map<String, dynamic> json) =
      _$_SettingDataListModel.fromJson;

  @override
  List<MainListData> get mainList;
  @override
  List<SubListData> get subList;
  @override
  Map<String, int> get switchState;
  @override
  @JsonKey(ignore: true)
  _$$_SettingDataListModelCopyWith<_$_SettingDataListModel> get copyWith =>
      throw _privateConstructorUsedError;
}
