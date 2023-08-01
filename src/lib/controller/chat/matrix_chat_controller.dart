import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/common/util/encrypt/encrypt_util.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/room_status_extension.dart';
import 'package:pet_mobile_social_flutter/controller/chat/abstract_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_user_model.dart';

class MatrixChatClientController implements AbstractChatController {
  late Client _chatClient;

  Client get client => _chatClient;

  MatrixChatClientController([String clientName = 'puppycat', String homeServer = 'https://sns-chat.devlabs.co.kr:8008']) {
  // MatrixChatClientController([String clientName = 'puppycat', String homeServer = 'https://dev2.office.uxplus.kr']) {
    print('homeServer $homeServer / clientName $clientName');
    init(clientName, homeServer);
  }

  void init(String clientName, String homeServer) async {
    _chatClient = Client(
      clientName,
      databaseBuilder: (_) async {
        final dir = await getApplicationSupportDirectory();
        final db = HiveCollectionsDatabase('matrix_example_chat', dir.path);
        await db.open();
        return db;
      },
    );
    await client.checkHomeserver(Uri.parse(homeServer));
  }

  @override
  Future<LoginResponse> login(String id, String pw, [LoginType type = LoginType.mLoginPassword]) async {
    try {
      print('chat login $id / $pw');
      var result = await _chatClient.login(
        type,
        identifier: AuthenticationUserIdentifier(user: id),
        password: pw,
      );

      return result;
    } catch (e) {
      throw 'login failure. (e : $e)';
    }
  }

  @override
  Future<ChatUserModel?> register(String id, String pw, String displayName, [AccountKind kind = AccountKind.user]) async {
    if (id.contains('@')) {
      id = id.replaceAll('@', '_');
    }
    if (id.contains('#')) {
      id = id.replaceAll('#', '_');
    }


    print('chat register id - $id / pw - $pw');

    var result = await _chatClient
        .register(
      auth: AuthenticationData(
        type: "m.login.dummy",
      ),
      kind: kind,
      username: id,
      password: pw,
    )
        .catchError((obj) {
      return null;
    });

    ///TODO
    ///error  처리 필요
    print('register result : $result');

    if (result == null) {
      return null;
    }

    if (result.accessToken != null) {
      _chatClient.accessToken = result.accessToken;
      setDisplayName(result.userId, displayName);
      _chatClient.accessToken = null;
    }

    ChatUserModel userModel = ChatUserModel(
      chatMemberId: result.userId,
      homeServer: result.homeServer,
      accessToken: result.accessToken,
      deviceId: result.deviceId,
    );

    print('register result $userModel');

    return userModel;
  }

  @override
  Future<void> setDisplayName(String id, String nick) async {
    await _chatClient.setDisplayName(id, nick);
  }

  @override
  String createAccount(String id, String extra) {
    if (id.contains('@')) {
      id = id.replaceAll('@', '_');
    }
    if (id.contains('#')) {
      id = id.replaceAll('#', '_');
    }

    String subStringExtra;
    if (extra.length > 5) {
      if (extra.contains('-')) {
        subStringExtra = extra
            .split('-')
            .first;
      } else {
        subStringExtra = extra.substring(0, 5);
      }
    } else {
      subStringExtra = extra;
    }

    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random r = Random();
    String strRandom = String.fromCharCodes(Iterable.generate(5, (_) => ch.codeUnitAt(r.nextInt(ch.length))));

    String strAccount = id + subStringExtra + strRandom;
    print('strAccount $strAccount');
    return strAccount;
  }

  @override
  String createPassword(String pw) {
    return EncryptUtil.getPassAPIEncrypt(pw);
  }

  @override
  Future getFavoriteList() {
    // TODO: implement getFavoriteList
    throw UnimplementedError();
  }

