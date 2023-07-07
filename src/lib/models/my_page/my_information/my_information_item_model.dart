import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_information_item_model.freezed.dart';
part 'my_information_item_model.g.dart';

@freezed
class MyInformationItemModel with _$MyInformationItemModel {
  factory MyInformationItemModel({
    int? memberIdx,
    String? nick,
    String? simpleType,
    String? name,
    String? phone,
    String? intro,
    String? profileImgUrl,
    String? email,
  }) = _MyInformationItemModel;

  factory MyInformationItemModel.fromJson(Map<String, dynamic> json) =>
      _$MyInformationItemModelFromJson(json);
}
