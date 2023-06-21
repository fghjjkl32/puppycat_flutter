// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DataListModel<T> {
  List<T> get list => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DataListModelCopyWith<T, DataListModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataListModelCopyWith<T, $Res> {
  factory $DataListModelCopyWith(
          DataListModel<T> value, $Res Function(DataListModel<T>) then) =
      _$DataListModelCopyWithImpl<T, $Res, DataListModel<T>>;
  @useResult
  $Res call({List<T> list});
}

/// @nodoc
class _$DataListModelCopyWithImpl<T, $Res, $Val extends DataListModel<T>>
    implements $DataListModelCopyWith<T, $Res> {
  _$DataListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DataListModelCopyWith<T, $Res>
    implements $DataListModelCopyWith<T, $Res> {
  factory _$$_DataListModelCopyWith(
          _$_DataListModel<T> value, $Res Function(_$_DataListModel<T>) then) =
      __$$_DataListModelCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> list});
}

/// @nodoc
class __$$_DataListModelCopyWithImpl<T, $Res>
    extends _$DataListModelCopyWithImpl<T, $Res, _$_DataListModel<T>>
    implements _$$_DataListModelCopyWith<T, $Res> {
  __$$_DataListModelCopyWithImpl(
      _$_DataListModel<T> _value, $Res Function(_$_DataListModel<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
  }) {
    return _then(_$_DataListModel<T>(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$_DataListModel<T> implements _DataListModel<T> {
  _$_DataListModel({required final List<T> list}) : _list = list;

  final List<T> _list;
  @override
  List<T> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  String toString() {
    return 'DataListModel<$T>(list: $list)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DataListModel<T> &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_list));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DataListModelCopyWith<T, _$_DataListModel<T>> get copyWith =>
      __$$_DataListModelCopyWithImpl<T, _$_DataListModel<T>>(this, _$identity);
}

abstract class _DataListModel<T> implements DataListModel<T> {
  factory _DataListModel({required final List<T> list}) = _$_DataListModel<T>;

  @override
  List<T> get list;
  @override
  @JsonKey(ignore: true)
  _$$_DataListModelCopyWith<T, _$_DataListModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
