import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_info_state_provider.g.dart';


///TODO
///  myInformationStateProvider 와 헷갈릴 수 있는데 이 부분은 추후 정리 필요
///  마이페이지, 유저페이지용  API 와 모양이 유사할뿐 내용이 달라서 따로 작성
@Riverpod(keepAlive: true)
class MyInfoState extends _$MyInfoState {
  @override
  UserInformationItemModel build() {
    return UserInformationItemModel();
  }

  void getMyInfo(String memberIdx) async {
    UserInformationItemModel userInfoModel  = await ref.read(userInfoRepositoryProvider).getMyInfo(memberIdx);
    state = userInfoModel;
  }

  void updateMyChatInfo(UserInfoModel userInfoModel) async {
    var result = await ref.read(userInfoRepositoryProvider).updateMyChatInfo(userInfoModel);
  }

  bool checkChatInfo(UserInformationItemModel userInfoModel) {
    if(userInfoModel.chatMemberId == null) {
      return false;
    } else {
      return true;
    }
  }
}



