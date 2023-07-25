import 'package:freezed_annotation/freezed_annotation.dart';
part 'params_model.freezed.dart';
part 'params_model.g.dart';

@freezed
class ParamsModel with _$ParamsModel {
  const factory ParamsModel({
    int? memberIdx,
    Pagination? pagination,
    int? offset,
    int? limit,
    int? pageSize,
    int? page,
    int? recordSize,
  }) = _ParamsModel;

  factory ParamsModel.fromJson(Map<String, dynamic> json) =>
      _$ParamsModelFromJson(json);
}

@freezed
class Pagination with _$Pagination {
  const factory Pagination({
    int? startPage,
    int? limitStart,
    int? totalPageCount,
    bool? existNextPage,
    int? endPage,
    bool? existPrevPage,
    int? totalRecordCount,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}
