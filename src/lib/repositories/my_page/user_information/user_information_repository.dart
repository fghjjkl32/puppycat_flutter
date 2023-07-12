import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/user_information/user_information_service.dart';

class UserInformationRepository {
  final UserInformationService _userInformationService =
      UserInformationService(DioWrap.getDioWithCookie());

  Future<UserInformationResponseModel> getUserInformation(int memberIdx) async {
    UserInformationResponseModel? userInformationResponseModel =
        await _userInformationService.getUserInformation(memberIdx);

    if (userInformationResponseModel == null) {
      throw "error";
    }

    return userInformationResponseModel;
  }
}
