import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restrain_state_provider.g.dart';

enum RestrainType {
  none,
  login,
  writeAll,
  writeFeed,
  writeComment,
  walk,
}

@Riverpod(keepAlive: true)
class RestrainState extends _$RestrainState {
  @override
  List<RestrainType> build() {
    return [];
  }
}
