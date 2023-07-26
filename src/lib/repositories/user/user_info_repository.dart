import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_response_model.dart';
import 'package:pet_mobile_social_flutter/services/user/user_info_service.dart';

// final accountRepositoryProvider = Provider((ref) => AccountRepository());
final userInfoRepositoryProvider = Provider((ref) => UserInfoRepository());

class UserInfoRepository {
  final UserInfoService _userInfoService =
  UserInfoService(DioWrap.getDioWithCookie());

  Future<bool> restoreAccount(String simpleId) async {
    Map<String, dynamic> body = {
      "simpleId": simpleId,
    };

    ResponseModel? responseModel = await _userInfoService.restoreAccount(body);

    if (responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    return responseModel.result;
  }

  Future<UserInformationItemModel> getAccountInfo(String memberIdx) async {
    UserInformationResponseModel? responseModel = await _userInfoService.getMyInfo(memberIdx);

    if(responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    if(responseModel.data == null || responseModel.data.info.isEmpty) {
      ///TODO
      throw "empty error";
    }

    UserInformationItemModel infoModel = responseModel.data.info!.first;

    return infoModel;
  }


  //User Info
  Future<UserInformationResponseModel> getUserInformation(
      int loginMemberIdx, int memberIdx) async {
    UserInformationResponseModel? userInformationResponseModel =
    await _userInfoService.getUserInformation(
      loginMemberIdx,
      memberIdx,
    );

    if (userInformationResponseModel == null) {
      throw "error";
    }

    return userInformationResponseModel;
  }
}
