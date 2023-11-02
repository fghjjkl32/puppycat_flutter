import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';

///TODO
/// - DateTime
/// - Coordinate X
/// - Coordinate Y
/// - Distance
/// - Walk Time
/// - Calorie

part 'walk_info_model.freezed.dart';
part 'walk_info_model.g.dart';

@freezed
class WalkStateModel with _$WalkStateModel{
  const WalkStateModel._();

  factory WalkStateModel({
    required DateTime dateTime,
    required double latitude,
    required double longitude,
    required double distance,
    required int walkTime,
    required int walkCount,
    // required double calorie,
    required Map<String, dynamic> calorie,
    required List<MyPetItemModel> petList,
  }) = _WalkStateModel;

  double getPetCalorie(String uuid) {
    if(calorie.containsKey(uuid)) {
      return calorie[uuid]['calorie'];
    } else {
      return 0.00;
    }
  }


  factory WalkStateModel.fromJson(Map<String, dynamic> json) => _$WalkStateModelFromJson(json);
}