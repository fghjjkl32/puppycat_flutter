// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_data_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ContentDataListModel _$ContentDataListModelFromJson(Map<String, dynamic> json) {
  return _ContentDataListModel.fromJson(json);
}

/// @nodoc
mixin _$ContentDataListModel {
  List<ContentImageData> get list => throw _privateConstructorUsedError;
  ParamsModel? get params => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadMoreError => throw _privateConstructorUsedError;
  bool get isLoadMoreDone => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentDataListModelCopyWith<ContentDataListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentDataListModelCopyWith<$Res> {
  factory $ContentDataListModelCopyWith(ContentDataListModel value,
          $Res Function(ContentDataListModel) then) =
      _$ContentDataListModelCopyWithImpl<$Res, ContentDataListModel>;
  @useResult
  $Res call(
      {List<ContentImageData> list,
      ParamsModel? params,
      int page,
      bool isLoading,
      bool isLoadMoreError,
      bool isLoadMoreDone,
      int totalCount});

  $ParamsModelCopyWith<$Res>? get params;
}

/// @nodoc
class _$ContentDataListModelCopyWithImpl<$Res,
        $Val extends ContentDataListModel>
    implements $ContentDataListModelCopyWith<$Res> {
  _$ContentDataListModelCopyWithImpl(this._value, this._then);

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
abstract class _$$_ContentDataListModelCopyWith<$Res>
    implements $ContentDataListModelCopyWith<$Res> {
  factory _$$_ContentDataListModelCopyWith(_$_ContentDataListModel value,
          $Res Function(_$_ContentDataListModel) then) =
      __$$_ContentDataListModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ContentImageData> list,
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
class __$$_ContentDataListModelCopyWithImpl<$Res>
    extends _$ContentDataListModelCopyWithImpl<$Res, _$_ContentDataListModel>
    implements _$$_ContentDataListModelCopyWith<$Res> {
  __$$_ContentDataListModelCopyWithImpl(_$_ContentDataListModel _value,
      $Res Function(_$_ContentDataListModel) _then)
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
    return _then(_$_ContentDataListModel(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ContentDataListModel implements _ContentDataListModel {
  const _$_ContentDataListModel(
      {final List<ContentImageData> list = const [],
      this.params,
      this.page = 1,
      this.isLoading = true,
      this.isLoadMoreError = false,
      this.isLoadMoreDone = false,
      this.totalCount = 0})
      : _list = list;

  factory _$_ContentDataListModel.fromJson(Map<String, dynamic> json) =>
      _$$_ContentDataListModelFromJson(json);

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

  @override
  String toString() {
    return 'ContentDataListModel(list: $list, params: $params, page: $page, isLoading: $isLoading, isLoadMoreError: $isLoadMoreError, isLoadMoreDone: $isLoadMoreDone, totalCount: $totalCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ContentDataListModel &&
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
  _$$_ContentDataListModelCopyWith<_$_ContentDataListModel> get copyWith =>
      __$$_ContentDataListModelCopyWithImpl<_$_ContentDataListModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ContentDataListModelToJson(
      this,
    );
  }
}

abstract class _ContentDataListModel implements ContentDataListModel {
  const factory _ContentDataListModel(
      {final List<ContentImageData> list,
      final ParamsModel? params,
      final int page,
      final bool isLoading,
      final bool isLoadMoreError,
      final bool isLoadMoreDone,
      final int totalCount}) = _$_ContentDataListModel;

  factory _ContentDataListModel.fromJson(Map<String, dynamic> json) =
      _$_ContentDataListModel.fromJson;

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
  @JsonKey(ignore: true)
  _$$_ContentDataListModelCopyWith<_$_ContentDataListModel> get copyWith =>
      throw _privateConstructorUsedError;
}
