

import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'account_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class AccountService {
  factory AccountService(Dio dio, {String baseUrl}) = _AccountService;

  @PATCH('/member/restore/{memberIdx}')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel?> restoreAccount(@Path("memberIdx") String memberIdx, @Body() Map<String, dynamic> body);
}
