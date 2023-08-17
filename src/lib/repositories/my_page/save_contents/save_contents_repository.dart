import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/save_contents/save_contents_service.dart';

class SaveContentsRepository {
  final SaveContentsService _saveContentsService =
      SaveContentsService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  Future<ContentResponseModel> getSaveContents(
      {required int memberIdx, required int page}) async {
    ContentResponseModel? saveContentsResponseModel =
        await _saveContentsService.getSaveContents(memberIdx, page);

    if (saveContentsResponseModel == null) {
      throw contentNullResponseModel;
    }

    return saveContentsResponseModel;
  }

  Future<FeedResponseModel> getSaveDetailContentList(
      {required int loginMemberIdx, required int page}) async {
    FeedResponseModel? saveContentsResponseModel = await _saveContentsService
        .getSaveDetailContentList(loginMemberIdx, page);

    if (saveContentsResponseModel == null) {
      throw feedNullResponseModel;
    }

    return saveContentsResponseModel;
  }
}
