import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/content_like_user_list/content_like_user_list_service.dart';

class ContentLikeUserListRepository {
  final ContentLikeUserListService _contentLikeUserListService =
      ContentLikeUserListService(DioWrap.getDioWithCookie());

  Future<ContentLikeUserListResponseModel> getContentLikeUserList({
    required int contentsIdx,
    required int memberIdx,
    required int page,
  }) async {
    ContentLikeUserListResponseModel? contentLikeUserListResponseModel =
        await _contentLikeUserListService
            .getContentLikeUserList(contentsIdx, memberIdx, page)
            .catchError((Object obj) async {});

    if (contentLikeUserListResponseModel == null) {
      throw "error";
    }

    return contentLikeUserListResponseModel;
  }
}
