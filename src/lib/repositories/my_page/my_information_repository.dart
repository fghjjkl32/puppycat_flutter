import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_information/my_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_information/my_information_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/my_information/my_information_service.dart';

class MyInformationRepository {
  final MyInformationService _myInformationService =
      MyInformationService(DioWrap.getDioWithCookie());

  Future<List<MyInformationItemModel>> getMyInformation(int memberIdx) async {
    MyInformationResponseModel? myInformationResponseModel =
        await _myInformationService.getMyInformation(memberIdx);

    if (myInformationResponseModel == null) {
      throw "error";
    }

    return myInformationResponseModel.data.list;
  }
}
