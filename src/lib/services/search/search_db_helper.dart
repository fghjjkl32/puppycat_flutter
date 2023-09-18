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
  int get schemaVersion => 6;

  Future<List<Searche>> getAllSearches() => (select(searches)..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])).get();

  Future insertSearch(SearchesCompanion search) async {
    final existingSearches = await getAllSearches();
    final existingSearch = existingSearches.firstWhere(
      (e) => e.name == search.name.value,
      orElse: () => Searche(id: 0),
    );

    if (existingSearch != null) {
      // 이미 존재하는 검색어를 삭제합니다.
      await deleteSearch(existingSearch);
    }

    // 새로운 검색어를 삽입합니다.
    into(searches).insert(search);
  }

  Future deleteSearch(Searche search) => delete(searches).delete(search);

  Future<void> deleteAllSearches() async {
    await delete(searches).go();
  }

  // Future insertSearch(Searche search) =>
  //     into(searches).insertOnConflictUpdate(search);

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // 데이터베이스가 처음 생성될 때 호출됩니다.
        onCreate: (Migrator m) async {
          await m.createTable(searches);
        },
        // 데이터베이스가 업데이트될 때 호출됩니다.
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            // 예: 버전 1에서 버전 2로 업데이트할 때 `content` 컬럼을 추가
            await m.addColumn(searches, searches.content);
            // 필요에 따라 추가적인 마이그레이션 작업을 수행합니다.
          }
          if (from == 5) {
            await m.addColumn(searches, searches.isBadge);
            await m.addColumn(searches, searches.created);
          }
          if (from == 6) {
            await m.addColumn(searches, searches.contentId);
          }
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            // 데이터베이스가 처음 생성될 때 수행되는 로직 (옵션)
          }
        },
      );
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
