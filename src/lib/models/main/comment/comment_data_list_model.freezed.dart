// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_data_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CommentDataListModel _$CommentDataListModelFromJson(Map<String, dynamic> json) {
  return _CommentDataListModel.fromJson(json);
}

/// @nodoc
mixin _$CommentDataListModel {
  List<CommentData> get list => throw _privateConstructorUsedError;
  ParamsModel? get params => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadMoreError => throw _privateConstructorUsedError;
  bool get isLoadMoreDone => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentDataListModelCopyWith<CommentDataListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentDataListModelCopyWith<$Res> {
  factory $CommentDataListModelCopyWith(CommentDataListModel value,
          $Res Function(CommentDataListModel) then) =
      _$CommentDataListModelCopyWithImpl<$Res, CommentDataListModel>;
  @useResult
  $Res call(
      {List<CommentData> list,
      ParamsModel? params,
      int page,
      bool isLoading,
      bool isLoadMoreError,
      bool isLoadMoreDone,
      int totalCount});

  $ParamsModelCopyWith<$Res>? get params;
}

/// @nodoc
class _$CommentDataListModelCopyWithImpl<$Res,
        $Val extends CommentDataListModel>
    implements $CommentDataListModelCopyWith<$Res> {
  _$CommentDataListModelCopyWithImpl(this._value, this._then);

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
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<CommentData>,
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
abstract class _$$_CommentDataListModelCopyWith<$Res>
    implements $CommentDataListModelCopyWith<$Res> {
  factory _$$_CommentDataListModelCopyWith(_$_CommentDataListModel value,
          $Res Function(_$_CommentDataListModel) then) =
      __$$_CommentDataListModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CommentData> list,
      ParamsModel? params,
      int page,
      bool isLoading,
      bool isLoadMoreError,
      bool isLoadMoreDone,
      int totalCount});

  @override
  $ParamsModelCopyWith<$Res>? get params;
}

/// @nodoc
class __$$_CommentDataListModelCopyWithImpl<$Res>
    extends _$CommentDataListModelCopyWithImpl<$Res, _$_CommentDataListModel>
    implements _$$_CommentDataListModelCopyWith<$Res> {
  __$$_CommentDataListModelCopyWithImpl(_$_CommentDataListModel _value,
      $Res Function(_$_CommentDataListModel) _then)
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
  }) {
    return _then(_$_CommentDataListModel(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<CommentData>,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CommentDataListModel implements _CommentDataListModel {
  const _$_CommentDataListModel(
      {final List<CommentData> list = const [],
      this.params,
      this.page = 1,
      this.isLoading = true,
      this.isLoadMoreError = false,
      this.isLoadMoreDone = false,
      this.totalCount = 0})
      : _list = list;

  factory _$_CommentDataListModel.fromJson(Map<String, dynamic> json) =>
      _$$_CommentDataListModelFromJson(json);

  final List<CommentData> _list;
  @override
  @JsonKey()
  List<CommentData> get list {
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

  @override
  String toString() {
    return 'CommentDataListModel(list: $list, params: $params, page: $page, isLoading: $isLoading, isLoadMoreError: $isLoadMoreError, isLoadMoreDone: $isLoadMoreDone, totalCount: $totalCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CommentDataListModel &&
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
                other.totalCount == totalCount));
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
      totalCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CommentDataListModelCopyWith<_$_CommentDataListModel> get copyWith =>
      __$$_CommentDataListModelCopyWithImpl<_$_CommentDataListModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommentDataListModelToJson(
      this,
    );
  }
}

abstract class _CommentDataListModel implements CommentDataListModel {
  const factory _CommentDataListModel(
      {final List<CommentData> list,
      final ParamsModel? params,
      final int page,
      final bool isLoading,
      final bool isLoadMoreError,
      final bool isLoadMoreDone,
      final int totalCount}) = _$_CommentDataListModel;

  factory _CommentDataListModel.fromJson(Map<String, dynamic> json) =
      _$_CommentDataListModel.fromJson;

  @override
  List<CommentData> get list;
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
  @JsonKey(ignore: true)
  _$$_CommentDataListModelCopyWith<_$_CommentDataListModel> get copyWith =>
      throw _privateConstructorUsedError;
}
