import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/router/router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/sheets/my_feed_delete_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/sheets/my_feed_keep_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

class FeedTitleWidget extends ConsumerStatefulWidget {
  const FeedTitleWidget({
    required this.feedData,
    required this.profileImage,
    required this.userName,
    required this.address,
    required this.time,
    required this.isEdit,
    required this.memberUuid,
    required this.isKeep,
    required this.isSpecialUser,
    required this.contentIdx,
    required this.contentType,
    required this.oldMemberUuid,
    required this.isDetailWidget,
    this.feedType = "recent",
    required this.onTapHideButton,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String? userName;
  final String address;
  final String time;
  final bool isEdit;
  final String memberUuid;

  final bool isKeep;
  final bool isSpecialUser;
  final int contentIdx;
  final String contentType;
  final FeedData feedData;
  final String oldMemberUuid;
  final bool isDetailWidget;
  final String feedType;
  final Function onTapHideButton;

  @override
  FeedTitleWidgetState createState() => FeedTitleWidgetState();
}

class FeedTitleWidgetState extends ConsumerState<FeedTitleWidget> {
  @override
  void initState() {
    super.initState();
    Future(() {
      final currentFollowState = ref.read(followUserStateProvider)[widget.memberUuid];
      if (currentFollowState == null) {
        ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.memberUuid, followState: widget.feedData.followState == 1, isActionButton: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.memberUuid] ?? false;
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return GestureDetector(
      onTap: () {
        myInfo.uuid == widget.memberUuid
            ? context.push("/member/myPage", extra: {"oldMemberUuid": widget.oldMemberUuid})
            : context.push("/member/userPage", extra: {"nick": widget.userName, "memberUuid": widget.memberUuid, "oldMemberUuid": widget.oldMemberUuid});
      },
      child: Material(
        color: kPreviousNeutralColor100,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    getProfileAvatar(widget.profileImage ?? "", 32, 32),
                    const SizedBox(
                      width: 10,
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
                                          height: 13,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              Flexible(
                                child: Text(
                                  "${widget.userName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kTitle14BoldStyle.copyWith(color: kTextPrimary),
                                ),
                              ),
                              if (!widget.isDetailWidget || widget.contentType == "popularWeekContent" || widget.contentType == "searchContent")
                                if (widget.feedType != "follow")
                                  Consumer(builder: (context, ref, child) {
                                    print('feed myInfo.uuid ${myInfo.uuid} /  widget.memberUuid ${widget.memberUuid} ');
                                    return myInfo.uuid != widget.memberUuid
                                        ? isFollow
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "   ·   ",
                                                    style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      if (!isLogined) {
                                                        context.push("/home/login");
                                                      } else {
                                                        setState(() {
                                                          ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.memberUuid, followState: false, isActionButton: true);
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      "피드.팔로잉".tr(),
                                                      style: kTitle14BoldStyle.copyWith(color: kPreviousNeutralColor500),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    "   ·   ",
                                                    style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      if (!isLogined) {
                                                        context.push("/home/login");
                                                      } else {
                                                        setState(() {
                                                          ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.memberUuid, followState: true, isActionButton: true);
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      "피드.팔로우".tr(),
                                                      style: kTitle14BoldStyle.copyWith(color: kTextActionPrimary),
                                                    ),
                                                  ),
                                                ],
                                              )
                                        : Container();
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.address,
                                style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                              widget.address == ""
                                  ? Container()
                                  : Text(
                                      " · ",
                                      style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                    ),
                              Text(
                                widget.time,
                                style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                              widget.isEdit
                                  ? Row(
                                      children: [
                                        Text(
                                          " · ",
                                          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                        ),
                                        Text(
                                          "피드.수정됨".tr(),
                                          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
                onTap: () async {
                  await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(widget.contentType, widget.feedData.idx, isUpdateState: false).then(
                    (value) {
                      if (value == null) {
                        return;
                      }

                      widget.memberUuid == myInfo.uuid
                          ? showCustomModalBottomSheet(
                              context: context,
                              widget: Column(
                                children: [
                                  widget.isKeep
                                      ? BottomSheetButtonItem(
                                          icon: const Icon(
                                            Puppycat_social.icon_user_ac,
                                          ),
                                          title: '피드.전체 공개하기'.tr(),
                                          titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                          onTap: () async {
                                            context.pop();

                                            final result = await ref.watch(feedListStateProvider.notifier).deleteOneKeepContents(
                                                  contentType: widget.contentType,
                                                  contentIdx: widget.contentIdx,
                                                );

                                            if (result.result && mounted) {
                                              toast(
                                                context: context,
                                                text: '피드.피드 보관을 취소했어요'.tr(),
                                                type: ToastType.purple,
                                              );
                                            }
                                          },
                                        )
                                      : BottomSheetButtonItem(
                                          icon: const Icon(
                                            Puppycat_social.icon_keep,
                                          ),
                                          title: '피드.보관하기'.tr(),
                                          titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                          onTap: () async {
                                            context.pop();

                                            myFeedKeepBottomSheet(
                                              context: context,
                                              onTap: () async {
                                                context.pop();

                                                final result = await ref.watch(feedListStateProvider.notifier).postKeepContents(
                                                  contentIdxList: [widget.contentIdx],
                                                  contentType: widget.contentType,
                                                );

                                                if (result.result && mounted) {
                                                  toast(
                                                    context: context,
                                                    text: '피드.피드 보관 완료!'.tr(),
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
                                    title: '피드.수정하기'.tr(),
                                    titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                    onTap: () async {
                                      final restrain = await ref.read(restrainStateProvider.notifier).checkRestrainStatus(RestrainCheckType.writeFeed);

                                      context.pop();

                                      if (restrain) {
                                        context.push('/feed/edit', extra: {
                                          "feedData": widget.feedData,
                                          "contentIdx": widget.contentIdx,
                                        });
                                      }
                                    },
                                  ),
                                  BottomSheetButtonItem(
                                    icon: const Icon(
                                      Puppycat_social.icon_delete_small,
                                      color: kPreviousErrorColor,
                                    ),
                                    title: '피드.삭제하기'.tr(),
                                    titleStyle: kButton14BoldStyle.copyWith(color: kPreviousErrorColor),
                                    onTap: () async {
                                      context.pop();

                                      myFeedDeleteBottomSheet(
                                        context: context,
                                        onTap: () async {
                                          context.pop();

                                          final result = await ref.watch(feedListStateProvider.notifier).deleteOneContents(
                                                contentType: widget.contentType,
                                                contentIdx: widget.contentIdx,
                                              );

                                          if (result.result && mounted) {
                                            toast(
                                              context: context,
                                              text: '피드.피드 삭제 완료!'.tr(),
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
                                    title: '피드.숨기기'.tr(),
                                    titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                    onTap: () async {
                                      widget.onTapHideButton();
                                    },
                                  ),
                                  isFollow
                                      ? BottomSheetButtonItem(
                                          icon: const Icon(
                                            Puppycat_social.icon_follow_cancel,
                                          ),
                                          title: '피드.팔로우 취소하기'.tr(),
                                          titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                          onTap: () async {
                                            context.pop();

                                            setState(() {
                                              ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.memberUuid, followState: false, isActionButton: true);
                                            });
                                          },
                                        )
                                      : Container(),
                                  BottomSheetButtonItem(
                                    icon: const Icon(
                                      Puppycat_social.icon_user_block_ac,
                                    ),
                                    title: '피드.차단하기'.tr(),
                                    titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                    onTap: () async {
                                      if (!isLogined) {
                                        context.push("/home/login");
                                      } else {
                                        context.pop();

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext ctx) {
                                            return CustomDialog(
                                              content: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "피드.차단 제목".tr(args: ["${widget.userName}"]),
                                                      style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      "피드.차단 내용".tr(),
                                                      style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              confirmTap: () async {
                                                if (mounted) {
                                                  context.pop();

                                                  final result = await ref.read(feedListStateProvider.notifier).postBlock(
                                                        blockUuid: widget.memberUuid,
                                                        contentType: widget.contentType,
                                                      );

                                                  if (result.result && mounted) {
                                                    String location = GoRouter.of(context).location();

                                                    if (location.contains("/feed/detail/")) {
                                                      context.pop();
                                                    }

                                                    toast(
                                                      context: context,
                                                      text: "피드.차단 완료".tr(args: ['${widget.userName!.length > 8 ? '${widget.userName!.substring(0, 8)}...' : widget.userName}']),
                                                      type: ToastType.purple,
                                                    );
                                                  }
                                                }
                                              },
                                              cancelTap: () {
                                                context.pop();
                                              },
                                              confirmWidget: Text(
                                                "피드.차단하기".tr(),
                                                style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  BottomSheetButtonItem(
                                    icon: const Icon(
                                      Puppycat_social.icon_report1,
                                      color: kPreviousErrorColor,
                                    ),
                                    title: '피드.신고하기'.tr(),
                                    titleStyle: kButton14BoldStyle.copyWith(color: kPreviousErrorColor),
                                    onTap: () {
                                      if (!isLogined) {
                                        context.push("/home/login");
                                      } else {
                                        context.pop();
                                        context.push("/feed/report/false/${widget.contentIdx}");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                    },
                  );
                },
                child: const Icon(
                  Puppycat_social.icon_more,
                  color: kPreviousTextBodyColor,
                  size: 26,
                ),
              ).throttle(),
            ],
          ),
        ),
      ),
    ).throttle();
  }
}
