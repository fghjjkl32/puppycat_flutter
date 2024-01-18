import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/reason/reason_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'report_service.g.dart';

@RestApi()
abstract class ReportService {
  factory ReportService(Dio dio, {String baseUrl}) = _ReportService;

  @GET('v1/comment/report/code')
  Future<ReasonResponseModel> getCommentReportList();

  @GET('v1/contents/report/code')
  Future<ReasonResponseModel> getContentReportList();
}
