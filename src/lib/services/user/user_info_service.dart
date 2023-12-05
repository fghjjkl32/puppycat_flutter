import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_info_service.g.dart';

@RestApi()
abstract class UserInfoService {
  factory UserInfoService(Dio dio, {String baseUrl}) = _UserInfoService;

  //My Info
  @PATCH('v1/member/restore')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> restoreAccount(@Body() Map<String, dynamic> body);

  @GET('v1/my/info')
  Future<UserInformationResponseModel> getMyInfo();

  @PUT('v1/my/info')
  Future<ResponseModel> updateMyInfo(
    @Body() FormData formData,
  );

  //User Info
  @GET('v1/member/info/{memberUuid}')
  Future<UserInformationResponseModel> getUserInformation(
    @Path("memberUuid") String memberUuid,
  );
}
