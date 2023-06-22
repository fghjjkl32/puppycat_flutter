import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/location_item.dart';

class LocationSearchNotifier extends StateNotifier<String> {
  LocationSearchNotifier() : super('');

  void onTextChanged(String newText) {
    state = newText;

    searchUser(newText);
  }

  List<LocationItem> _searchResult = [];
  List<LocationItem> get searchResult => _searchResult;

  void searchUser(String query) async {
    _searchResult = [
      LocationItem(name: '맥도날드 서초 GS점', subName: '서울특별시 서초구 반포대로 69(서초동)'),
      LocationItem(
          name: '서울특별시 서초구 서초대로 316', subName: '서울특별시 서초구 반포대로 69(서초동)'),
      LocationItem(
          name: '맥도날드 강남2호점', subName: '서울특별시 강남구 테헤란로 107 메디타워 2층 ..'),
    ].where((user) => user.name.contains(query)).toList();
  }
}

final feedWriteLocationSearchProvider =
    StateNotifierProvider<LocationSearchNotifier, String>(
  (ref) => LocationSearchNotifier(),
);
