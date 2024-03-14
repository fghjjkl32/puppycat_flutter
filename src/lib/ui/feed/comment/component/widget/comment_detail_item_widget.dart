import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/comment/main_comment_header_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

class CommentDetailItemWidget extends ConsumerStatefulWidget {
  const CommentDetailItemWidget({
    required this.parentIdx,
    required this.contentIdx,
    required this.commentIdx,
    required this.profileImage,
    required this.name,
    required this.comment,
    required this.isSpecialUser,
    required this.time,
    required this.isReply,
    required this.likeCount,
    required this.isLike,
    required this.memberUuid,
    required this.mentionListData,
    // this.replies,
    required this.isLastDisPlayChild,
    // required this.remainChildCount,
    this.onMoreChildComment,
    required this.pageNumber,
    required this.isDisplayPreviousMore,
    this.onPrevMoreChildComment,
    required this.oldMemberUuid,
    this.onTapRemoveButton,
    this.onTapEditButton,
    Key? key,
  }) : super(key: key);

  final int parentIdx;
  final int contentIdx;
  final int commentIdx;
  final String? profileImage;
  final String name;
  final String comment;
  final bool isSpecialUser;
  final DateTime time;
  final bool isReply;
  final int likeCount;
  final bool isLike;

  // final ChildCommentData? replies;
  final String memberUuid;
  final List<MentionListData> mentionListData;
  final String oldMemberUuid;
  final bool isLastDisPlayChild;

  // final int remainChildCount;
  final Function? onMoreChildComment;
  final int pageNumber;
  final bool isDisplayPreviousMore;
  final Function? onPrevMoreChildComment;

  final Function? onTapRemoveButton;
  final Function? onTapEditButton;

  @override
  CommentDetailItemWidgetState createState() => CommentDetailItemWidgetState();
}

class CommentDetailItemWidgetState extends ConsumerState<CommentDetailItemWidget> with TickerProviderStateMixin {
  bool showLikeLottieAnimation = false;

  late final AnimationController likeController;

