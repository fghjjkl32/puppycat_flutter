import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/reason/reason_list_model.dart';
import 'package:pet_mobile_social_flutter/models/reason/reason_response_model.dart';
import 'package:pet_mobile_social_flutter/services/report/report_service.dart';

class ReportRepository {
  late final ReportService _reportService;

  final Dio dio;

  ReportRepository({
    required this.dio,
  }) {
    _reportService = ReportService(dio, baseUrl: baseUrl);
  }

  Future<ReasonListModel> getCommentReportList() async {
    ReasonResponseModel responseModel = await _reportService.getCommentReportList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ReportRepository',
        caller: 'getCommentReportList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'ReportRepository',
        caller: 'getCommentReportList',
      );
    }

    return responseModel.data!;
  }

  Future<ReasonListModel> getContentReportList() async {
    ReasonResponseModel responseModel = await _reportService.getContentReportList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ReportRepository',
        caller: 'getContentReportList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'ReportRepository',
        caller: 'getContentReportList',
      );
    }

    return responseModel.data!;
  }
}
