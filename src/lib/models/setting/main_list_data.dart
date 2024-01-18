import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_list_data.freezed.dart';
part 'main_list_data.g.dart';

@freezed
class MainListData with _$MainListData {
  factory MainListData({
    String? regDateTz,
    String? regDate,
    int? state,
    int? type,
    int? idx,
  }) = _MainListData;

  factory MainListData.fromJson(Map<String, dynamic> json) =>
      _$MainListDataFromJson(json);
}
