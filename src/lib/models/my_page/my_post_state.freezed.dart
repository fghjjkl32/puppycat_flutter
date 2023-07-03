// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_post_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MyPostState _$MyPostStateFromJson(Map<String, dynamic> json) {
  return _MyPostState.fromJson(json);
}

/// @nodoc
mixin _$MyPostState {
  List<int> get selectOrder => throw _privateConstructorUsedError;
  int get currentOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MyPostStateCopyWith<MyPostState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyPostStateCopyWith<$Res> {
  factory $MyPostStateCopyWith(
          MyPostState value, $Res Function(MyPostState) then) =
      _$MyPostStateCopyWithImpl<$Res, MyPostState>;
  @useResult
  $Res call({List<int> selectOrder, int currentOrder});
}

/// @nodoc
class _$MyPostStateCopyWithImpl<$Res, $Val extends MyPostState>
    implements $MyPostStateCopyWith<$Res> {
  _$MyPostStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectOrder = null,
    Object? currentOrder = null,
  }) {
    return _then(_value.copyWith(
      selectOrder: null == selectOrder
          ? _value.selectOrder
          : selectOrder // ignore: cast_nullable_to_non_nullable
              as List<int>,
      currentOrder: null == currentOrder
          ? _value.currentOrder
          : currentOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MyPostStateCopyWith<$Res>
    implements $MyPostStateCopyWith<$Res> {
  factory _$$_MyPostStateCopyWith(
          _$_MyPostState value, $Res Function(_$_MyPostState) then) =
      __$$_MyPostStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<int> selectOrder, int currentOrder});
}

/// @nodoc
class __$$_MyPostStateCopyWithImpl<$Res>
    extends _$MyPostStateCopyWithImpl<$Res, _$_MyPostState>
    implements _$$_MyPostStateCopyWith<$Res> {
  __$$_MyPostStateCopyWithImpl(
      _$_MyPostState _value, $Res Function(_$_MyPostState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectOrder = null,
    Object? currentOrder = null,
  }) {
    return _then(_$_MyPostState(
      selectOrder: null == selectOrder
          ? _value._selectOrder
          : selectOrder // ignore: cast_nullable_to_non_nullable
              as List<int>,
      currentOrder: null == currentOrder
          ? _value.currentOrder
          : currentOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MyPostState implements _MyPostState {
  _$_MyPostState(
      {final List<int> selectOrder = const [], this.currentOrder = 1})
      : _selectOrder = selectOrder;

  factory _$_MyPostState.fromJson(Map<String, dynamic> json) =>
      _$$_MyPostStateFromJson(json);

  final List<int> _selectOrder;
  @override
  @JsonKey()
  List<int> get selectOrder {
    if (_selectOrder is EqualUnmodifiableListView) return _selectOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectOrder);
  }

  @override
  @JsonKey()
  final int currentOrder;

  @override
  String toString() {
    return 'MyPostState(selectOrder: $selectOrder, currentOrder: $currentOrder)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MyPostState &&
            const DeepCollectionEquality()
                .equals(other._selectOrder, _selectOrder) &&
            (identical(other.currentOrder, currentOrder) ||
                other.currentOrder == currentOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_selectOrder), currentOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MyPostStateCopyWith<_$_MyPostState> get copyWith =>
      __$$_MyPostStateCopyWithImpl<_$_MyPostState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MyPostStateToJson(
      this,
    );
  }
}

abstract class _MyPostState implements MyPostState {
  factory _MyPostState({final List<int> selectOrder, final int currentOrder}) =
      _$_MyPostState;

  factory _MyPostState.fromJson(Map<String, dynamic> json) =
      _$_MyPostState.fromJson;

  @override
  List<int> get selectOrder;
  @override
  int get currentOrder;
  @override
  @JsonKey(ignore: true)
  _$$_MyPostStateCopyWith<_$_MyPostState> get copyWith =>
      throw _privateConstructorUsedError;
}
