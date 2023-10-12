import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/pet_detail/pet_detail_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/my_pet/my_pet_service.dart';
import 'package:pet_mobile_social_flutter/services/search/search_service.dart';
import 'package:http_parser/http_parser.dart';

class MyPetListRepository {
  late final MyPetService _myPetService;

  final Dio dio;

  MyPetListRepository({
    required this.dio,
  }) {
    _myPetService = MyPetService(dio, baseUrl: baseUrl);
  }

  Future<MyPetListResponseModel> getMyPetList({
    required int memberIdx,
    required int loginMemberIdx,
    required int page,
    int limit = 20,
  }) async {
    MyPetListResponseModel? responseModel = await _myPetService.getMyPetList(memberIdx, loginMemberIdx, limit, page).catchError((Object obj) async {
      print('obj : $obj');
    });

    if (responseModel == null) {
      return MyPetListResponseModel(
        result: false,
        code: "",
        data: MyPetListModel(
          list: [],
        ),
        message: "",
      );
    }

    return responseModel;
  }

  Future<MyPetListResponseModel> getMyPetDetailList({
    required int idx,
    required int loginMemberIdx,
  }) async {
    MyPetListResponseModel? responseModel = await _myPetService.getMyPetDetailList(idx, loginMemberIdx).catchError((Object obj) async {});

    if (responseModel == null) {
      return MyPetListResponseModel(
        result: false,
        code: "",
        data: MyPetListModel(
          list: [],
        ),
        message: "",
      );
    }

    return responseModel;
  }
}
