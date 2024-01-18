import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/models/reason/reason_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'withdrawal_service.g.dart';

@RestApi()
abstract class WithdrawalService {
  factory WithdrawalService(Dio dio, {String baseUrl}) = _WithdrawalService;

  @PUT('v1/member/out')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> withdrawalUser(@Body() Map<String, dynamic> body);

  @GET('v1/member/out/code')
  Future<ReasonResponseModel> getWithdrawalReasonList();

  @GET('v1/member/activity/info')
  Future<WithdrawalDetailResponseModel> getWithdrawalDetailList();
}
