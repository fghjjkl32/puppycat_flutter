import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_info_service.g.dart';

@RestApi()
abstract class UserInfoService {
  factory UserInfoService(Dio dio, {String baseUrl}) = _UserInfoService;

  //My Info
  @PATCH('/member/restore')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel?> restoreAccount(@Body() Map<String, dynamic> body);

  @GET('/my/info')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<UserInformationResponseModel?> getMyInfo(@Query("memberIdx") String memberIdx);

  @PUT('/my/info')
  Future<ResponseModel> updateMyInfo(
    @Body() FormData formData,
  );

  //User Info
  @GET('/member/info/{memberIdx}?loginMemberIdx={loginMemberIdx}')
  Future<UserInformationResponseModel?> getUserInformation(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
  );

  @GET('/member/info/{memberIdx}')
  Future<UserInformationResponseModel?> getLogoutUserInformation(
    @Path("memberIdx") int memberIdx,
  );
}
