import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pet_mobile_social_flutter/models/search/search_table.dart';

part 'search_db_helper.g.dart';

@DriftDatabase(tables: [Searches])
class SearchDbHelper extends _$SearchDbHelper {
  SearchDbHelper() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Searche>> getAllSearches() => (select(searches)
        ..orderBy(
            [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
      .get();

  Future insertSearch(SearchesCompanion search) =>
      into(searches).insert(search);

  Future deleteSearch(Searche search) => delete(searches).delete(search);

  // Future insertSearch(Searche search) =>
  //     into(searches).insertOnConflictUpdate(search);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // path_provider 를 통해 앱의 저장위치 얻음
    final dbFolder = await getApplicationDocumentsDirectory();

    // 해당 경로에 파일 생성
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
