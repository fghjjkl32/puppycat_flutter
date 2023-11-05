import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

class WalkCacheController {
  // final String fileName;
  //
  // WalkCacheController({
  //   required this.fileName,
  // });

  static Future writeXMLWalkInfo(List<WalkStateModel> walkInfoList, List<MyPetItemModel> petList, String fileName, [FileMode mode = FileMode.writeOnly]) async {
    final tempDir = await getTemporaryDirectory();
    final localXmlFile = File('${tempDir.path}/$fileName.xml');
    XmlDocument document;//  = builder.buildDocument();

    if (localXmlFile.existsSync()) {
      document = XmlDocument.parse(localXmlFile.readAsStringSync());
    } else {
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('root', nest: () {
        builder.element('petList', nest: () {
          for (var element in petList) {
            builder.element(element.uuid.toString(), nest: element.toJson());
          }
        });
      });

      document = builder.buildDocument();
    }

    for (var walkInfo in walkInfoList) {
        final builder = XmlBuilder();
        builder.element('walkInfoList', nest: () {
          // builder.element('dateTime', nest: walkInfo.dateTime.toUtc().toString());
          builder.element('dateTime', nest: DateFormat('yyyy-MM-dd hh:mm:ss').format(walkInfo.dateTime.toUtc()),);
          builder.element('latitude', nest: walkInfo.latitude);
          builder.element('longitude', nest: walkInfo.longitude);
          builder.element('distance', nest: walkInfo.distance);
          builder.element('walkTime', nest: walkInfo.walkTime);
          builder.element('walkCount', nest: walkInfo.walkCount);
          builder.element('calorie', nest: () {
            for (var element in walkInfo.calorie.keys) {
              builder.element(element, nest: () {
                builder.element('calorie', nest: walkInfo.calorie[element]['calorie']);
              });
            }
          });
        });

        document.rootElement.children.add(builder
            .buildDocument()
            .firstChild!
            .copy());
    }

    // for (var walkInfo in walkInfoList) {
    //   if (localXmlFile.existsSync()) {
    //     document = XmlDocument.parse(localXmlFile.readAsStringSync());
    //
    //     final builder = XmlBuilder();
    //     // builder.processing('xml', 'version="1.0"');
    //     builder.element('walkInfoList', nest: () {
    //       builder.element('dateTime', nest: walkInfo.dateTime.toUtc().toString());
    //       builder.element('latitude', nest: walkInfo.latitude);
    //       builder.element('longitude', nest: walkInfo.longitude);
    //       builder.element('distance', nest: walkInfo.distance);
    //       builder.element('walkTime', nest: walkInfo.walkTime);
    //       builder.element('walkCount', nest: walkInfo.walkCount);
    //       builder.element('calorie', nest: () {
    //         for (var element in walkInfo.petList) {
    //           builder.element(element.uuid.toString(), nest: () {
    //             builder.element('calorie', nest: walkInfo.calorie[element.uuid]['calorie']);
    //           });
    //         }
    //       });
    //     });
    //
    //     document.rootElement.children.add(builder
    //         .buildDocument()
    //         .firstChild!
    //         .copy());
    //   } else {
    //     final builder = XmlBuilder();
    //     builder.processing('xml', 'version="1.0"');
    //     builder.element('root', nest: () {
    //       builder.element('petList', nest: () {
    //         for (var element in walkInfo.petList) {
    //           builder.element(element.uuid.toString(), nest: element.toJson());
    //         }
    //       });
    //       builder.element('walkInfoList', nest: () {
    //         builder.element('dateTime', nest: walkInfo.dateTime.toUtc().toString());
    //         builder.element('isTransfer', nest: 0);
    //         builder.element('latitude', nest: walkInfo.latitude);
    //         builder.element('longitude', nest: walkInfo.longitude);
    //         builder.element('distance', nest: walkInfo.distance);
    //         builder.element('walkTime', nest: walkInfo.walkTime);
    //         builder.element('walkCount', nest: walkInfo.walkCount);
    //         builder.element('calorie', nest: () {
    //           for (var element in walkInfo.petList) {
    //             builder.element(element.uuid.toString(), nest: () {
    //               builder.element('calorie', nest: walkInfo.calorie[element.uuid]['calorie']);
    //             });
    //           }
    //         });
    //       });
    //     });
    //
    //     document = builder.buildDocument();
    //   }
    // }


    // if(document == null) {
    //   return;
    // }

    localXmlFile.writeAsStringSync('${document.toXmlString(pretty: true, indent: '\t')}\n', mode: FileMode.writeOnly, flush: true);
  }

