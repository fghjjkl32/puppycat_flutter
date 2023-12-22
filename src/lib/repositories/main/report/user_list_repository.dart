import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_response_model.dart';
import 'package:pet_mobile_social_flutter/services/main/report/report_service.dart';

class ReportRepository {
  late final ReportService _reportService;

  final Dio dio;

  ReportRepository({
    required this.dio,
  }) {
    _reportService = ReportService(dio, baseUrl: baseUrl);
  }

  Future<SelectButtonListModel> getCommentReportList() async {
    SelectButtonResponseModel responseModel = await _reportService.getCommentReportList();

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

  Future<SelectButtonListModel> getContentReportList() async {
    SelectButtonResponseModel responseModel = await _reportService.getContentReportList();

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
