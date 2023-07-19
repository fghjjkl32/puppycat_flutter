import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:pet_mobile_social_flutter/services/chat/chat_service.dart';
import 'package:pet_mobile_social_flutter/services/policy/policy_service.dart';

class ChatRepository {
  final ChatService _chatService = ChatService(DioWrap.getDioWithCookie());

  Future<List<ChatFavoriteModel>> getChatFavorite() async {
    ChatFavoriteResponseModel? chatFavoriteResponseModel = await _chatService.getChatFavorite();

    if(chatFavoriteResponseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    return chatFavoriteResponseModel.data.list;
  }
}