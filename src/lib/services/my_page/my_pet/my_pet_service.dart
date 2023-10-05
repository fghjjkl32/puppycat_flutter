import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'my_pet_service.g.dart';

@RestApi()
abstract class MyPetService {
  factory MyPetService(Dio dio, {String baseUrl}) = _MyPetService;

  @GET('/pet/breed')
  Future<ListResponseModel?> getBreedList(
    @Query("loginMemberIdx") int loginMemberIdx,
    @Query("page") int page,
    @Query("type") int type,
    @Query("searchWord") String searchWord,
    @Query("limit") int limit,
  );

  @GET('/pet/health')
  Future<ListResponseModel?> getHealthList(
    @Query("loginMemberIdx") int loginMemberIdx,
    @Query("limit") int limit,
  );

  @GET('/pet/allergy')
  Future<ListResponseModel?> getAllergyList(
    @Query("loginMemberIdx") int loginMemberIdx,
    @Query("limit") int limit,
  );

  @POST('/pet')
  Future<ResponseModel> postMyPet(
    @Body() FormData formData,
  );

  @GET('/member/{memberIdx}/pet')
  Future<MyPetListResponseModel?> getMyPetList(
    @Path("memberIdx") int memberIdx,
    @Query("loginMemberIdx") int loginMemberIdx,
    @Query("limit") int limit,
    @Query("page") int page,
  );

  @GET('/member/pet/{idx}')
  Future<MyPetListResponseModel?> getMyPetDetailList(
    @Path("idx") int idx,
    @Query("loginMemberIdx") int loginMemberIdx,
  );

  @PUT('/pet/{idx}')
  Future<ResponseModel> updateMyPet(
    @Body() FormData formData,
    @Path("idx") int idx,
  );

  @DELETE('/pet/{idx}')
  Future<ResponseModel> deleteMyPet(
    @Path("idx") int idx,
    @Query("memberIdx") int memberIdx,
  );
}
