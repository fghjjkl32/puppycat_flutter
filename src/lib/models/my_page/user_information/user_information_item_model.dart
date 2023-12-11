import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_information_item_model.freezed.dart';
part 'user_information_item_model.g.dart';

@freezed
class UserInformationItemModel with _$UserInformationItemModel {
  factory UserInformationItemModel({
    String? nick,
    String? simpleType,
    String? simpleId,
    String? name,
    String? phone,
    String? intro,
    String? profileImgUrl,
    String? email,
    String? uuid,
    String? channelTalkHash,
    int? followerCnt,
    int? followCnt,
    int? blockedState,
    int? blockedMeState,
    int? followState,
    int? isBadge,
    String? ci,
    String? di,

    //img host
    String? imgDomain,
  }) = _UserInformationItemModel;

  factory UserInformationItemModel.fromJson(Map<String, dynamic> json) => _$UserInformationItemModelFromJson(json);
}
