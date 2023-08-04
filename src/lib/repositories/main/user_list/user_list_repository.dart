import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/services/main/user_list/user_list_service.dart';

class UserListRepository {
  final UserListService _userListService =
      UserListService(DioWrap.getDioWithCookie());

  Future<UserListResponseModel> getFavoriteUserList({
    required loginMemberIdx,
  }) async {
    UserListResponseModel? contentsResponseModel =
        await _userListService.getFavoriteUserList(loginMemberIdx);

    if (contentsResponseModel == null) {
      throw "error";
    }

    return contentsResponseModel;
  }
}
