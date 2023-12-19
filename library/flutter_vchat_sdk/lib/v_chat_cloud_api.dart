import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart';
import 'package:universal_html/html.dart' as html;
import 'package:vchatcloud_flutter_sdk/model/common_result_model.dart';
import 'package:vchatcloud_flutter_sdk/util.dart';
import 'package:vchatcloud_flutter_sdk/vchatcloud_flutter_sdk.dart';

/// VChatCloud OpenAPI
class VChatCloudApi {
  /// 방 정보 조회
  static Future<ChatRoomModel> getRoomInfo({required String roomId}) async {
    var uri = ApiPath.getRoomInfo.addGetParam({"roomId": roomId});
    var request = await get(uri);

    var aa = "flutter_vchatcloud_sdk_open_api_";
    var a = Encrypted.fromBase64(
        "P/WY2Q2XNtup38A3mJPVk/ma3kPa770t1GQ/ClVPwEUkTWpaz9kzx7RQScuoK4mY");
    var b = Encrypter(AES(
      Key.fromUtf8(aa),
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ));
    var c = IV.fromUtf8(aa.substring(0, 16));
    var d = b.decrypt(a, iv: c);

    // Decrypt
    var e = Encrypter(AES(
      Key.fromUtf8(d),
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ));

    var data = json.decode(request.body)['data'];
    var rd = base64Decode(data);
    var en = Encrypted(rd);
    var iv = IV.fromUtf8(d.substring(0, 16));

    var result = e.decrypt(en, iv: iv);
    var model = ChatRoomModel.fromJson(json.decode(result));
    return model;
  }

  /// 좋아요 개수 조회
  static Future<int> getLike({required String roomId}) async {
    var uri = ApiPath.getLike.toUri();
    var response = await post(uri, body: {'room_id': roomId});
    int result = json.decode(response.body)['like_cnt'];
    return result;
  }

  /// 좋아요 추가
  static Future<int> like({required String roomId}) async {
    var uri = ApiPath.like.toUri();
    var response = await post(
      uri,
      body: {'room_id': roomId, 'log_cnt': "1"},
    );
    int result = json.decode(response.body)['like_cnt'];
    return result;
  }

  /// 업로드 파일 목록 조회
  static Future<List<FileModel>> getFileList({required String roomId}) async {
    Uri uri = ApiPath.getFileList.addGetParam({'roomId': roomId});
    final response = await get(uri);
    final body = json.decode(response.body);
    List<FileModel> list = [
      for (var i = 0; i < body['data']['list'].length; i++)
        FileModel.fromJson(body['data']['list'][i] as Map<String, dynamic>)
    ];

    return list;
  }

  /// 파일 저장
  ///
  /// **저장 전 저장소 접근 권한을 얻어야 함**
  static Future<File> download({
    required FileModel file,
    required String downloadPath,
  }) async {
    var url = ApiPath.loadFile.addGetParam({"fileKey": file.fileKey});

    var request = await get(url);
    var savedFile = File(
      "$downloadPath${Util.pathSeparator}${file.fileKey}_${file.originFileNm ?? file.fileNm}",
    );

    if (Util.isWeb) {
      var a = html.AnchorElement(href: url.toString());
      a.download = 'true';
      a.click();
      a.remove();
    } else {
      // 저장 경로까지 폴더를 생성
      await Directory(downloadPath).create(recursive: true);
      if (await savedFile.exists()) {
        var i = 1;
        // 파일 이름이 중복일 경우 체크
        while (await savedFile.exists()) {
          var match = RegExp(r"\((\d+)\).\w+$").allMatches(savedFile.path);
          if (match.isEmpty) {
            savedFile = File(
              savedFile.path
                  .replaceFirst(".${file.fileExt}", " ($i).${file.fileExt}"),
            );
          } else {
            savedFile = File(
              savedFile.path.replaceFirst(
                  " ($i).${file.fileExt}", " (${i + 1}).${file.fileExt}"),
            );
            i++;
          }
        }
      }
      await savedFile.writeAsBytes(request.bodyBytes);
    }

    return savedFile;
  }

  /// OpenGraph Info 획득
  static Future<OpenGraphModel> openGraph({
    required String requestUrl,
  }) async {
    if (!requestUrl.startsWith("http")) {
      requestUrl = "https://$requestUrl";
    }
    var url = ApiPath.getOpenGraph.addGetParam({"url": requestUrl});

    var response = await get(url);
    return OpenGraphModel.fromJson(json.decode(response.body));
  }

  /// Google Translation
  static Future<GoogleTranslationModel> googleTranslation({
    required String text, //요청 텍스트
    required String target, //반환 언어
    required String roomId, //채널 키
  }) async {
    var url = ApiPath.googleTranslate
        .addGetParam({"text": text, "target": target, "roomId": roomId});

    var response = await get(url);
    return GoogleTranslationModel.fromJson(json.decode(response.body));
  }

  /// user 신고하기
  static Future<CommonResultModel> reportUser({
    required String roomId, //채널 키
    required String buserChatId, // 차단유저 채팅ID
    required String buserNick, // 차단유저 닉네임
    required String buserMsg, // 차단유저 메세지
  }) async {
    var uri = ApiPath.reportUser.addPostParam({
      'room_id': roomId,
      'buser_chat_id': buserChatId,
      'buser_nick': buserNick,
      'buser_msg': buserMsg,
    });
    var response = await post(uri);
    return CommonResultModel.fromJson(json.decode(response.body));
  }
}
