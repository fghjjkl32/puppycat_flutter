import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/menu_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_data_info_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';

part 'menu_response_model.freezed.dart';
part 'menu_response_model.g.dart';

@freezed
class MenuResponseModel with _$MenuResponseModel {
  factory MenuResponseModel({
    required bool result,
    required String code,
    required List<MenuItemModel> data,
    String? message,
  }) = _MenuResponseModel;

  factory MenuResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MenuResponseModelFromJson(json);
}
