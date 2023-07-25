// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_data_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FeedDataListModel _$FeedDataListModelFromJson(Map<String, dynamic> json) {
  return _FeedDataListModel.fromJson(json);
}

/// @nodoc
mixin _$FeedDataListModel {
  List<FeedData> get list => throw _privateConstructorUsedError;
  List<FeedMemberInfoListData>? get memberInfo =>
      throw _privateConstructorUsedError;
  String? get imgDomain => throw _privateConstructorUsedError;
  ParamsModel? get params => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadMoreError => throw _privateConstructorUsedError;
  bool get isLoadMoreDone => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedDataListModelCopyWith<FeedDataListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedDataListModelCopyWith<$Res> {
  factory $FeedDataListModelCopyWith(
          FeedDataListModel value, $Res Function(FeedDataListModel) then) =
      _$FeedDataListModelCopyWithImpl<$Res, FeedDataListModel>;
  @useResult
  $Res call(
      {List<FeedData> list,
      List<FeedMemberInfoListData>? memberInfo,
      String? imgDomain,
      ParamsModel? params,
      int page,
      bool isLoading,
      bool isLoadMoreError,
      bool isLoadMoreDone,
      int totalCount});

  $ParamsModelCopyWith<$Res>? get params;
}

/// @nodoc
class _$FeedDataListModelCopyWithImpl<$Res, $Val extends FeedDataListModel>
    implements $FeedDataListModelCopyWith<$Res> {
  _$FeedDataListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? memberInfo = freezed,
    Object? imgDomain = freezed,
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
              as List<FeedData>,
      memberInfo: freezed == memberInfo
          ? _value.memberInfo
          : memberInfo // ignore: cast_nullable_to_non_nullable
              as List<FeedMemberInfoListData>?,
      imgDomain: freezed == imgDomain
          ? _value.imgDomain
          : imgDomain // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$_FeedDataListModelCopyWith<$Res>
    implements $FeedDataListModelCopyWith<$Res> {
  factory _$$_FeedDataListModelCopyWith(_$_FeedDataListModel value,
          $Res Function(_$_FeedDataListModel) then) =
      __$$_FeedDataListModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<FeedData> list,
      List<FeedMemberInfoListData>? memberInfo,
      String? imgDomain,
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
class __$$_FeedDataListModelCopyWithImpl<$Res>
    extends _$FeedDataListModelCopyWithImpl<$Res, _$_FeedDataListModel>
    implements _$$_FeedDataListModelCopyWith<$Res> {
  __$$_FeedDataListModelCopyWithImpl(
      _$_FeedDataListModel _value, $Res Function(_$_FeedDataListModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? memberInfo = freezed,
    Object? imgDomain = freezed,
    Object? params = freezed,
    Object? page = null,
    Object? isLoading = null,
    Object? isLoadMoreError = null,
    Object? isLoadMoreDone = null,
    Object? totalCount = null,
  }) {
    return _then(_$_FeedDataListModel(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<FeedData>,
      memberInfo: freezed == memberInfo
          ? _value._memberInfo
          : memberInfo // ignore: cast_nullable_to_non_nullable
              as List<FeedMemberInfoListData>?,
      imgDomain: freezed == imgDomain
          ? _value.imgDomain
          : imgDomain // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$_FeedDataListModel implements _FeedDataListModel {
  const _$_FeedDataListModel(
      {final List<FeedData> list = const [],
      final List<FeedMemberInfoListData>? memberInfo,
      this.imgDomain,
      this.params,
      this.page = 1,
      this.isLoading = true,
      this.isLoadMoreError = false,
      this.isLoadMoreDone = false,
      this.totalCount = 0})
      : _list = list,
        _memberInfo = memberInfo;

  factory _$_FeedDataListModel.fromJson(Map<String, dynamic> json) =>
      _$$_FeedDataListModelFromJson(json);

  final List<FeedData> _list;
  @override
  @JsonKey()
  List<FeedData> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  final List<FeedMemberInfoListData>? _memberInfo;
  @override
  List<FeedMemberInfoListData>? get memberInfo {
    final value = _memberInfo;
    if (value == null) return null;
    if (_memberInfo is EqualUnmodifiableListView) return _memberInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? imgDomain;
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
    return 'FeedDataListModel(list: $list, memberInfo: $memberInfo, imgDomain: $imgDomain, params: $params, page: $page, isLoading: $isLoading, isLoadMoreError: $isLoadMoreError, isLoadMoreDone: $isLoadMoreDone, totalCount: $totalCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedDataListModel &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            const DeepCollectionEquality()
                .equals(other._memberInfo, _memberInfo) &&
            (identical(other.imgDomain, imgDomain) ||
                other.imgDomain == imgDomain) &&
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
      const DeepCollectionEquality().hash(_memberInfo),
      imgDomain,
      params,
      page,
      isLoading,
      isLoadMoreError,
      isLoadMoreDone,
      totalCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedDataListModelCopyWith<_$_FeedDataListModel> get copyWith =>
      __$$_FeedDataListModelCopyWithImpl<_$_FeedDataListModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedDataListModelToJson(
      this,
    );
  }
}

abstract class _FeedDataListModel implements FeedDataListModel {
  const factory _FeedDataListModel(
      {final List<FeedData> list,
      final List<FeedMemberInfoListData>? memberInfo,
      final String? imgDomain,
      final ParamsModel? params,
      final int page,
      final bool isLoading,
      final bool isLoadMoreError,
      final bool isLoadMoreDone,
      final int totalCount}) = _$_FeedDataListModel;

  factory _FeedDataListModel.fromJson(Map<String, dynamic> json) =
      _$_FeedDataListModel.fromJson;

  @override
  List<FeedData> get list;
  @override
  List<FeedMemberInfoListData>? get memberInfo;
  @override
  String? get imgDomain;
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
  _$$_FeedDataListModelCopyWith<_$_FeedDataListModel> get copyWith =>
      throw _privateConstructorUsedError;
}
