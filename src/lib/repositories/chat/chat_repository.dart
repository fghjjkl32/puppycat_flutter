import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_response_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_response_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_history_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_history_response_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_response_model.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/services/chat/chat_service.dart';

// final chatRepositoryProvider = StateProvider.family<ChatRepository, Dio>((ref, dio) => ChatRepository(dio: dio));

class ChatRepository {
  late final ChatService _chatService; // = ChatService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  ChatRepository({
    required this.dio,
  }) {
    _chatService = ChatService(dio, baseUrl: chatBaseUrl);
  }

  Future<ChatRoomDataListModel> getChatRoomList({
    int page = 1,
    int recordSize = 10,
  }) async {
    ChatRoomResponseModel responseModel = await _chatService.getChatRoomList(page: page, recordSize: recordSize);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatRoomList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatRoomList',
      );
    }

    final rooms = responseModel.data!;

    return rooms;
  }

  Future<ChatEnterModel> createRoom({
    required String targetMemberUuid,
    int maxUser = 2,
    int type = 0, //0 : DM, 1 : Group
    int limit = 30,
  }) async {
    Map<String, dynamic> body = {
      'targetMemberUuid': targetMemberUuid,
      'maxUser': maxUser,
      'type': type,
      'limit': limit,
      'page': 1,
    };

    ChatEnterResponseModel responseModel = await _chatService.createRoom(body: body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatRoomId',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatRoomId',
      );
    }

    // if (!responseModel.data!.containsKey('room_id')) {
    //   throw APIException(
    //     msg: 'room_id data is null',
    //     code: responseModel.code,
    //     refer: 'ChatRepository',
    //     caller: 'getChatRoomId',
    //   );
    // }

    // final String rooms = responseModel.data!['room_id'];

    return responseModel.data!;
  }

  Future<bool> exitChatRoom({
    required String roomUuid,
  }) async {
    ResponseModel responseModel = await _chatService.exitRoom(roomUuid: roomUuid);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'exitChatRoom',
      );
    }

    return true;
  }

  Future<bool> pinChatRoom({
    required String roomUuid,
    required bool isPin,
  }) async {
    ResponseModel responseModel;

    if (isPin) {
      responseModel = await _chatService.unSetPinRoom(roomUuid: roomUuid);
    } else {
      Map<String, dynamic> body = {
        'roomUuid': roomUuid,
      };
      responseModel = await _chatService.setPinRoom(body: body);
    }

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'pinChatRoom',
        arguments: [roomUuid, isPin],
      );
    }

    return true;
  }

  Future<ChatFavoriteDataListModel> getChatFavoriteMembers({
    int page = 1,
    int recordSize = 10,
  }) async {
    ChatFavoriteResponseModel responseModel = await _chatService.getChatFavoriteMembers(page: page, recordSize: recordSize);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatRooms',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatRooms',
      );
    }

    final members = responseModel.data!;

    return members;
  }

  Future<bool> favoriteChatMember({
    required String targetMemberUuid,
    required bool isFavorite,
  }) async {
    ResponseModel responseModel;

    if (isFavorite) {
      responseModel = await _chatService.unSetChatFavoriteMember(targetMemberUuid: targetMemberUuid);
    } else {
      Map<String, dynamic> body = {
        'targetMemberUuid': targetMemberUuid,
      };
      responseModel = await _chatService.setChatFavoriteMember(body: body);
    }

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'favoriteChatMember',
        arguments: [targetMemberUuid, isFavorite],
      );
    }

    return true;
  }

  Future<bool> reportChatMessage({
    required String roomUuid,
    required String memberUuid,
    required String message,
    required String score,
    required String targetMemberUuid,
  }) async {
    Map<String, dynamic> body = {
      'roomUuid': roomUuid,
      'memberUuid': memberUuid,
      'message': message,
      'score': score,
      'targetMemberUuid': targetMemberUuid,
    };

    ResponseModel responseModel = await _chatService.reportChatMessage(body: body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'reportChatMessage',
        arguments: [body],
      );
    }

    return true;
  }

  Future<ChatHistoryModel> getChatHistory({
    required String roomUuid,
    int page = 1,
    int limit = 30,
  }) async {
    ChatHistoryResponseModel responseModel = await _chatService.getChatHistory(roomUuid: roomUuid, page: page, limit: limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatHistory',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatHistory',
      );
    }

    final historyModel = responseModel.data!;

    return historyModel;
  }
}
