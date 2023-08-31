import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_post/my_post_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_information/user_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_edit_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:widget_mask/widget_mask.dart';

class FeedTitleWidget extends ConsumerWidget {
  const FeedTitleWidget({
    required this.feedData,
    required this.profileImage,
    required this.userName,
    required this.address,
    required this.time,
    required this.isEdit,
    required this.memberIdx,
    required this.isKeep,
    required this.contentIdx,
    required this.contentType,
    required this.oldMemberIdx,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String? userName;
  final String address;
  final String time;
  final bool isEdit;
  final int? memberIdx;
  final bool isKeep;
  final int contentIdx;
  final String contentType;
  final FeedData feedData;
  final int oldMemberIdx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(userModelProvider)?.idx == memberIdx
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPageMainScreen(
                    oldMemberIdx: oldMemberIdx,
                  ),
                ),
              )
            : context.push(
                "/home/myPage/followList/$memberIdx/userPage/$userName/$memberIdx/$oldMemberIdx");
      },
      child: Material(
        color: kNeutralColor100,
        child: Padding(
          padding: EdgeInsets.only(left: 16.0.w, right: 16.w, bottom: 12.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  getProfileAvatar(profileImage ?? "", 32.w, 32.h),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userName}",
                        style:
                            kTitle14BoldStyle.copyWith(color: kTextTitleColor),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          Text(
                            address,
                            style: kBody11RegularStyle.copyWith(
                                color: kTextBodyColor),
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
                  memberIdx == ref.read(userModelProvider)?.idx
                      ? showCustomModalBottomSheet(
                          context: context,
                          widget: Column(
                            children: [
                              isKeep
                                  ? BottomSheetButtonItem(
                                      icon: const Icon(
                                        Puppycat_social.icon_user_ac,
                                      ),
                                      title: '프로필 표시하기',
                                      titleStyle: kButton14BoldStyle.copyWith(
                                          color: kTextSubTitleColor),
                                      onTap: () async {
                                        context.pop();

                                        final result = await ref
                                            .watch(
                                                feedListStateProvider.notifier)
                                            .deleteOneKeepContents(
                                              loginMemberIdx: ref
                                                  .read(userModelProvider)!
                                                  .idx,
                                              contentType: contentType,
                                              contentIdx: contentIdx,
                                            );

                                        if (result.result) {
                                          toast(
                                            context: context,
                                            text: '게시물 보관이 취소됐습니다.',
                                            type: ToastType.purple,
                                          );
                                        }
                                      },
                                    )
                                  : BottomSheetButtonItem(
                                      icon: const Icon(
                                        Puppycat_social.icon_keep,
                                      ),
                                      title: '보관하기',
                                      titleStyle: kButton14BoldStyle.copyWith(
                                          color: kTextSubTitleColor),
                                      onTap: () async {
                                        context.pop();

                                        final result = await ref
                                            .watch(
                                                feedListStateProvider.notifier)
                                            .postKeepContents(
                                              loginMemberIdx: ref
                                                  .read(userModelProvider)!
                                                  .idx,
                                              contentIdxList: [contentIdx],
                                              contentType: contentType,
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
                                icon: const Icon(
                                  Puppycat_social.icon_modify,
                                ),
                                title: '수정하기',
                                titleStyle: kButton14BoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FeedEditScreen(
                                        feedData: feedData,
                                        contentIdx: contentIdx,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              BottomSheetButtonItem(
                                icon: const Icon(
                                  Puppycat_social.icon_delete_small,
                                  color: kBadgeColor,
                                ),
                                title: '삭제하기',
                                titleStyle: kButton14BoldStyle.copyWith(
                                    color: kBadgeColor),
                                onTap: () async {
                                  context.pop();

                                  final result = await ref
                                      .watch(feedListStateProvider.notifier)
                                      .deleteOneContents(
                                        loginMemberIdx:
                                            ref.read(userModelProvider)!.idx,
                                        contentType: contentType,
                                        contentIdx: contentIdx,
                                      );

                                  if (result.result) {
                                    toast(
                                      context: context,
                                      text: '게시물 삭제가 완료되었습니다.',
                                      type: ToastType.purple,
                                    );
                                  }
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
                                icon: const Icon(
                                  Puppycat_social.icon_user_de,
                                ),
                                title: '숨기기',
                                titleStyle: kButton14BoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                                onTap: () async {
                                  if (ref.read(userModelProvider) == null) {
                                    context.pushReplacement("/loginScreen");
                                  } else {
                                    context.pop();

                                    final result = await ref
                                        .watch(feedListStateProvider.notifier)
                                        .postHide(
                                          loginMemberIdx:
                                              ref.read(userModelProvider)!.idx,
                                          contentType: contentType,
                                          contentIdx: contentIdx,
                                          memberIdx: memberIdx,
                                        );

                                    if (result.result) {
                                      toast(
                                        context: context,
                                        text: '게시물 숨기기를 완료하였습니다.',
                                        type: ToastType.purple,
                                        buttonText: "숨기기 취소",
                                        buttonOnTap: () async {
                                          final result = await ref
                                              .watch(feedListStateProvider
                                                  .notifier)
                                              .deleteHide(
                                                loginMemberIdx: ref
                                                    .read(userModelProvider)!
                                                    .idx,
                                                contentType: contentType,
                                                contentIdx: contentIdx,
                                                memberIdx: memberIdx,
                                              );

                                          if (result.result) {
                                            toast(
                                              context: context,
                                              text: '게시물 숨기기 취소',
                                              type: ToastType.purple,
                                            );
                                          }
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                              feedData.followState == 1
                                  ? BottomSheetButtonItem(
                                      icon: const Icon(
                                        Puppycat_social.icon_follow_cancel,
                                      ),
                                      title: '팔로우 취소',
                                      titleStyle: kButton14BoldStyle.copyWith(
                                          color: kTextSubTitleColor),
                                      onTap: () async {
                                        context.pop();

                                        ref
                                            .watch(
                                                feedListStateProvider.notifier)
                                            .deleteFollow(
                                              memberIdx: ref
                                                  .read(userModelProvider)!
                                                  .idx,
                                              followIdx: feedData.memberIdx,
                                              contentsIdx: feedData.idx,
                                              contentType: contentType,
                                            );
                                      },
                                    )
                                  : Container(),
                              BottomSheetButtonItem(
                                icon: const Icon(
                                  Puppycat_social.icon_user_block_ac,
                                ),
                                title: '차단하기',
                                titleStyle: kButton14BoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                                onTap: () async {
                                  if (ref.read(userModelProvider) == null) {
                                    context.pushReplacement("/loginScreen");
                                  } else {
                                    context.pop();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                            content: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 24.0.h),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "‘${userName}’님을\n차단하시겠어요?",
                                                    style: kBody16BoldStyle
                                                        .copyWith(
                                                            color:
                                                                kTextTitleColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                  Text(
                                                    "‘${userName}’님은 더 이상 회원님의\n게시물을 보거나 메시지 등을 보낼 수 없습니다.",
                                                    style: kBody12RegularStyle
                                                        .copyWith(
                                                            color:
                                                                kTextBodyColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                  Text(
                                                    " ‘${userName}’님에게는 차단 정보를 알리지 않으며\n[마이페이지 → 설정 → 차단 친구 관리] 에서\n언제든지 해제할 수 있습니다.",
                                                    style: kBody12RegularStyle
                                                        .copyWith(
                                                            color:
                                                                kTextBodyColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            confirmTap: () async {
                                              context.pop();

                                              final result = await ref
                                                  .read(feedListStateProvider
                                                      .notifier)
                                                  .postBlock(
                                                    memberIdx: ref
                                                        .watch(
                                                            userModelProvider)!
                                                        .idx,
                                                    blockIdx: memberIdx,
                                                    contentType: contentType,
                                                    contentIdx: contentIdx,
                                                  );

                                              if (result.result) {
                                                context.pop();

                                                toast(
                                                  context: context,
                                                  text:
                                                      "‘${userName}’님을 차단하였습니다.",
                                                  type: ToastType.purple,
                                                );
                                              }
                                            },
                                            cancelTap: () {
                                              context.pop();
                                            },
                                            confirmWidget: Text(
                                              "유저 차단",
                                              style: kButton14MediumStyle
                                                  .copyWith(color: kBadgeColor),
                                            ));
                                      },
                                    );
                                  }
                                },
                              ),
                              BottomSheetButtonItem(
                                icon: const Icon(
                                  Puppycat_social.icon_report1,
                                  color: kBadgeColor,
                                ),
                                title: '신고하기',
                                titleStyle: kButton14BoldStyle.copyWith(
                                    color: kBadgeColor),
                                onTap: () {
                                  if (ref.read(userModelProvider) == null) {
                                    context.pushReplacement("/loginScreen");
                                  } else {
                                    context.pop();
                                    context
                                        .push("/home/report/false/$contentIdx");
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                },
                child: const Icon(
                  Puppycat_social.icon_more,
                  color: kTextBodyColor,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
