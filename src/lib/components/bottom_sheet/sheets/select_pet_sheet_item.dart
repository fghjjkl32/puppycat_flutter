import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/my_pet_list/my_pet_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/user_restore_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class SelectPetSheetItem extends ConsumerStatefulWidget {
  const SelectPetSheetItem({super.key});

  @override
  SelectPetSheetItemState createState() => SelectPetSheetItemState();
}

class SelectPetSheetItemState extends ConsumerState<SelectPetSheetItem> {
  late PagingController<int, MyPetItemModel> _petListPagingController;

  @override
  void initState() {
    _petListPagingController = ref.read(myPetListStateProvider);
    super.initState();

    print('run???? $_petListPagingController');
    _petListPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 14, 24, 4),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            Expanded(
              child: PagedListView<int, MyPetItemModel>.separated(
                scrollDirection: Axis.horizontal,
                pagingController: _petListPagingController,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 12,
                  );
                },
                builderDelegate: PagedChildBuilderDelegate<MyPetItemModel>(
                  noMoreItemsIndicatorBuilder: (context) {
                    return GestureDetector(
                      onTap: () {
                        context.pop();
                        context.push("/home/myPage/myPetList");
                      },
                      child: const SizedBox(
                        width: 64,
                        child: Card(
                          child: Center(
                            child: Text('+'),
                          ),
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, item, index) {
                    bool selected = item.selected;
                    return GestureDetector(
                      onTap: () {
                        ///NOTE
                        ///2023.11.14.
                        ///산책하기 보류로 주석 처리
                        // ref.read(myPetListStateProvider.notifier).changedPetSelectState(item);
                        ///산책하기 보류로 주석 처리 완료
                      },
                      child: SizedBox(
                        width: 64,
                        child: getSquircleImage('', 64, 64, selected ? kPrimaryColor : Colors.transparent),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: SizedBox(
                width: 88, // 버튼의 너비
                child: ElevatedButton(
                  onPressed: () async {
                    context.pop();

                    if (await Permissions.getLocationPermissionState()) {
                      if (await Permissions.getActivityRecognitionPermissionState()) {
                        context.push('/map');
                      } else {
                        if (mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                  content: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24.0.h),
                                    child: Column(
                                      children: [
                                        Text(
                                          "퍼피캣 접근 권한 허용",
                                          style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        Text(
                                          "산책기능을 사용하기 위해\n신체 활동 데이터 접근을 허용해 주세요.",
                                          style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  confirmTap: () {
                                    context.pop();
                                    openAppSettings();
                                  },
                                  cancelTap: () {
                                    context.pop();
                                  },
                                  confirmWidget: Text(
                                    "허용",
                                    style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
                                  ),
                                  cancelWidget: Text(
                                    "허용 안 함",
                                    style: kButton14MediumStyle.copyWith(color: kTextSubTitleColor),
                                  ));
                            },
                          );
                        }
                      }
                    } else {
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                                content: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0.h),
                                  child: Column(
                                    children: [
                                      Text(
                                        "퍼피캣 접근 권한 허용",
                                        style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Text(
                                        "산책기능을 사용하기 위해\n위치 권한을 항상 허용해 주세요.",
                                        style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                confirmTap: () {
                                  context.pop();
                                  openAppSettings();
                                },
                                cancelTap: () {
                                  context.pop();
                                },
                                confirmWidget: Text(
                                  "허용",
                                  style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
                                ),
                                cancelWidget: Text(
                                  "허용 안 함",
                                  style: kButton14MediumStyle.copyWith(color: kTextSubTitleColor),
                                ));
                          },
                        );
                      }
                    }
                  },
                  child: Text('산책하기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SelectPetSheetItem extends StatelessWidget {
//   const SelectPetSheetItem({Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24.0, 14, 24, 4),
//       child: SizedBox(
//         height: 64, // 선택적으로 높이를 조정
//         child: Row(
//           children: [
//             Expanded(
//               child: PagedListView<int, MyPetItemModel>(
//                 pagingController: _searchPagingController,
//                 builderDelegate: PagedChildBuilderDelegate<ChatFavoriteModel>(
//                   noItemsFoundIndicatorBuilder: (context) {
//                     print('searchController.text.isEmpty ${searchController.text}');
//                     // if (searchController.text.isNotEmpty || searchController.text != '') {
//                     return _buildNoItemsFound('유저를 찾을 수 없습니다'.tr());
//                     // } else {
//                     //   return _buildPrevSearch();
//                     // }
//                   },
//                   itemBuilder: (context, item, index) {
//                     return ChatSearchListItem(
//                       idx: item.memberIdx!,
//                       nick: item.nick ?? 'unknown',
//                       intro: item.introText ?? '',
//                       isFavorite: item.favoriteState == 1 ? true : false,
//                       profileImgUrl: item.profileImgUrl ?? '',
//                       chatMemberId: item.chatMemberId ?? '',
//                       chatHomeServer: item.chatHomeServer ?? '',
//                       tempIdx: index.toString(),
//                       onTab: _onTabListItem,
//                       onTabFavorite: () {
//                         if (item.favoriteState == 1) {
//                           ref.read(chatUserSearchStateProvider.notifier).unSetFavorite(userMemberIdx, item.chatMemberId);
//                         } else {
//                           ref.read(chatUserSearchStateProvider.notifier).setFavorite(userMemberIdx, item.chatMemberId);
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 24),
//               child: SizedBox(
//                 width: 88, // 버튼의 너비
//                 child: ElevatedButton(
//                   onPressed: () {
//                     context.push('/map');
//                   },
//                   child: Text('산책하기'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//     // return Expanded(
//     //   child: Row(
//     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //     children: [
//     //       SizedBox(
//     //          height: 64,
//     //         child: ListView.builder(
//     //           scrollDirection: Axis.horizontal,
//     //           padding: const EdgeInsets.all(10.0),
//     //           shrinkWrap: true,
//     //           itemCount: 50,
//     //           itemBuilder: (context, index) {
//     //             return SizedBox(
//     //               // width: 200,
//     //               height: 64,
//     //               child: Center(
//     //                 child: Text('산책 일지 ${index + 1}'),
//     //               ),
//     //             );
//     //           },
//     //         ),
//     //       ),
//     //       // ElevatedButton(
//     //       //   onPressed: () {},
//     //       //   child: const Text('asdadsasd'),
//     //       // ),
//     //     ],
//     //   ),
//     // );
//   }
//   // Widget build(BuildContext context, WidgetRef ref) {
//   //   return Padding(
//   //     padding: const EdgeInsets.fromLTRB(24.0, 14, 24, 4),
//   //     child: SizedBox(
//   //       height: 64, // 선택적으로 높이를 조정
//   //       child: Row(
//   //         children: [
//   //           Expanded(
//   //             child: ListView.separated(
//   //               scrollDirection: Axis.horizontal, // 수평 스크롤
//   //               itemCount: 11, // 아이템 수
//   //               // itemExtent: 64,
//   //               separatorBuilder: (context, index) {
//   //                 return SizedBox(width: 12,);
//   //               },
//   //               itemBuilder: (context, index) {
//   //                 if (index < 10) {
//   //                   return Center(
//   //                     child: getProfileAvatar('', 64, 64),
//   //                   );
//   //                 } else {
//   //                   return ElevatedButton(
//   //                     onPressed: () {
//   //                       // 버튼 클릭 시 수행할 작업
//   //                     },
//   //                     child: Text('+'),
//   //                   );
//   //                 }
//   //               },
//   //             ),
//   //           ),
//   //           Padding(
//   //             padding: const EdgeInsets.only(left: 24),
//   //             child: SizedBox(
//   //               width: 88, // 버튼의 너비
//   //               child: ElevatedButton(
//   //                 onPressed: () {
//   //                   context.push('/map');
//   //                 },
//   //                 child: Text('산책하기'),
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   //   // return Expanded(
//   //   //   child: Row(
//   //   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //   //     children: [
//   //   //       SizedBox(
//   //   //          height: 64,
//   //   //         child: ListView.builder(
//   //   //           scrollDirection: Axis.horizontal,
//   //   //           padding: const EdgeInsets.all(10.0),
//   //   //           shrinkWrap: true,
//   //   //           itemCount: 50,
//   //   //           itemBuilder: (context, index) {
//   //   //             return SizedBox(
//   //   //               // width: 200,
//   //   //               height: 64,
//   //   //               child: Center(
//   //   //                 child: Text('산책 일지 ${index + 1}'),
//   //   //               ),
//   //   //             );
//   //   //           },
//   //   //         ),
//   //   //       ),
//   //   //       // ElevatedButton(
//   //   //       //   onPressed: () {},
//   //   //       //   child: const Text('asdadsasd'),
//   //   //       // ),
//   //   //     ],
//   //   //   ),
//   //   // );
//   // }
// }
