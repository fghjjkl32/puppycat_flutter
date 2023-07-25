import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_information_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class UserInformationService {
  factory UserInformationService(Dio dio, {String baseUrl}) =
      _UserInformationService;

  @GET('/member/info/{memberIdx}?loginMemberIdx={loginMemberIdx}')
  Future<UserInformationResponseModel?> getUserInformation(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
  );
}
