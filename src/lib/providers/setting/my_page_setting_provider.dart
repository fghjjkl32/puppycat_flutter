import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

class MyPageSettingNotifier extends StateNotifier<double> {
  MyPageSettingNotifier() : super(0.0);

  Future<void> getCacheSizeInMB() async {
    final Directory cacheDir = await getTemporaryDirectory();
    int sizeInBytes = 0;

    if (cacheDir.existsSync()) {
      final fileStream = cacheDir.list(recursive: true, followLinks: false);
      await for (FileSystemEntity file in fileStream) {
        if (file is File) {
          final fileSize = await file.length();
          sizeInBytes += fileSize;
        }
      }
    }

    // Convert to MB
    state = sizeInBytes / (1024 * 1024);
  }

  Future<void> clearCache(context) async {
    await DefaultCacheManager().emptyCache();

    toast(
      context: context,
      text: '저장 공간 정리 완료!',
      type: ToastType.purple,
    );

    getCacheSizeInMB();
  }
}

final myPageSettingProvider = StateNotifierProvider<MyPageSettingNotifier, double>(
  (ref) => MyPageSettingNotifier(),
);
