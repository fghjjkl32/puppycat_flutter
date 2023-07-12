// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'params_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ParamsModel _$ParamsModelFromJson(Map<String, dynamic> json) {
  return _ParamsModel.fromJson(json);
}

/// @nodoc
mixin _$ParamsModel {
  int? get memberIdx => throw _privateConstructorUsedError;
  Pagination? get pagination => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;
  int? get pageSize => throw _privateConstructorUsedError;
  int? get page => throw _privateConstructorUsedError;
  int? get recordSize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParamsModelCopyWith<ParamsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParamsModelCopyWith<$Res> {
  factory $ParamsModelCopyWith(
          ParamsModel value, $Res Function(ParamsModel) then) =
      _$ParamsModelCopyWithImpl<$Res, ParamsModel>;
  @useResult
  $Res call(
      {int? memberIdx,
      Pagination? pagination,
      int? offset,
      int? limit,
      int? pageSize,
      int? page,
      int? recordSize});

  $PaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$ParamsModelCopyWithImpl<$Res, $Val extends ParamsModel>
    implements $ParamsModelCopyWith<$Res> {
  _$ParamsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberIdx = freezed,
    Object? pagination = freezed,
    Object? offset = freezed,
    Object? limit = freezed,
    Object? pageSize = freezed,
    Object? page = freezed,
    Object? recordSize = freezed,
  }) {
    return _then(_value.copyWith(
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as Pagination?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      recordSize: freezed == recordSize
          ? _value.recordSize
          : recordSize // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $PaginationCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ParamsModelCopyWith<$Res>
    implements $ParamsModelCopyWith<$Res> {
  factory _$$_ParamsModelCopyWith(
          _$_ParamsModel value, $Res Function(_$_ParamsModel) then) =
      __$$_ParamsModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? memberIdx,
      Pagination? pagination,
      int? offset,
      int? limit,
      int? pageSize,
      int? page,
      int? recordSize});

  @override
  $PaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$_ParamsModelCopyWithImpl<$Res>
    extends _$ParamsModelCopyWithImpl<$Res, _$_ParamsModel>
    implements _$$_ParamsModelCopyWith<$Res> {
  __$$_ParamsModelCopyWithImpl(
      _$_ParamsModel _value, $Res Function(_$_ParamsModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberIdx = freezed,
    Object? pagination = freezed,
    Object? offset = freezed,
    Object? limit = freezed,
    Object? pageSize = freezed,
    Object? page = freezed,
    Object? recordSize = freezed,
  }) {
    return _then(_$_ParamsModel(
      memberIdx: freezed == memberIdx
          ? _value.memberIdx
          : memberIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as Pagination?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      recordSize: freezed == recordSize
          ? _value.recordSize
          : recordSize // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ParamsModel implements _ParamsModel {
  const _$_ParamsModel(
      {this.memberIdx,
      this.pagination,
      this.offset,
      this.limit,
      this.pageSize,
      this.page,
      this.recordSize});

  factory _$_ParamsModel.fromJson(Map<String, dynamic> json) =>
      _$$_ParamsModelFromJson(json);

  @override
  final int? memberIdx;
  @override
  final Pagination? pagination;
  @override
  final int? offset;
  @override
  final int? limit;
  @override
  final int? pageSize;
  @override
  final int? page;
  @override
  final int? recordSize;

  @override
  String toString() {
    return 'ParamsModel(memberIdx: $memberIdx, pagination: $pagination, offset: $offset, limit: $limit, pageSize: $pageSize, page: $page, recordSize: $recordSize)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ParamsModel &&
            (identical(other.memberIdx, memberIdx) ||
                other.memberIdx == memberIdx) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.recordSize, recordSize) ||
                other.recordSize == recordSize));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, memberIdx, pagination, offset,
      limit, pageSize, page, recordSize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ParamsModelCopyWith<_$_ParamsModel> get copyWith =>
      __$$_ParamsModelCopyWithImpl<_$_ParamsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ParamsModelToJson(
      this,
    );
  }
}

abstract class _ParamsModel implements ParamsModel {
  const factory _ParamsModel(
      {final int? memberIdx,
      final Pagination? pagination,
      final int? offset,
      final int? limit,
      final int? pageSize,
      final int? page,
      final int? recordSize}) = _$_ParamsModel;

  factory _ParamsModel.fromJson(Map<String, dynamic> json) =
      _$_ParamsModel.fromJson;

  @override
  int? get memberIdx;
  @override
  Pagination? get pagination;
  @override
  int? get offset;
  @override
  int? get limit;
  @override
  int? get pageSize;
  @override
  int? get page;
  @override
  int? get recordSize;
  @override
  @JsonKey(ignore: true)
  _$$_ParamsModelCopyWith<_$_ParamsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

Pagination _$PaginationFromJson(Map<String, dynamic> json) {
  return _Pagination.fromJson(json);
}

/// @nodoc
mixin _$Pagination {
  int? get startPage => throw _privateConstructorUsedError;
  int? get limitStart => throw _privateConstructorUsedError;
  int? get totalPageCount => throw _privateConstructorUsedError;
  bool? get existNextPage => throw _privateConstructorUsedError;
  int? get endPage => throw _privateConstructorUsedError;
  bool? get existPrevPage => throw _privateConstructorUsedError;
  int? get totalRecordCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationCopyWith<Pagination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationCopyWith<$Res> {
  factory $PaginationCopyWith(
          Pagination value, $Res Function(Pagination) then) =
      _$PaginationCopyWithImpl<$Res, Pagination>;
  @useResult
  $Res call(
      {int? startPage,
      int? limitStart,
      int? totalPageCount,
      bool? existNextPage,
      int? endPage,
      bool? existPrevPage,
      int? totalRecordCount});
}

/// @nodoc
class _$PaginationCopyWithImpl<$Res, $Val extends Pagination>
    implements $PaginationCopyWith<$Res> {
  _$PaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPage = freezed,
    Object? limitStart = freezed,
    Object? totalPageCount = freezed,
    Object? existNextPage = freezed,
    Object? endPage = freezed,
    Object? existPrevPage = freezed,
    Object? totalRecordCount = freezed,
  }) {
    return _then(_value.copyWith(
      startPage: freezed == startPage
          ? _value.startPage
          : startPage // ignore: cast_nullable_to_non_nullable
              as int?,
      limitStart: freezed == limitStart
          ? _value.limitStart
          : limitStart // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPageCount: freezed == totalPageCount
          ? _value.totalPageCount
          : totalPageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      existNextPage: freezed == existNextPage
          ? _value.existNextPage
          : existNextPage // ignore: cast_nullable_to_non_nullable
              as bool?,
      endPage: freezed == endPage
          ? _value.endPage
          : endPage // ignore: cast_nullable_to_non_nullable
              as int?,
      existPrevPage: freezed == existPrevPage
          ? _value.existPrevPage
          : existPrevPage // ignore: cast_nullable_to_non_nullable
              as bool?,
      totalRecordCount: freezed == totalRecordCount
          ? _value.totalRecordCount
          : totalRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PaginationCopyWith<$Res>
    implements $PaginationCopyWith<$Res> {
  factory _$$_PaginationCopyWith(
          _$_Pagination value, $Res Function(_$_Pagination) then) =
      __$$_PaginationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? startPage,
      int? limitStart,
      int? totalPageCount,
      bool? existNextPage,
      int? endPage,
      bool? existPrevPage,
      int? totalRecordCount});
}

/// @nodoc
class __$$_PaginationCopyWithImpl<$Res>
    extends _$PaginationCopyWithImpl<$Res, _$_Pagination>
    implements _$$_PaginationCopyWith<$Res> {
  __$$_PaginationCopyWithImpl(
      _$_Pagination _value, $Res Function(_$_Pagination) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPage = freezed,
    Object? limitStart = freezed,
    Object? totalPageCount = freezed,
    Object? existNextPage = freezed,
    Object? endPage = freezed,
    Object? existPrevPage = freezed,
    Object? totalRecordCount = freezed,
  }) {
    return _then(_$_Pagination(
      startPage: freezed == startPage
          ? _value.startPage
          : startPage // ignore: cast_nullable_to_non_nullable
              as int?,
      limitStart: freezed == limitStart
          ? _value.limitStart
          : limitStart // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPageCount: freezed == totalPageCount
          ? _value.totalPageCount
          : totalPageCount // ignore: cast_nullable_to_non_nullable
              as int?,
      existNextPage: freezed == existNextPage
          ? _value.existNextPage
          : existNextPage // ignore: cast_nullable_to_non_nullable
              as bool?,
      endPage: freezed == endPage
          ? _value.endPage
          : endPage // ignore: cast_nullable_to_non_nullable
              as int?,
      existPrevPage: freezed == existPrevPage
          ? _value.existPrevPage
          : existPrevPage // ignore: cast_nullable_to_non_nullable
              as bool?,
      totalRecordCount: freezed == totalRecordCount
          ? _value.totalRecordCount
          : totalRecordCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Pagination implements _Pagination {
  const _$_Pagination(
      {this.startPage,
      this.limitStart,
      this.totalPageCount,
      this.existNextPage,
      this.endPage,
      this.existPrevPage,
      this.totalRecordCount});

  factory _$_Pagination.fromJson(Map<String, dynamic> json) =>
      _$$_PaginationFromJson(json);

  @override
  final int? startPage;
  @override
  final int? limitStart;
  @override
  final int? totalPageCount;
  @override
  final bool? existNextPage;
  @override
  final int? endPage;
  @override
  final bool? existPrevPage;
  @override
  final int? totalRecordCount;

  @override
  String toString() {
    return 'Pagination(startPage: $startPage, limitStart: $limitStart, totalPageCount: $totalPageCount, existNextPage: $existNextPage, endPage: $endPage, existPrevPage: $existPrevPage, totalRecordCount: $totalRecordCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Pagination &&
            (identical(other.startPage, startPage) ||
                other.startPage == startPage) &&
            (identical(other.limitStart, limitStart) ||
                other.limitStart == limitStart) &&
            (identical(other.totalPageCount, totalPageCount) ||
                other.totalPageCount == totalPageCount) &&
            (identical(other.existNextPage, existNextPage) ||
                other.existNextPage == existNextPage) &&
            (identical(other.endPage, endPage) || other.endPage == endPage) &&
            (identical(other.existPrevPage, existPrevPage) ||
                other.existPrevPage == existPrevPage) &&
            (identical(other.totalRecordCount, totalRecordCount) ||
                other.totalRecordCount == totalRecordCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, startPage, limitStart,
      totalPageCount, existNextPage, endPage, existPrevPage, totalRecordCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PaginationCopyWith<_$_Pagination> get copyWith =>
      __$$_PaginationCopyWithImpl<_$_Pagination>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PaginationToJson(
      this,
    );
  }
}

abstract class _Pagination implements Pagination {
  const factory _Pagination(
      {final int? startPage,
      final int? limitStart,
      final int? totalPageCount,
      final bool? existNextPage,
      final int? endPage,
      final bool? existPrevPage,
      final int? totalRecordCount}) = _$_Pagination;

  factory _Pagination.fromJson(Map<String, dynamic> json) =
      _$_Pagination.fromJson;

  @override
  int? get startPage;
  @override
  int? get limitStart;
  @override
  int? get totalPageCount;
  @override
  bool? get existNextPage;
  @override
  int? get endPage;
  @override
  bool? get existPrevPage;
  @override
  int? get totalRecordCount;
  @override
  @JsonKey(ignore: true)
  _$$_PaginationCopyWith<_$_Pagination> get copyWith =>
      throw _privateConstructorUsedError;
}
