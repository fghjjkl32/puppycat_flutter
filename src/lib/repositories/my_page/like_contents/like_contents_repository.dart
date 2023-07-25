import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/like_contents/like_contents_service.dart';

class LikeContentsRepository {
  final LikeContentsService _likeContentsService =
      LikeContentsService(DioWrap.getDioWithCookie());

  Future<ContentResponseModel> getLikeContents(
      {required int memberIdx, required int page}) async {
    ContentResponseModel? likeContentsResponseModel =
        await _likeContentsService.getLikeContents(memberIdx, page);

    if (likeContentsResponseModel == null) {
      throw "error";
    }

    return likeContentsResponseModel;
  }
}
