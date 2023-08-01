import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_response_model.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:pet_mobile_social_flutter/services/chat/chat_service.dart';
import 'package:pet_mobile_social_flutter/services/policy/policy_service.dart';


final chatRepositoryProvider = StateProvider<ChatRepository>((ref) => ChatRepository());

class ChatRepository {
  final ChatService _chatService = ChatService(DioWrap.getDioWithCookie());

  Future<List<ChatFavoriteModel>> getChatFavorite(int memberIdx) async {
    if(memberIdx <= 0) {
      throw "Invalid MemberIdx";
    }

    bool isError = false;
    var chatFavoriteResponseModel = await _chatService.getChatFavorite(memberIdx).catchError((Object obj) async {
      (ResponseModel?, bool) errorResult = await errorHandler(obj);
      var responseModel = errorResult.$1;
      isError = errorResult.$2;

      return responseModel;
    });

    if(chatFavoriteResponseModel == null) {
      if(isError) {
        ///TODO
        ///throw로 할지 그냥 return null로 할지 생각해보기
        throw "error";
      } else {
        return [];
      }
    }

    return chatFavoriteResponseModel.data.list;
  }

  Future<bool> setChatFavorite(int memberIdx, String chatMemberId, [int type = 1]) async {
    if(memberIdx <= 0) {
      throw "Invalid MemberIdx";
    }

    Map<String, dynamic> body = {
      "memberIdx" : memberIdx,
      "type" : type,
      "chatMemberId" : chatMemberId,
    };

    ResponseModel? responseModel = await _chatService.setChatFavorite(body);

    if(responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    return true;
  }

  Future<bool> unSetChatFavorite(int memberIdx, String chatMemberId, [int type = 1]) async {
    if(memberIdx <= 0) {
      throw "Invalid MemberIdx";
    }

    Map<String, dynamic> queries = {
      "memberIdx" : memberIdx,
      "type" : type,
      "chatMemberId" : chatMemberId,
    };

    ResponseModel? responseModel = await _chatService.unSetChatFavorite(queries);

    if(responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    return true;
  }

  Future<(ResponseModel?, bool)> errorHandler(Object obj) async {
    ResponseModel? responseModel;
    switch (obj.runtimeType) {
      case DioException:
        final res = (obj as DioException).response;

        if (res?.data == null) {
          ///TODO
          ///Error Proc
          return (responseModel, true);
        } else if (res?.data is Map) {
          print('res data : ${res?.data}');
          responseModel = ResponseModel.fromJson(res?.data);
        } else if (res?.data is String) {
          Map<String, dynamic> valueMap = jsonDecode(res?.data);
          responseModel = ResponseModel.fromJson(valueMap);
        }

        // print('responseModel $responseModel');
        break;
      default:
        break;
    }
    return (responseModel, true);
  }
}