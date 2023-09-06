import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/services/main/report/report_service.dart';
import 'package:pet_mobile_social_flutter/services/main/user_list/user_list_service.dart';

class ReportRepository {
  late final ReportService _reportService;

  final Dio dio;

  ReportRepository({
    required this.dio,
  }) {
    _reportService = ReportService(dio, baseUrl: baseUrl);
  }

  Future<SelectButtonResponseModel> getCommentReportList() async {
    SelectButtonResponseModel? reportResponseModel = await _reportService.getCommentReportList();

    if (reportResponseModel == null) {
      throw "error";
    }

    return reportResponseModel;
  }

  Future<SelectButtonResponseModel> getContentReportList() async {
    SelectButtonResponseModel? reportResponseModel = await _reportService.getContentReportList();

    if (reportResponseModel == null) {
      throw "error";
    }

    return reportResponseModel;
  }
}
