import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';

class WalkCacheController {
  // final String fileName;
  //
  // WalkCacheController({
  //   required this.fileName,
  // });

  static Future writeWalkInfo(WalkStateModel walkInfo, String fileName, [FileMode mode = FileMode.writeOnlyAppend]) async {
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

  static Future<List<WalkStateModel>> readWalkInfo(String fileName, [bool isMoveToTotal = true]) async {
    final tempDir = await getTemporaryDirectory();
    File walkInfoFile = File('${tempDir.path}/${fileName}.txt');
    final readWalkInfo = walkInfoFile.readAsLinesSync();

    List<WalkStateModel> walkInfoList = [];

    for (var walkInfo in readWalkInfo) {
      final walkInfoDataList = walkInfo.split('|');
      List<String> petUuidList = walkInfoDataList[4].split('&');
      List calorieList = walkInfoDataList[5].split('&');

      Map<String, dynamic> calorie = {};

      for(int i = 0; i < petUuidList.length; i++) {
        Map<String, double> calorieMap = {
          'calorie' : double.parse(calorieList[i]),
        };
        calorie[petUuidList[i]] = calorieMap;
      }

      walkInfoList.add(
        WalkStateModel(
          dateTime: DateTime.parse(walkInfoDataList.last),
          latitude: double.parse(walkInfoDataList[0].split(',').first),
          longitude: double.parse(walkInfoDataList[0].split(',').last),
          distance: double.parse(walkInfoDataList[3]),
          walkTime: 0,
          walkCount: int.parse(walkInfoDataList[2]),
          calorie: calorie,
        ),
      );
    }

    // walkInfoFile.renameSync('${tempDir.path}/${fileName}_total.txt');

    if(isMoveToTotal) {
      final readWalkInfos = readWalkInfo.join('\n');
      File walkInfoTotal = await File('${tempDir.path}/${fileName}_total.txt').create();
      walkInfoTotal.writeAsStringSync('$readWalkInfos\n', mode: FileMode.writeOnlyAppend, flush: true);
      walkInfoFile.writeAsStringSync('');
    }

    return walkInfoList;
  }

}
