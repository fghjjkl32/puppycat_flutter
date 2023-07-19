import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/block/block_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/block/block_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/block/block_service.dart';

class BlockRepository {
  final BlockService _blockService = BlockService(DioWrap.getDioWithCookie());

  Future<BlockResponseModel> getBlockSearchList({
    required int memberIdx,
    required int page,
    required String searchWord,
  }) async {
    BlockResponseModel? blockResponseModel = await _blockService
        .getBlockSearchList(memberIdx, page, searchWord)
        .catchError((Object obj) async {});

    if (blockResponseModel == null) {
      return BlockResponseModel(
        result: false,
        code: "",
        data: const BlockDataListModel(
          list: [],
          params: ParamsModel(
            memberIdx: 0,
            pagination: Pagination(
              startPage: 0,
              limitStart: 0,
              totalPageCount: 0,
              existNextPage: false,
              endPage: 0,
              existPrevPage: false,
              totalRecordCount: 0,
            ),
            offset: 0,
            limit: 0,
            pageSize: 0,
            page: 0,
            recordSize: 0,
          ),
        ),
        message: "",
      );
    }

    return blockResponseModel;
  }

  Future<BlockResponseModel> getBlockList({
    required int memberIdx,
    required int page,
  }) async {
    BlockResponseModel? blockResponseModel = await _blockService
        .getBlockList(memberIdx, page)
        .catchError((Object obj) async {});

    if (blockResponseModel == null) {
      return BlockResponseModel(
        result: false,
        code: "",
        data: const BlockDataListModel(
          list: [],
          params: ParamsModel(
            memberIdx: 0,
            pagination: Pagination(
              startPage: 0,
              limitStart: 0,
              totalPageCount: 0,
              existNextPage: false,
              endPage: 0,
              existPrevPage: false,
              totalRecordCount: 0,
            ),
            offset: 0,
            limit: 0,
            pageSize: 0,
            page: 0,
            recordSize: 0,
          ),
        ),
        message: "",
      );
    }

    return blockResponseModel;
  }

  Future<ResponseModel> deleteBlock({
    required int blockIdx,
    required int memberIdx,
  }) async {
    ResponseModel? blockResponseModel = await _blockService
        .deleteBlock(blockIdx, memberIdx)
        .catchError((Object obj) async {});

    if (blockResponseModel == null) {
      throw "error";
    }

    return blockResponseModel;
  }

  Future<ResponseModel> postBlock({
    required int blockIdx,
    required int memberIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel? followResponseModel =
        await _blockService.postBlock(blockIdx, body);

    if (followResponseModel == null) {
      throw "error";
    }

    return followResponseModel;
  }
}
