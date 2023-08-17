import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'withdrawal_service.g.dart';

abstract class WithdrawalService {
  factory WithdrawalService(Dio dio, {String baseUrl}) = _WithdrawalService;

  @PUT('/member/out')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel?> withdrawalUser(@Body() Map<String, dynamic> body);
}
