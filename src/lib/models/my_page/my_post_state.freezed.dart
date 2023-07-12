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
  List<ContentImageData> get list => throw _privateConstructorUsedError;
  ParamsModel? get params => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadMoreError => throw _privateConstructorUsedError;
  bool get isLoadMoreDone => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  List<int> get selectOrder => throw _privateConstructorUsedError; // 추가
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
  $Res call(
      {List<ContentImageData> list,
      ParamsModel? params,
      int page,
      bool isLoading,
      bool isLoadMoreError,
      bool isLoadMoreDone,
      int totalCount,
      List<int> selectOrder,
      int currentOrder});

  $ParamsModelCopyWith<$Res>? get params;
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
    Object? list = null,
    Object? params = freezed,
    Object? page = null,
    Object? isLoading = null,
    Object? isLoadMoreError = null,
    Object? isLoadMoreDone = null,
    Object? totalCount = null,
    Object? selectOrder = null,
    Object? currentOrder = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ContentImageData>,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as ParamsModel?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadMoreError: null == isLoadMoreError
          ? _value.isLoadMoreError
          : isLoadMoreError // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadMoreDone: null == isLoadMoreDone
          ? _value.isLoadMoreDone
          : isLoadMoreDone // ignore: cast_nullable_to_non_nullable
              as bool,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
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

  @override
  @pragma('vm:prefer-inline')
  $ParamsModelCopyWith<$Res>? get params {
    if (_value.params == null) {
      return null;
    }

    return $ParamsModelCopyWith<$Res>(_value.params!, (value) {
      return _then(_value.copyWith(params: value) as $Val);
    });
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
  $Res call(
      {List<ContentImageData> list,
      ParamsModel? params,
      int page,
      bool isLoading,
      bool isLoadMoreError,
      bool isLoadMoreDone,
      int totalCount,
      List<int> selectOrder,
      int currentOrder});

  @override
  $ParamsModelCopyWith<$Res>? get params;
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
    Object? list = null,
    Object? params = freezed,
    Object? page = null,
    Object? isLoading = null,
    Object? isLoadMoreError = null,
    Object? isLoadMoreDone = null,
    Object? totalCount = null,
    Object? selectOrder = null,
    Object? currentOrder = null,
  }) {
    return _then(_$_MyPostState(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ContentImageData>,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as ParamsModel?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadMoreError: null == isLoadMoreError
          ? _value.isLoadMoreError
          : isLoadMoreError // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadMoreDone: null == isLoadMoreDone
          ? _value.isLoadMoreDone
          : isLoadMoreDone // ignore: cast_nullable_to_non_nullable
              as bool,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
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
      {final List<ContentImageData> list = const [],
      this.params,
      this.page = 1,
      this.isLoading = true,
      this.isLoadMoreError = false,
      this.isLoadMoreDone = false,
      this.totalCount = 0,
      final List<int> selectOrder = const [],
      this.currentOrder = 1})
      : _list = list,
        _selectOrder = selectOrder;

  factory _$_MyPostState.fromJson(Map<String, dynamic> json) =>
      _$$_MyPostStateFromJson(json);

  final List<ContentImageData> _list;
  @override
  @JsonKey()
  List<ContentImageData> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  final ParamsModel? params;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadMoreError;
  @override
  @JsonKey()
  final bool isLoadMoreDone;
  @override
  @JsonKey()
  final int totalCount;
  final List<int> _selectOrder;
  @override
  @JsonKey()
  List<int> get selectOrder {
    if (_selectOrder is EqualUnmodifiableListView) return _selectOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectOrder);
  }

// 추가
  @override
  @JsonKey()
  final int currentOrder;

  @override
  String toString() {
    return 'MyPostState(list: $list, params: $params, page: $page, isLoading: $isLoading, isLoadMoreError: $isLoadMoreError, isLoadMoreDone: $isLoadMoreDone, totalCount: $totalCount, selectOrder: $selectOrder, currentOrder: $currentOrder)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MyPostState &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.params, params) || other.params == params) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadMoreError, isLoadMoreError) ||
                other.isLoadMoreError == isLoadMoreError) &&
            (identical(other.isLoadMoreDone, isLoadMoreDone) ||
                other.isLoadMoreDone == isLoadMoreDone) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            const DeepCollectionEquality()
                .equals(other._selectOrder, _selectOrder) &&
            (identical(other.currentOrder, currentOrder) ||
                other.currentOrder == currentOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_list),
      params,
      page,
      isLoading,
      isLoadMoreError,
      isLoadMoreDone,
      totalCount,
      const DeepCollectionEquality().hash(_selectOrder),
      currentOrder);

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
  factory _MyPostState(
      {final List<ContentImageData> list,
      final ParamsModel? params,
      final int page,
      final bool isLoading,
      final bool isLoadMoreError,
      final bool isLoadMoreDone,
      final int totalCount,
      final List<int> selectOrder,
      final int currentOrder}) = _$_MyPostState;

  factory _MyPostState.fromJson(Map<String, dynamic> json) =
      _$_MyPostState.fromJson;

  @override
  List<ContentImageData> get list;
  @override
  ParamsModel? get params;
  @override
  int get page;
  @override
  bool get isLoading;
  @override
  bool get isLoadMoreError;
  @override
  bool get isLoadMoreDone;
  @override
  int get totalCount;
  @override
  List<int> get selectOrder;
  @override // 추가
  int get currentOrder;
  @override
  @JsonKey(ignore: true)
  _$$_MyPostStateCopyWith<_$_MyPostState> get copyWith =>
      throw _privateConstructorUsedError;
}
