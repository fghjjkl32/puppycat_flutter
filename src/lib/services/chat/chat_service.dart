import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_response_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_response_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_history_response_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_response_model.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_service.g.dart';

@RestApi()
abstract class ChatService {
  factory ChatService(Dio dio, {String baseUrl}) = _ChatService;

  @POST('v1/chat/room')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ChatEnterResponseModel> createRoom({
    @Body() required Map<String, dynamic> body,
  });

  @GET('v1/chat/room')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ChatRoomResponseModel> getChatRoomList({
    @Query('page') required int page,
    @Query('recordSize') required int recordSize, //limit
  });

  @DELETE('v1/chat/room/{roomUuid}')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> exitRoom({
    @Path('roomUuid') required String roomUuid,
  });

  @POST('v1/chat/fix/room')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> setPinRoom({
    @Body() required Map<String, dynamic> body,
  });

  @DELETE('v1/chat/fix/room/{roomUuid}')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> unSetPinRoom({
    @Path('roomUuid') required String roomUuid,
  });

  @GET('v1/chat/favorite/member')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ChatFavoriteResponseModel> getChatFavoriteMembers({
    @Query('page') required int page,
    @Query('recordSize') required int recordSize, //limit
  });

  @POST('v1/chat/favorite/member')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> setChatFavoriteMember({
    @Body() required Map<String, dynamic> body,
  });

  @DELETE('v1/chat/favorite/member/{targetMemberUuid}')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> unSetChatFavoriteMember({
    @Path('targetMemberUuid') required String targetMemberUuid,
  });

  @POST('v1/chat/message/report')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> reportChatMessage({
    @Body() required Map<String, dynamic> body,
  });

  @GET('v1/chat/room/log')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ChatHistoryResponseModel> getChatHistory({
    @Query('roomUuid') required String roomUuid,
    @Query('page') required int page,
    @Query('limit') required int limit,
  });
}
