import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_item_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_item_model.dart';

part 'list_model.freezed.dart';
part 'list_model.g.dart';

@freezed
class ListModel with _$ListModel {
  const factory ListModel({
    required List<ItemModel> list,
    @Default(true) bool isLoading,
    ParamsModel? params,
  }) = _ListModel;

  factory ListModel.fromJson(Map<String, dynamic> json) => _$ListModelFromJson(json);
}
