import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';

final dbHelperProvider = Provider<SearchDbHelper>((ref) => SearchDbHelper());

final searchesProvider = FutureProvider<List<Searche>>((ref) async {
  final db = ref.watch(dbHelperProvider);
  final searches = await db.getAllSearches();
  return searches;
});
