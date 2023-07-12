import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/user_contents/user_contents_service.dart';

class UserContentsRepository {
  final UserContentsService _userContentsService =
      UserContentsService(DioWrap.getDioWithCookie());

  Future<ContentResponseModel> getUserContents(
      {required int memberIdx, required int page}) async {
    ContentResponseModel? userContentsResponseModel =
        await _userContentsService.getUserContents(memberIdx, page);

    if (userContentsResponseModel == null) {
      throw "error";
    }

    return userContentsResponseModel;
  }
}
