import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedWriteCroppedFilesProvider =
    StateNotifierProvider<CroppedFilesNotifier, List<File>>((ref) {
  return CroppedFilesNotifier();
});

class CroppedFilesNotifier extends StateNotifier<List<File>> {
  CroppedFilesNotifier() : super([]);

  void removeAt(int index) {
    state = [...state]..removeAt(index);
  }

  void addAll(List<File> files) {
    for (var file in files) {
      if (!state.contains(file)) {
        state.add(file);
      }
    }
  }
}
