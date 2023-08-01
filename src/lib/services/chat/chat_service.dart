import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_response_model.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class ChatService {
  factory ChatService(Dio dio, {String baseUrl}) = _ChatService;

  @GET('/chat/favorites')
  Future<ChatFavoriteResponseModel?> getChatFavorite(@Query('memberIdx') int memberIdx);

  @POST('/chat/favorites')
  Future<ResponseModel> setChatFavorite(@Body() Map<String, dynamic> body);

  @DELETE('/chat/favorites')
  Future<ResponseModel> unSetChatFavorite(@Queries() Map<String, dynamic> queries);

}
