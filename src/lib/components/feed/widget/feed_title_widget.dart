import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/sheets/my_feed_delete_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/sheets/my_feed_keep_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_edit_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';

class FeedTitleWidget extends ConsumerStatefulWidget {
  const FeedTitleWidget({
    required this.feedData,
    required this.profileImage,
    required this.userName,
    required this.address,
    required this.time,
    required this.isEdit,
    required this.memberIdx,
    required this.isKeep,
    required this.isSpecialUser,
    required this.contentIdx,
    required this.contentType,
    required this.oldMemberIdx,
    required this.isDetailWidget,
    this.feedType = "recent",
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String? userName;
  final String address;
  final String time;
  final bool isEdit;
  final int? memberIdx;
  final bool isKeep;
  final bool isSpecialUser;
  final int contentIdx;
  final String contentType;
  final FeedData feedData;
  final int oldMemberIdx;
  final bool isDetailWidget;
  final String feedType;

  @override
  FeedTitleWidgetState createState() => FeedTitleWidgetState();
}

class FeedTitleWidgetState extends ConsumerState<FeedTitleWidget> {
  @override
  void initState() {
    super.initState();
    Future(() {
      final currentFollowState = ref.read(followUserStateProvider)[widget.memberIdx];
      if (currentFollowState == null) {
        ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx!, widget.feedData.followState == 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.memberIdx!] ?? false;

    return GestureDetector(
      onTap: () {
        ref.read(userInfoProvider).userModel?.idx == widget.memberIdx
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPageMainScreen(
                    oldMemberIdx: widget.oldMemberIdx,
                  ),
                ),
              )
            : context.push("/home/myPage/followList/${widget.memberIdx}/userPage/${widget.userName}/${widget.memberIdx}/${widget.oldMemberIdx}");
      },
      child: Material(
        color: kNeutralColor100,
        child: Padding(
          padding: EdgeInsets.only(left: 16.0.w, right: 16.w, bottom: 12.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    getProfileAvatar(widget.profileImage ?? "", 32.w, 32.h),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              widget.isSpecialUser
                                  ? Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/feed/icon/small_size/icon_special.png',
                                          height: 13.h,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              Flexible(
                                child: Text(
                                  "${widget.userName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTitle14BoldStyle.copyWith(color: kTextTitleColor),
                                ),
                              ),
                              if (!widget.isDetailWidget || widget.contentType == "popularWeekContent")
                                if (widget.feedType != "follow")
                                  Consumer(builder: (context, ref, child) {
                                    return ref.read(userInfoProvider).userModel?.idx != widget.memberIdx
                                        ? isFollow
                                            ? Row(
                                                children: [
                                                  Text(
                                                    " · ",
                                                    style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      if (!ref.watch(followApiIsLoadingStateProvider)) {
                                                        if (ref.read(userInfoProvider).userModel == null) {
                                                          context.pushReplacement("/loginScreen");
                                                        } else {
                                                          final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                                                memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                                followIdx: widget.memberIdx,
                                                              );

                                                          if (result.result) {
                                                            setState(() {
                                                              ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx!, false);
                                                            });
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      "팔로잉",
                                                      style: kBody12SemiBoldStyle.copyWith(color: kNeutralColor500),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    " · ",
                                                    style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      if (!ref.watch(followApiIsLoadingStateProvider)) {
                                                        if (ref.read(userInfoProvider).userModel == null) {
                                                          context.pushReplacement("/loginScreen");
                                                        } else {
                                                          final result = await ref.watch(followStateProvider.notifier).postFollow(
                                                                memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                                followIdx: widget.memberIdx,
                                                              );

                                                          if (result.result) {
                                                            setState(() {
                                                              ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx!, true);
                                                            });
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      "팔로우",
                                                      style: kBody12SemiBoldStyle.copyWith(color: kPrimaryColor),
                                                    ),
                                                  ),
                                                ],
                                              )
                                        : Container();
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.address,
                                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                              widget.address == ""
                                  ? Container()
                                  : Text(
                                      " · ",
                                      style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                                    ),
                              Text(
                                widget.time,
                                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                              widget.isEdit
                                  ? Row(
                                      children: [
                                        Text(
                                          " · ",
                                          style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                                        ),
                                        Text(
                                          "수정됨",
                                          style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.memberIdx == ref.read(userInfoProvider).userModel?.idx
                      ? showCustomModalBottomSheet(
                          context: context,
                          widget: Column(
                            children: [
                              widget.isKeep
                                  ? BottomSheetButtonItem(
                                      icon: const Icon(
                                        Puppycat_social.icon_user_ac,
                                      ),
                                      title: '프로필 표시하기',
                                      titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                      onTap: () async {
                                        context.pop();

                                        final result = await ref.watch(feedListStateProvider.notifier).deleteOneKeepContents(
                                              loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                              contentType: widget.contentType,
                                              contentIdx: widget.contentIdx,
                                            );

                                        if (result.result && mounted) {
                                          toast(
                                            context: context,
                                            text: '피드 보관이 취소됐습니다.',
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
                                      titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                      onTap: () async {
                                        context.pop();

                                        myFeedKeepBottomSheet(
                                          context: context,
                                          onTap: () async {
                                            context.pop();

                                            final result = await ref.watch(feedListStateProvider.notifier).postKeepContents(
                                                  loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                  contentIdxList: [widget.contentIdx],
                                                  contentType: widget.contentType,
                                                );

                                            if (result.result && mounted) {
                                              toast(
                                                context: context,
                                                text: '피드 보관이 완료되었습니다.',
                                                type: ToastType.purple,
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                              BottomSheetButtonItem(
                                icon: const Icon(
                                  Puppycat_social.icon_modify,
                                ),
                                title: '수정하기',
                                titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FeedEditScreen(
                                        feedData: widget.feedData,
                                        contentIdx: widget.contentIdx,
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
                                titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
                                onTap: () async {
                                  context.pop();

                                  myFeedDeleteBottomSheet(
                                    context: context,
                                    onTap: () async {
                                      context.pop();

                                      final result = await ref.watch(feedListStateProvider.notifier).deleteOneContents(
                                            loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                            contentType: widget.contentType,
                                            contentIdx: widget.contentIdx,
                                          );

                                      if (result.result && mounted) {
                                        toast(
                                          context: context,
                                          text: '피드 삭제가 완료되었습니다.',
                                          type: ToastType.purple,
                                        );
                                      }
                                    },
                                  );
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
                                titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                onTap: () async {
                                  if (ref.read(userInfoProvider).userModel == null) {
                                    context.pushReplacement("/loginScreen");
                                  } else {
                                    final tempContentIdx = widget.contentIdx;
                                    context.pop();

                                    final result = await ref.watch(feedListStateProvider.notifier).postHide(
                                          loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                          contentType: widget.contentType,
                                          contentIdx: tempContentIdx,
                                          memberIdx: widget.memberIdx,
                                        );

                                    if (result.result && mounted) {
                                      toast(
                                        context: context,
                                        text: '피드 숨기기를 완료하였습니다.',
                                        type: ToastType.purple,
                                        buttonText: "숨기기 취소",
                                        buttonOnTap: () async {
                                          if (!mounted) return;

                                          final result = await ref.watch(feedListStateProvider.notifier).deleteHide(
                                                loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                contentType: widget.contentType,
                                                contentIdx: tempContentIdx,
                                                memberIdx: widget.memberIdx,
                                              );

                                          if (result.result && mounted) {
                                            toast(
                                              context: context,
                                              text: '피드 숨기기 취소',
                                              type: ToastType.purple,
                                            );
                                          }
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                              isFollow
                                  ? BottomSheetButtonItem(
                                      icon: const Icon(
                                        Puppycat_social.icon_follow_cancel,
                                      ),
                                      title: '팔로우 취소',
                                      titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                      onTap: () async {
                                        if (!ref.watch(followApiIsLoadingStateProvider)) {
                                          context.pop();

                                          // ref.watch(feedListStateProvider.notifier).deleteFollow(
                                          //       memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                          //       followIdx: widget.feedData.memberIdx,
                                          //       contentsIdx: widget.feedData.idx,
                                          //       contentType: widget.contentType,
                                          //     );

                                          final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                                memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                followIdx: widget.memberIdx,
                                              );

                                          if (result.result) {
                                            setState(() {
                                              ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx!, false);
                                            });
                                          }
                                        }
                                      },
                                    )
                                  : Container(),
                              BottomSheetButtonItem(
                                icon: const Icon(
                                  Puppycat_social.icon_user_block_ac,
                                ),
                                title: '차단하기',
                                titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                onTap: () async {
                                  if (ref.read(userInfoProvider).userModel == null) {
                                    context.pushReplacement("/loginScreen");
                                  } else {
                                    Navigator.of(context).pop();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return CustomDialog(
                                            content: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 24.0.h),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "‘${widget.userName}’님을\n차단하시겠어요?",
                                                    style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                  Text(
                                                    "‘${widget.userName}’님은 더 이상 회원님의\n피드를 보거나 메시지 등을 보낼 수 없습니다.",
                                                    style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                  Text(
                                                    " ‘${widget.userName}’님에게는 차단 정보를 알리지 않으며\n[마이페이지 → 설정 → 차단 유저 관리] 에서\n언제든지 해제할 수 있습니다.",
                                                    style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            confirmTap: () async {
                                              if (mounted) {
                                                context.pop();

                                                final result = await ref.read(feedListStateProvider.notifier).postBlock(
                                                      memberIdx: ref.watch(userInfoProvider).userModel!.idx,
                                                      blockIdx: widget.memberIdx,
                                                      contentType: widget.contentType,
                                                    );

                                                if (result.result && mounted) {
                                                  String location = GoRouter.of(context).location();

                                                  if (location.contains("/home/myPage/detail/")) {
                                                    context.pop();
                                                  }

                                                  toast(
                                                    context: context,
                                                    text: "'${widget.userName!.length > 8 ? '${widget.userName!.substring(0, 8)}...' : widget.userName}'님을 차단하였습니다.",
                                                    type: ToastType.purple,
                                                  );
                                                }
                                              }
                                            },
                                            cancelTap: () {
                                              context.pop();
                                            },
                                            confirmWidget: Text(
                                              "유저 차단",
                                              style: kButton14MediumStyle.copyWith(color: kBadgeColor),
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
                                titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
                                onTap: () {
                                  if (ref.read(userInfoProvider).userModel == null) {
                                    context.pushReplacement("/loginScreen");
                                  } else {
                                    context.pop();
                                    context.push("/home/report/false/${widget.contentIdx}");
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
