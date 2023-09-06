import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_item_model.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_item_model.dart';

part 'restrain_write_list_model.freezed.dart';
part 'restrain_write_list_model.g.dart';

@freezed
class RestrainWriteListModel with _$RestrainWriteListModel {
  const factory RestrainWriteListModel({
    required RestrainWriteItemModel restrain,
    @Default(true) bool isLoading,
  }) = _RestrainWriteListModel;

  factory RestrainWriteListModel.fromJson(Map<String, dynamic> json) => _$RestrainWriteListModelFromJson(json);
}
