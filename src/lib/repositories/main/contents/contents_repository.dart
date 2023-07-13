import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/services/main/contents/contents_service.dart';

class ContentsRepository {
  final ContentsService _contentsService =
      ContentsService(DioWrap.getDioWithCookie());

  Future<ResponseModel> deleteContents(
      {required int memberIdx, required String idx}) async {
    ResponseModel? contentsResponseModel =
        await _contentsService.deleteContents(memberIdx, idx);

    if (contentsResponseModel == null) {
      throw "error";
    }

    return contentsResponseModel;
  }
}