  @override
  void initState() {
    likeController = AnimationController(
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    likeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isReply
                  ? const SizedBox(
                      width: 30,
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  myInfo.uuid == widget.memberUuid
                      ? context.push("/member/myPage", extra: {"oldMemberUuid": widget.oldMemberUuid, "feedContentIdx": widget.contentIdx})
                      : context.push("/member/userPage", extra: {"nick": widget.name, "memberUuid": widget.memberUuid, "oldMemberUuid": widget.oldMemberUuid, "feedContentIdx": widget.contentIdx});
                },
                child: getProfileAvatar(widget.profileImage ?? '', 30, 30),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.isDisplayPreviousMore)
                      GestureDetector(
                        onTap: () {
                          if (widget.onPrevMoreChildComment != null) {
                            widget.onPrevMoreChildComment!(widget.pageNumber);
                          }
                        },
                        child: Center(
                          child: Text(
                            "댓글.이전 답글 더 보기".tr(),
                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onDoubleTap: () {
                        if (!isLogined) {
                          context.push("/home/login");
                        } else {
                          if (!ref.watch(commentLikeApiIsLoadingStateProvider) && widget.isLike) {
                            ref.watch(commentListStateProvider.notifier).postCommentLike(
                                  commentIdx: widget.commentIdx,
                                );
                          }
                        }
                      },
                      child: Bubble(
                        // isComment: true,
                        radius: const Radius.circular(10),
                        elevation: 0,
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftTop,
                        nipOffset: 15,
                        color: kPreviousNeutralColor200,
                        padding: const BubbleEdges.only(left: 12, right: 12, top: 10, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      myInfo.uuid == widget.memberUuid
                                          ? context.push("/member/myPage", extra: {"oldMemberUuid": widget.oldMemberUuid, "feedContentIdx": widget.contentIdx})
                                          : context.push("/member/userPage",
                                              extra: {"nick": widget.name, "memberUuid": widget.memberUuid, "oldMemberUuid": widget.oldMemberUuid, "feedContentIdx": widget.contentIdx});
                                    },
                                    child: Row(
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
                                        Expanded(
                                          child: Text(
                                            widget.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      displayedAt(widget.time),
                                      style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.memberUuid == myInfo.uuid
                                            ? showCustomModalBottomSheet(
                                                context: context,
                                                widget: Column(
                                                  children: [
                                                    BottomSheetButtonItem(
                                                      icon: const Icon(
                                                        Puppycat_social.icon_modify,
                                                      ),
                                                      title: '댓글.수정하기'.tr(),
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                                      onTap: () async {
                                                        if (widget.onTapEditButton != null) {
                                                          widget.onTapEditButton!();
                                                        }
                                                      },
                                                    ),
                                                    BottomSheetButtonItem(
                                                      icon: const Icon(
                                                        Puppycat_social.icon_delete_small,
                                                        color: kPreviousErrorColor,
                                                      ),
                                                      title: '댓글.삭제하기'.tr(),
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousErrorColor),
                                                      onTap: () async {
                                                        if (widget.onTapRemoveButton != null) {
                                                          widget.onTapRemoveButton!();
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
                                                        Puppycat_social.icon_user_block_ac,
                                                      ),
                                                      title: '댓글.차단하기'.tr(),
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                                      onTap: () async {
                                                        context.pop();

                                                        isLogined == false
                                                            ? context.push("/home/login")
                                                            : showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return CustomDialog(
                                                                    content: Padding(
                                                                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                                                                      child: Column(
                                                                        children: [
                                                                          Text(
                                                                            "댓글.차단 제목".tr(args: [widget.name]),
                                                                            style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 8,
                                                                          ),
                                                                          Text(
                                                                            "댓글.차단 내용".tr(),
                                                                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    confirmTap: () async {
                                                                      context.pop();

                                                                      final result = await ref.read(commentListStateProvider.notifier).postBlock(
                                                                            blockUuid: widget.memberUuid,
                                                                          );

                                                                      if (result.result && mounted) {
                                                                        context.pop();

                                                                        toast(
                                                                          context: context,
                                                                          text: "댓글.차단 완료".tr(args: [widget.name.length > 8 ? '${widget.name.substring(0, 8)}...' : widget.name]),
                                                                          type: ToastType.purple,
                                                                        );
                                                                      }
                                                                    },
                                                                    cancelTap: () {
                                                                      context.pop();
                                                                    },
                                                                    confirmWidget: Text(
                                                                      "댓글.차단하기".tr(),
                                                                      style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                      },
                                                    ),
                                                    BottomSheetButtonItem(
                                                      icon: const Icon(
                                                        Puppycat_social.icon_report1,
                                                        color: kPreviousErrorColor,
                                                      ),
                                                      title: '댓글.신고하기'.tr(),
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousErrorColor),
                                                      onTap: () {
                                                        context.pop();
                                                        isLogined == false ? context.push("/home/login") : context.push("/feed/report/true/${widget.commentIdx}");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                      },
                                      child: const Icon(
                                        Puppycat_social.icon_more,
                                        color: kPreviousTextBodyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  children: replaceMentionsWithNicknamesInContent(
                                    widget.comment,
                                    widget.mentionListData,
                                    context,
                                    kBody13RegularStyle.copyWith(color: kPreviousSecondaryColor),
                                    ref,
                                    widget.oldMemberUuid,
                                  ),
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextTitleColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 2),
                          child: widget.isLike
                              ? InkWell(
                                  onTap: () {
                                    if (!ref.watch(commentLikeApiIsLoadingStateProvider)) {
                                      ref.watch(commentListStateProvider.notifier).deleteCommentLike(
                                            commentIdx: widget.commentIdx,
                                          );
                                    }
                                  },
                                  child: showLikeLottieAnimation
                                      ? Lottie.asset(
                                          'assets/lottie/icon_like.json',
                                          controller: likeController,
                                          onLoaded: (composition) {
                                            print("composition ${composition}");

                                            likeController.duration = composition.duration;
                                            likeController.forward();
                                          },
                                        )
                                      : const Icon(
                                          Puppycat_social.icon_comment_like_ac,
                                          color: kPreviousPrimaryColor,
                                        ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (!isLogined) {
                                      context.push("/home/login");
                                    } else {
                                      if (!ref.watch(commentLikeApiIsLoadingStateProvider)) {
                                        ref.watch(commentListStateProvider.notifier).postCommentLike(
                                              commentIdx: widget.commentIdx,
                                            );

                                        setState(() {
                                          showLikeLottieAnimation = true;
                                        });

                                        likeController.forward(from: 0);
                                      }
                                    }
                                  },
                                  child: const Icon(
                                    Puppycat_social.icon_comment_like_de,
                                    color: kPreviousTextBodyColor,
                                  ),
                                ),
                        ),
                        Text(
                          '${widget.likeCount}',
                          style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!isLogined) {
                              context.push("/home/login");
                            } else {
                              if (!widget.isReply) {
                                ref.watch(commentHeaderProvider.notifier).addReplyCommentHeader(widget.name, widget.commentIdx);
                                ref.watch(commentHeaderProvider.notifier).setHasInput(true);
                              } else {
                                ref.watch(commentHeaderProvider.notifier).addReplyCommentHeader(widget.name, widget.parentIdx);
                              }
                            }
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 12.0, right: 2),
                                child: Icon(
                                  Puppycat_social.icon_comment_comment,
                                  color: kPreviousTextBodyColor,
                                ),
                              ),
                              Text(
                                '댓글.답글쓰기'.tr(),
                                style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.isLastDisPlayChild)
                      GestureDetector(
                        onTap: () {
                          if (widget.onMoreChildComment != null) {
                            widget.onMoreChildComment!(widget.pageNumber);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                                child: Container(
                                  width: 32,
                                  height: 1,
                                  color: kNeutralColor500,
                                ),
                              ),
                              Text(
                                "댓글.답글 더 보기".tr(),
                                style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