  static Future<List<WalkStateModel>> readXMLWalkInfo(String fileName, [bool isMoveToTotal = true]) async {
    final tempDir = await getTemporaryDirectory();
    File walkInfoFile = File('${tempDir.path}/${fileName}.xml');

    if (!walkInfoFile.existsSync()) {
      return [];
    }
    final document = XmlDocument.parse(walkInfoFile.readAsStringSync());

    //함께 산책한 반려동물 정보 가져오기
    final petElements = document.rootElement.getElement('petList');
    final xmlJsonConverter = Xml2Json(); //.parse(document.toString());
    xmlJsonConverter.parse(petElements.toString());
    final Map<String, dynamic> petMap = jsonDecode(xmlJsonConverter.toParker());
    Map<String, dynamic> petListMap = petMap['petList'];
    List<MyPetItemModel> petList = petListMap.values.map((e) {
      final petElement = jsonDecode(_convertToJsonStringQuotes(raw: e));
      return MyPetItemModel(
        idx: int.parse(petElement['idx'].toString()),
        imgSort: int.parse(petElement['imgSort'].toString()),
        imgWidth: int.parse(petElement['imgWidth'].toString()),
        imgHeight: int.parse(petElement['imgHeight'].toString()),
        personalityIdx: int.parse(petElement['personalityIdx'].toString()),
        memberIdx: int.parse(petElement['memberIdx'].toString()),
        typeName: petElement['typeName'].toString(),
        birth: petElement['birth'].toString(),
        ageText: petElement['ageText'].toString(),
        weight: double.parse(petElement['memberIdx'].toString()),
        genderText: petElement['genderText'].toString(),
        personalityEtc: petElement['personalityEtc'].toString(),
        url: petElement['url'].toString(),
        breedName: petElement['breedName'].toString(),
        personality: petElement['personality'].toString(),
        sizeText: petElement['sizeText'].toString(),
        breedNameEtc: petElement['breedNameEtc'].toString(),
        name: petElement['name'].toString(),
        breedIdx: int.parse(petElement['breedIdx'].toString()),
        uuid: petElement['uuid'].toString(),
        selected: true,
      );
    }).toList();

    // print('xml petList  $petList');


    List<WalkStateModel> walkInfoList = [];
    final walkInfoXmlList = document.rootElement.findAllElements('walkInfoList');
    for (var walInfoXml in walkInfoXmlList) {
      try {
        final dateTime = walInfoXml.getElement('dateTime')!.innerText;
        final latitude = walInfoXml.getElement('latitude')!.innerText;
        final longitude = walInfoXml.getElement('longitude')!.innerText;
        final distance = walInfoXml.getElement('distance')!.innerText;
        final walkTime = walInfoXml.getElement('walkTime')!.innerText;
        final walkCount = walInfoXml.getElement('walkCount')!.innerText;
        final calorie = walInfoXml.getElement('calorie');
        xmlJsonConverter.parse(calorie.toString());
        final Map<String, dynamic> calorieXmlMap = jsonDecode(xmlJsonConverter.toParker());
        Map<String, dynamic> calorieMap = {};
        for (var calorie in calorieXmlMap.values) {
          calorieMap.addAll(calorie);
        }

        walkInfoList.add(
          WalkStateModel(
            dateTime: DateTime.parse(dateTime),
            latitude: double.parse(latitude),
            longitude: double.parse(longitude),
            distance: double.parse(distance),
            walkTime: int.parse(walkTime),
            walkCount: int.parse(walkCount),
            calorie: calorieMap,
            petList: petList,
          ),
        );

      } catch(e) {
        print('xml parse error $e');
        continue;
      }
    }
    print('xml walkInfoList $walkInfoList');

    print('aaaa');
    if (isMoveToTotal) {
      print('zxczxczxczxc');
      // final readWalkInfos = readWalkInfo.join('\n');
      // File walkInfoXmlTotal = await File('${tempDir.path}/${fileName}_total.xml').create();
      // walkInfoXmlTotal.writeAsStringSync('$readWalkInfos\n', mode: FileMode.writeOnly, flush: true);
      // walkInfoFile.writeAsStringSync('');
      writeXMLWalkInfo(walkInfoList, petList,'${fileName}_total');
      // walkInfoFile.writeAsStringSync('');
      walkInfoFile.deleteSync();
    }

    return walkInfoList;
  }

