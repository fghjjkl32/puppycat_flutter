import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/keep_contents/keep_contents_service.dart';

class KeepContentsRepository {
  final KeepContentsService _keepContentsService =
      KeepContentsService(DioWrap.getDioWithCookie());

  Future<ContentResponseModel> getKeepContents(
      {required int memberIdx, required int page}) async {
    ContentResponseModel? keepContentsResponseModel =
        await _keepContentsService.getKeepContents(memberIdx, page);

    if (keepContentsResponseModel == null) {
      throw "error";
    }

    return keepContentsResponseModel;
  }
}
