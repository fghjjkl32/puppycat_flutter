import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/tag_contents/tag_contents_service.dart';

class TagContentsRepository {
  final TagContentsService _tagContentsService =
      TagContentsService(DioWrap.getDioWithCookie());

  Future<ContentResponseModel> getTagContents(
      {required int memberIdx, required int page}) async {
    ContentResponseModel? tagContentsResponseModel =
        await _tagContentsService.getTagContents(memberIdx, page);

    if (tagContentsResponseModel == null) {
      throw "error";
    }

    return tagContentsResponseModel;
  }
}