  // static Future writeWalkInfo(WalkStateModel walkInfo, String fileName, [FileMode mode = FileMode.writeOnlyAppend]) async {
  //   List<String> walkInfoDataList = [];
  //
  //   //좌표값
  //   walkInfoDataList.add('${walkInfo.latitude}, ${walkInfo.longitude}');
  //   //state
  //   walkInfoDataList.add('1');
  //   //steps
  //   walkInfoDataList.add('${walkInfo.walkCount}');
  //   //distance
  //   walkInfoDataList.add('${walkInfo.distance}');
  //
  //   List<String> petUuidList = walkInfo.calorie.keys.toList();
  //   List calorieList = walkInfo.calorie.values.map((e) => e['calorie']).toList();
  //   //petUuid List
  //   walkInfoDataList.add(petUuidList.join('&').toString());
  //   //calorie List
  //   walkInfoDataList.add(calorieList.join('&').toString());
  //   //datetime
  //   walkInfoDataList.add('${walkInfo.dateTime}');
  //
  //   String walkInfoData = walkInfoDataList.join('|');
  //
  //   final tempDir = await getTemporaryDirectory();
  //   File walkInfoFile = await File('${tempDir.path}/${fileName}_local.txt').create();
  //   walkInfoFile.writeAsStringSync('$walkInfoData\n', mode: FileMode.writeOnlyAppend, flush: true);
  // }
  //
  //
  // static Future<List<WalkStateModel>> readWalkInfo(String fileName, [bool isMoveToTotal = true]) async {
  //   final tempDir = await getTemporaryDirectory();
  //   File walkInfoFile = File('${tempDir.path}/${fileName}.txt');
  //
  //   if (!walkInfoFile.existsSync()) {
  //     return [];
  //   }
  //   final readWalkInfo = walkInfoFile.readAsLinesSync();
  //
  //   List<WalkStateModel> walkInfoList = [];
  //
  //   for (var walkInfo in readWalkInfo) {
  //     final walkInfoDataList = walkInfo.split('|');
  //     List<String> petUuidList = walkInfoDataList[4].split('&');
  //     List calorieList = walkInfoDataList[5].split('&');
  //
  //     Map<String, dynamic> calorie = {};
  //
  //     for (int i = 0; i < petUuidList.length; i++) {
  //       Map<String, double> calorieMap = {
  //         'calorie': double.parse(calorieList[i]),
  //       };
  //       calorie[petUuidList[i]] = calorieMap;
  //     }
  //
  //     walkInfoList.add(
  //       WalkStateModel(
  //         dateTime: DateTime.parse(walkInfoDataList.last),
  //         latitude: double.parse(walkInfoDataList[0]
  //             .split(',')
  //             .first),
  //         longitude: double.parse(walkInfoDataList[0]
  //             .split(',')
  //             .last),
  //         distance: double.parse(walkInfoDataList[3]),
  //         walkTime: 0,
  //         walkCount: int.parse(walkInfoDataList[2]),
  //         calorie: calorie,
  //         petList: [],
  //       ),
  //     );
  //   }
  //
  //   // walkInfoFile.renameSync('${tempDir.path}/${fileName}_total.txt');
  //
  //   if (isMoveToTotal) {
  //     final readWalkInfos = readWalkInfo.join('\n');
  //     File walkInfoTotal = await File('${tempDir.path}/${fileName}_total.txt').create();
  //     walkInfoTotal.writeAsStringSync('$readWalkInfos\n', mode: FileMode.writeOnlyAppend, flush: true);
  //     walkInfoFile.writeAsStringSync('');
  //   }
  //
  //   return walkInfoList;
  // }

  static String _convertToJsonStringQuotes({required String raw}) {
    String jsonString = raw;

    /// add quotes to json string
    jsonString = jsonString.replaceAll('{', '{"');
    jsonString = jsonString.replaceAll(': ', '": "');
    jsonString = jsonString.replaceAll(', ', '", "');
    jsonString = jsonString.replaceAll('}', '"}');

    /// remove quotes on object json string
    jsonString = jsonString.replaceAll('"{"', '{"');
    jsonString = jsonString.replaceAll('"}"', '"}');

    /// remove quotes on array json string
    jsonString = jsonString.replaceAll('"[{', '[{');
    jsonString = jsonString.replaceAll('}]"', '}]');

    return jsonString;
  }
}
