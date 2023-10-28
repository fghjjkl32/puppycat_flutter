import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';

class WalkCacheController {
  // final String fileName;
  //
  // WalkCacheController({
  //   required this.fileName,
  // });

  static Future writeWalkInfo(WalkStateModel walkInfo, String fileName) async {
    List<String> walkInfoDataList = [];

    //좌표값
    walkInfoDataList.add('${walkInfo.latitude}, ${walkInfo.longitude}');
    //state
    walkInfoDataList.add('1');
    //steps
    walkInfoDataList.add('${walkInfo.walkCount}');
    //distance
    walkInfoDataList.add('${walkInfo.distance}');

    List<String> petUuidList = walkInfo.calorie.keys.toList();
    List calorieList = walkInfo.calorie.values.map((e) => e['calorie']).toList();
    //petUuid List
    walkInfoDataList.add(petUuidList.join('&').toString());
    //calorie List
    walkInfoDataList.add(calorieList.join('&').toString());
    //datetime
    walkInfoDataList.add('${walkInfo.dateTime}');

    String walkInfoData = walkInfoDataList.join('|');

    final tempDir = await getTemporaryDirectory();
    File walkInfoFile = await File('${tempDir.path}/${fileName}_local.txt').create();
    walkInfoFile.writeAsStringSync('$walkInfoData\n', mode: FileMode.writeOnlyAppend, flush: true);
  }
}
