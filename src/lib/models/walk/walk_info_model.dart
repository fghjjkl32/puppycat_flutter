import 'package:freezed_annotation/freezed_annotation.dart';

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
  factory WalkStateModel({
    required DateTime dateTime,
    required double latitude,
    required double longitude,
    required double distance,
    required int walkTime,
    required int walkCount,
    required double calorie,
  }) = _WalkStateModel;

  factory WalkStateModel.fromJson(Map<String, dynamic> json) => _$WalkStateModelFromJson(json);
}