import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'block_service.g.dart';

@RestApi()
abstract class BlockService {
  factory BlockService(Dio dio, {String baseUrl}) = _BlockService;

  @GET('/block/member/{memberIdx}?page={page}&limit=30')
  Future<SearchResponseModel?> getBlockList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('/block/member/{memberIdx}?page={page}&limit=30&searchWord={searchWord}')
  Future<SearchResponseModel?> getBlockSearchList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
    @Path("searchWord") String searchWord,
  );

  @POST('/block/member/{blockIdx}')
  Future<ResponseModel?> postBlock(
    @Path("blockIdx") int blockIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/block/member/{blockIdx}?memberIdx={memberIdx}')
  Future<ResponseModel?> deleteBlock(
    @Path("blockIdx") int blockIdx,
    @Path("memberIdx") int memberIdx,
  );
}
