import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_service.g.dart';

@RestApi()
abstract class NotificationService {
  factory NotificationService(Dio dio, {String baseUrl}) = _NotificationService;

  @GET('v1/noti')
  Future<NotificationResponseModel> getNotifications(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('v1/noti/new')
  Future<ResponseModel> checkNewNotifications(
    @Query('memberIdx') int memberIdx,
  );
  // @GET('/noti')
  // Future<NotificationResponseModel?> getNotifications(
  //     @Query('memberIdx') int memberIdx,
  //     @Query('page') int page,
  //     // @Query('type') int type,
  //     @Query('limit') int limit,
  //     );
}
