import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_service.g.dart';

@RestApi(baseUrl: "https://1164629e-5038-4f3b-b146-9bd9e86a58bb.mock.pstmn.io")
abstract class ChatService {
  factory ChatService(Dio dio, {String baseUrl}) = _ChatService;

  @GET('/chatFavorite')
  Future<ChatFavoriteResponseModel?> getChatFavorite();
}
