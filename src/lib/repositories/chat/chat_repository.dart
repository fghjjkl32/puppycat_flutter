import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_response_model.dart';
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

  Future<ChatRoomDataListModel> getChatRooms({
    int page = 1,
    int recordSize = 10,
  }) async {
    ChatRoomResponseModel responseModel = await _chatService.getChatRoomList(page: page, recordSize: recordSize);

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

    final rooms = responseModel.data!;

    return rooms;
  }

  Future<String> createRoom({
    required String targetMemberUuid,
    int maxUser = 2,
    int type = 0, //0 : DM, 1 : Group
  }) async {
    Map<String, dynamic> body = {
      'targetMemberUuid': targetMemberUuid,
      'maxUser': maxUser,
      'type': type,
    };

    ResponseModel responseModel = await _chatService.createRoom(body: body);

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

    if (!responseModel.data!.containsKey('room_id')) {
      throw APIException(
        msg: 'room_id data is null',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'getChatRoomId',
      );
    }

    final String rooms = responseModel.data!['room_id'];

    return rooms;
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
      Map<String, dynamic> body = {
        'uuid': roomUuid,
      };
      responseModel = await _chatService.setPinRoom(body: body);
    } else {
      responseModel = await _chatService.unSetPinRoom(roomUuid: roomUuid);
    }

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'exitChatRoom',
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
      Map<String, dynamic> body = {
        'targetMemberUuid': targetMemberUuid,
      };
      responseModel = await _chatService.setChatFavoriteMember(body: body);
    } else {
      responseModel = await _chatService.unSetChatFavoriteMember(targetMemberUuid: targetMemberUuid);
    }

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'ChatRepository',
        caller: 'exitChatRoom',
        arguments: [targetMemberUuid, isFavorite],
      );
    }

    return true;
  }
}
