import 'package:drift/drift.dart';

part 'search_table.g.dart';

class Searches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get image => text().nullable()();
}
