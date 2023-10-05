import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_list_model.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_list_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_data_info_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';

part 'list_response_model.freezed.dart';
part 'list_response_model.g.dart';

@freezed
class ListResponseModel with _$ListResponseModel {
  factory ListResponseModel({
    required bool result,
    required String code,
    required ListModel data,
    String? message,
  }) = _ListResponseModel;

  factory ListResponseModel.fromJson(Map<String, dynamic> json) => _$ListResponseModelFromJson(json);
}
