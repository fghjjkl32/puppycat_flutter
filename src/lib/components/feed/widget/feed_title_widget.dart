import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_post/my_post_state_provider.dart';
import 'package:widget_mask/widget_mask.dart';

class FeedTitleWidget extends ConsumerWidget {
  const FeedTitleWidget({
    required this.profileImage,
    required this.userName,
    required this.address,
    required this.time,
    required this.isEdit,
    required this.memberIdx,
    required this.isKeep,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String? userName;
  final String address;
  final String time;
  final bool isEdit;
  final int? memberIdx;
  final bool isKeep;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, right: 10.w, bottom: 12.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              profileImage == null || profileImage == ""
                  ? WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Center(
                        child: Image.asset(
                          'assets/image/feed/icon/large_size/icon_taguser.png',
                          height: 32.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/feed/image/squircle.svg',
                        height: 32.h,
                      ),
                    )
                  : WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Center(
                        child: Image.network(
                          "https://dev-imgs.devlabs.co.kr${profileImage}",
                          height: 32.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/feed/image/squircle.svg',
                        height: 32.h,
                        fit: BoxFit.fill,
                      ),
                    ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userName}",
                    style: kTitle14BoldStyle.copyWith(color: kTextTitleColor),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      Text(
                        address,
                        style:
                            kBody11RegularStyle.copyWith(color: kTextBodyColor),
                      ),
                      Row(
                        children: [
                          Text(
                            " · ",
                            style: kBody11RegularStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                          // Text(
                          //   displayedAt(time),
                          //   style: kBody11RegularStyle.copyWith(
                          //       color: kTextBodyColor),
                          // ),
                          Text(
                            time,
                            style: kBody11RegularStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                        ],
                      ),
                      isEdit
                          ? Row(
                              children: [
                                Text(
                                  " · ",
                                  style: kBody11RegularStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                                Text(
                                  "수정됨",
                                  style: kBody11RegularStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              memberIdx == ref.read(userModelProvider)!.idx
                  ? showCustomModalBottomSheet(
                      context: context,
                      widget: Column(
                        children: [
                          isKeep
                              ? BottomSheetButtonItem(
                                  iconImage:
                                      'assets/image/feed/icon/small_size/icon_user_de.png',
                                  title: '프로필 표시하기',
                                  titleStyle: kButton14BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                  onTap: () async {
                                    context.pop();

                                    final result = await ref
                                        .watch(myPostStateProvider.notifier)
                                        .postKeepContents(
                                          memberIdx:
                                              ref.read(userModelProvider)!.idx,
                                          idxList: ref
                                              .watch(
                                                  myPostStateProvider.notifier)
                                              .getSelectedMyPostImageIdx(),
                                        );

                                    if (result.result) {
                                      toast(
                                        context: context,
                                        text: '게시물 보관이 완료되었습니다.',
                                        type: ToastType.purple,
                                      );
                                    }
                                  },
                                )
                              : BottomSheetButtonItem(
                                  iconImage:
                                      'assets/image/feed/icon/small_size/icon_user_de.png',
                                  title: '보관하기',
                                  titleStyle: kButton14BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                  onTap: () async {
                                    context.pop();

                                    final result = await ref
                                        .watch(myPostStateProvider.notifier)
                                        .postKeepContents(
                                          memberIdx:
                                              ref.read(userModelProvider)!.idx,
                                          idxList: ref
                                              .watch(
                                                  myPostStateProvider.notifier)
                                              .getSelectedMyPostImageIdx(),
                                        );

                                    if (result.result) {
                                      toast(
                                        context: context,
                                        text: '게시물 보관이 완료되었습니다.',
                                        type: ToastType.purple,
                                      );
                                    }
                                  },
                                ),
                          BottomSheetButtonItem(
                            iconImage:
                                'assets/image/feed/icon/small_size/icon_user_block_on.png',
                            title: '수정하기',
                            titleStyle: kButton14BoldStyle.copyWith(
                                color: kTextSubTitleColor),
                            onTap: () {},
                          ),
                          BottomSheetButtonItem(
                            iconImage:
                                'assets/image/feed/icon/small_size/icon_report.png',
                            title: '삭제하기',
                            titleStyle:
                                kButton14BoldStyle.copyWith(color: kBadgeColor),
                            onTap: () {
                              context.pop();
                              context.push("/home/report/false");
                            },
                          ),
                        ],
                      ),
                    )
                  : showCustomModalBottomSheet(
                      context: context,
                      widget: Column(
                        children: [
                          BottomSheetButtonItem(
                            iconImage:
                                'assets/image/feed/icon/small_size/icon_user_de.png',
                            title: '숨기기',
                            titleStyle: kButton14BoldStyle.copyWith(
                                color: kTextSubTitleColor),
                            onTap: () {},
                          ),
                          BottomSheetButtonItem(
                            iconImage:
                                'assets/image/feed/icon/small_size/icon_user_block_on.png',
                            title: '차단하기',
                            titleStyle: kButton14BoldStyle.copyWith(
                                color: kTextSubTitleColor),
                            onTap: () {},
                          ),
                          BottomSheetButtonItem(
                            iconImage:
                                'assets/image/feed/icon/small_size/icon_report.png',
                            title: '신고하기',
                            titleStyle:
                                kButton14BoldStyle.copyWith(color: kBadgeColor),
                            onTap: () {
                              context.pop();
                              context.push("/home/report/false");
                            },
                          ),
                        ],
                      ),
                    );
            },
            child: Image.asset(
              'assets/image/feed/icon/small_size/icon_more.png',
              height: 32.w,
            ),
          ),
        ],
      ),
    );
  }
}
