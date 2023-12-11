import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'block_service.g.dart';

@RestApi()
abstract class BlockService {
  factory BlockService(Dio dio, {String baseUrl}) = _BlockService;

  @GET('v1/block/member')
  Future<SearchResponseModel> getBlockList(
    @Query("searchWord") String? searchWord,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @POST('v1/block/member/{blockUuid}')
  Future<ResponseModel> postBlock(
    @Path("blockUuid") String blockUuid,
  );

  @DELETE('v1/block/member/{blockUuid}')
  Future<ResponseModel> deleteBlock(
    @Path("blockUuid") String blockUuid,
  );
}
