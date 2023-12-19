import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/restrain/restrain_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restrain_state_provider.g.dart';

enum RestrainType {
  none,
  loginRestrain,
  writeAllRestrain,
  writeFeedRestrain,
  writeCommentRestrain,
  walkRestrain,
}

enum RestrainCheckType {
  login,
  writeFeed,
  writeComment,
  editMyInfo,
}

@Riverpod(keepAlive: true)
class RestrainState extends _$RestrainState {
  late final RestrainRepository _restrainRepository;

  @override
  List<RestrainType> build() {
    _restrainRepository = RestrainRepository(dio: ref.read(dioProvider));
    return [];
  }

  Future<RestrainItemModel?> getRestrainDetail(RestrainType type) async {
    try {
      final restrainModel = _restrainRepository.getRestrainDetail(type);
      return restrainModel;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      return null;
    } catch (e) {
      print('getRestrainDetail error $e');
      return null;
    }
  }

  Future<bool> checkRestrainStatus(RestrainCheckType type) async {
    final restrainList = state;
    print('restrainList $restrainList');
    switch (type) {
      case RestrainCheckType.login:
        if (restrainList.contains(RestrainType.loginRestrain)) {
          await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(
                APIException(
                  msg: '로그인 제재 회원입니다.',
                  code: 'ERES-9998',
                  refer: 'RestrainState',
                  caller: 'checkRestrainStatus',
                  arguments: [
                    RestrainType.loginRestrain,
                  ],
                ),
              );
          return false;
        }
        break;
      case RestrainCheckType.editMyInfo:
        if (restrainList.contains(RestrainType.writeAllRestrain)) {
          await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(
                APIException(
                  msg: '글작성 제재 회원입니다.',
                  code: 'ERES-9997',
                  refer: 'RestrainState',
                  caller: 'checkRestrainStatus',
                  arguments: [
                    RestrainType.writeAllRestrain,
                  ],
                ),
              );
          return false;
        }
        break;
      case RestrainCheckType.writeFeed:
        if (restrainList.contains(RestrainType.writeAllRestrain)) {
          await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(
                APIException(
                  msg: '글작성 제재 회원입니다.',
                  code: 'ERES-9997',
                  refer: 'RestrainState',
                  caller: 'checkRestrainStatus',
                  arguments: [
                    RestrainType.writeAllRestrain,
                  ],
                ),
              );
          return false;
        } else if (restrainList.contains(RestrainType.writeFeedRestrain)) {
          await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(
                APIException(
                  msg: '컨텐츠 작성 제재 회원입니다.',
                  code: 'ERES-9996',
                  refer: 'RestrainState',
                  caller: 'checkRestrainStatus',
                  arguments: [
                    RestrainType.writeFeedRestrain,
                  ],
                ),
              );
          return false;
        }
        break;
      case RestrainCheckType.writeComment:
        if (restrainList.contains(RestrainType.writeAllRestrain)) {
          await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(
                APIException(
                  msg: '글작성 제재 회원입니다.',
                  code: 'ERES-9997',
                  refer: 'RestrainState',
                  caller: 'checkRestrainStatus',
                  arguments: [
                    RestrainType.writeAllRestrain,
                  ],
                ),
              );
          return false;
        } else if (restrainList.contains(RestrainType.writeCommentRestrain)) {
          await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(
                APIException(
                  msg: '댓글 작성 제재 회원입니다.',
                  code: 'ERES-9995',
                  refer: 'RestrainState',
                  caller: 'checkRestrainStatus',
                  arguments: [
                    RestrainType.writeCommentRestrain,
                  ],
                ),
              );
          return false;
        }
        break;
    }
    return true;
  }
}