  @override
  Future logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  List<ChatRoomModel> getRoomList() {
    return _chatClient.rooms
        .map(
            (e) {
          Event? lastEvent = e.lastMessageEvent ?? e.lastEvent;
          String lastMsg = lastEvent!.redacted ? '메시지.삭제된 메시지 입니다'.tr() : lastEvent!.calcUnlocalizedBody(
            hideReply: true,
            hideEdit: true,
            plaintextBody: true,
            removeMarkdown: true,
          );

          // print('${e.getLocalizedDisplayname()} / _getReadEventId(e) ${_getReadEventId(e)} / ${e.fullyRead } / ${lastEvent.eventId}');

          return ChatRoomModel(
            id: e.id,
            avatarUrl: e.avatar?.toString(),
            nick: e.getLocalizedDisplayname(),
            lastMsg: lastMsg,
            isLastMsgMine: lastEvent.senderId == client.userID,
            newCount: e.notificationCount,
            isRead: e.fullyRead == lastEvent.eventId || e.fullyRead == _getReadEventId(e) ||  _getReadEventId(e) ==  lastEvent.eventId,
            isPin: e.membership == Membership.invite ? false : e.isFavourite,
            msgDateTime: e.timeCreated.localizedTimeDayDiff(),
            isMine: e.lastEvent?.senderId == client.userID,
            isJoined: e.membership == Membership.join,
          );
        })
        .toList();
  }

  @override
  Stream<List<ChatRoomModel>> getRoomListStream() {
    StreamController<List<ChatRoomModel>> controller = StreamController();

    _chatClient.onSync.stream.listen((event) {
      controller.add(_chatClient.rooms.map((e) {
        if (e.membership == Membership.invite) {
          e.join();
        }
// print('update');
        // print('_getReadEventId(e) ${_getReadEventId(e)}');
        Event? lastEvent = e.lastMessageEvent ?? e.lastEvent;
        String lastMsg = lastEvent!.redacted ? '메시지.삭제된 메시지 입니다'.tr() : lastEvent!.calcUnlocalizedBody(
          hideReply: true,
          hideEdit: true,
          plaintextBody: true,
          removeMarkdown: true,
        );


        return ChatRoomModel(
          id: e.id,
          avatarUrl: e.avatar?.toString(),
          nick: e.getLocalizedDisplayname(),
          lastMsg: lastMsg,
          isLastMsgMine: lastEvent.senderId == client.userID,
          newCount: e.notificationCount,
          isRead: e.fullyRead == lastEvent.eventId || e.fullyRead == _getReadEventId(e) ||  _getReadEventId(e) ==  lastEvent.eventId,
          isPin: e.membership == Membership.invite ? false : e.isFavourite,
          msgDateTime: e.timeCreated.localizedTimeDayDiff(),
          isMine: e.lastEvent?.senderId == client.userID,
          isJoined: e.membership == Membership.join,
        );
      }).toList());
    });

    return controller.stream;
  }

  Future<List<MatrixEvent>> getRoomState(String roomId) async {
    return await _chatClient.getRoomState(roomId);
  }

  @override
  void leave(String roomId) async {
    await _chatClient.leaveRoom(roomId);
  }

  @override
  void setFavorite(String roomId, bool isFavorite) async {
    await _chatClient.getRoomById(roomId)?.setFavourite(isFavorite);
  }

  @override
  Future<bool> send(String roomId, String msg) async {
    var result = await _chatClient.getRoomById(roomId)?.sendTextEvent(msg.trim());
    return result == null ? false : true;
  }

  String? _getReadEventId(Room room) {
    if (room.ephemerals == null || !room.ephemerals!.containsKey('m.receipt')) {
      return null;
    }

    Map<String, Object?> receipts = room.ephemerals['m.receipt']!.content;
    String? readEventId;
    // receipts.forEach((key, value) {
    for (MapEntry e in receipts.entries) {
      Map<String, dynamic> contentMap = e.value as Map<String, dynamic>;
      if (contentMap.containsKey('m.read')) {
        readEventId = e.key;
        break;
      }
    }

    return readEventId;
  }
}
