///NOTE
///2023.11.16.
///산책하기 보류로 전체 주석 처리
// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
// import 'package:pet_mobile_social_flutter/config/constants.dart';
// import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_response_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/pet_detail/pet_detail_item_model.dart';
// import 'package:pet_mobile_social_flutter/models/params_model.dart';
// import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
// import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
// import 'package:pet_mobile_social_flutter/services/my_page/my_pet/my_pet_service.dart';
// import 'package:pet_mobile_social_flutter/services/search/search_service.dart';
// import 'package:http_parser/http_parser.dart';
//
// class CreateMyPetRepository {
//   late final MyPetService _myPetService;
//
//   final Dio dio;
//
//   CreateMyPetRepository({
//     required this.dio,
//   }) {
//     _myPetService = MyPetService(dio, baseUrl: baseUrl);
//   }
//
//   Future<ListResponseModel> getBreedList({
//     required int loginMemberIdx,
//     required int page,
//     required int type,
//     required String searchWord,
//     int limit = 20,
//   }) async {
//     ListResponseModel? searchResponseModel = await _myPetService.getBreedList(loginMemberIdx, page, type, searchWord, limit).catchError((Object obj) async {});
//
//     if (searchResponseModel == null) {
//       return ListResponseModel(
//         result: false,
//         code: "",
//         data: ListModel(
//           list: [],
//         ),
//         message: "",
//       );
//     }
//
//     return searchResponseModel;
//   }
//
//   Future<ListResponseModel> getHealthList({
//     required int loginMemberIdx,
//     int limit = 100,
//   }) async {
//     ListResponseModel? searchResponseModel = await _myPetService.getHealthList(loginMemberIdx, limit).catchError((Object obj) async {});
//
//     if (searchResponseModel == null) {
//       return ListResponseModel(
//         result: false,
//         code: "",
//         data: ListModel(
//           list: [],
//         ),
//         message: "",
//       );
//     }
//
//     return searchResponseModel;
//   }
//
//   Future<ListResponseModel> getAllergyList({
//     required int loginMemberIdx,
//     int limit = 100,
//   }) async {
//     ListResponseModel? searchResponseModel = await _myPetService.getAllergyList(loginMemberIdx, limit).catchError((Object obj) async {});
//
//     if (searchResponseModel == null) {
//       return ListResponseModel(
//         result: false,
//         code: "",
//         data: ListModel(
//           list: [],
//         ),
//         message: "",
//       );
//     }
//
//     return searchResponseModel;
//   }
//
//   Future<ResponseModel> postMyPet(
//     PetDetailItemModel petDetailItemModel,
//     XFile? file,
//   ) async {
//     // 기본 파라미터 설정
//     Map<String, dynamic> baseParams = {
//       "memberIdx": petDetailItemModel.memberIdx,
//       "name": petDetailItemModel.name,
//       "gender": petDetailItemModel.gender,
//       "breedIdx": petDetailItemModel.breedIdx,
//       "size": petDetailItemModel.size,
//       "weight": petDetailItemModel.weight,
//       "age": petDetailItemModel.age,
//       "birth": petDetailItemModel.birth,
//       "healthIdxList": petDetailItemModel.healthIdxList,
//       "allergyIdxList": petDetailItemModel.allergyIdxList,
//     };
//
//     // 품종 직접 입력 했을때 케이스
//     if (petDetailItemModel.breedIdx == 1 || petDetailItemModel.breedIdx == 2) {
//       baseParams["breedNameEtc"] = petDetailItemModel.breedNameEtc;
//     }
//
//     // 성격을 입력 하지 않았을때, 케이스
//     if (petDetailItemModel.personalityCode != null) {
//       baseParams["personalityCode"] = petDetailItemModel.personalityCode;
//     }
//
//     // 성격 직접 입력 했을때 케이스
//     if (petDetailItemModel.personalityCode == 7) {
//       baseParams["personalityEtc"] = petDetailItemModel.personalityEtc;
//     }
//
//     // 파일이 있는 경우에만 추가
//     if (file != null) {
//       baseParams["uploadFile"] = MultipartFile.fromFileSync(
//         file.path,
//         contentType: MediaType('image', 'jpg'),
//       );
//     }
//
//     FormData params = FormData.fromMap(baseParams);
//
//     ResponseModel? responseModel = await _myPetService.postMyPet(params);
//
//     if (responseModel == null) {
//       throw "error";
//     }
//
//     return responseModel;
//   }
//
//   Future<ResponseModel> updateMyPet(
//     PetDetailItemModel petDetailItemModel,
//     XFile? file,
//   ) async {
//     // 기본 파라미터 설정
//     Map<String, dynamic> baseParams = {
//       "memberIdx": petDetailItemModel.memberIdx,
//       "name": petDetailItemModel.name,
//       "gender": petDetailItemModel.gender,
//       "breedIdx": petDetailItemModel.breedIdx,
//       "size": petDetailItemModel.size,
//       "weight": petDetailItemModel.weight,
//       "age": petDetailItemModel.age,
//       "birth": petDetailItemModel.birth,
//       "resetState": petDetailItemModel.resetState,
//       "healthIdxList": petDetailItemModel.healthIdxList,
//       "allergyIdxList": petDetailItemModel.allergyIdxList,
//     };
//
//     // 품종 직접 입력 했을때 케이스
//     if (petDetailItemModel.breedIdx == 1 || petDetailItemModel.breedIdx == 2) {
//       baseParams["breedNameEtc"] = petDetailItemModel.breedNameEtc;
//     }
//
//     // 성격을 입력 하지 않았을때, 케이스
//     if (petDetailItemModel.personalityCode != null) {
//       baseParams["personalityCode"] = petDetailItemModel.personalityCode;
//     }
//
//     // 성격 직접 입력 했을때 케이스
//     if (petDetailItemModel.personalityCode == 7) {
//       baseParams["personalityEtc"] = petDetailItemModel.personalityEtc;
//     }
//
//     // 파일이 있는 경우에만 추가
//     if (file != null) {
//       baseParams["uploadFile"] = MultipartFile.fromFileSync(
//         file.path,
//         contentType: MediaType('image', 'jpg'),
//       );
//     }
//
//     FormData params = FormData.fromMap(baseParams);
//
//     ResponseModel? responseModel = await _myPetService.updateMyPet(params, petDetailItemModel.idx!);
//
//     if (responseModel == null) {
//       throw "error";
//     }
//
//     return responseModel;
//   }
//
//   Future<ResponseModel> deleteMyPet(
//     int idx,
//     int memberIdx,
//   ) async {
//     ResponseModel? responseModel = await _myPetService.deleteMyPet(idx, memberIdx);
//
//     if (responseModel == null) {
//       throw "error";
//     }
//
//     return responseModel;
//   }
// }
