import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
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
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';

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
    required this.memberIdx,
    required this.mentionListData,
    // this.replies,
    required this.isLastDisPlayChild,
    // required this.remainChildCount,
    this.onMoreChildComment,
    required this.pageNumber,
    required this.isDisplayPreviousMore,
    this.onPrevMoreChildComment,
    required this.oldMemberIdx,
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
  final int memberIdx;
  final List<MentionListData> mentionListData;
  final int oldMemberIdx;
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
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isReply
                  ? SizedBox(
                      width: 30.w,
                    )
                  : Container(),
              GestureDetector(
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
                      : context.push("/home/myPage/followList/${widget.memberIdx}/userPage/${widget.name}/${widget.memberIdx}/${widget.oldMemberIdx}");
                },
                child: getProfileAvatar(widget.profileImage!, 30.w, 30.h),
              ),
              SizedBox(
                width: 8.w,
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
                            "이전 답글 10개씩 더 보기",
                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onDoubleTap: () {
                        if (ref.read(userInfoProvider).userModel == null) {
                          context.pushReplacement("/loginScreen");
                        } else {
                          if (!ref.watch(commentLikeApiIsLoadingStateProvider) && widget.isLike) {
                            ref.watch(commentListStateProvider.notifier).postCommentLike(
                                  commentIdx: widget.commentIdx,
                                  memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                  contentsIdx: widget.contentIdx,
                                );
                          }
                        }
                      },
                      child: Bubble(
                        isComment: true,
                        radius: Radius.circular(10.w),
                        elevation: 0,
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftTop,
                        nipOffset: 15.h,
                        color: kPreviousNeutralColor200,
                        padding: BubbleEdges.only(left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
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
                                          : context.push("/home/myPage/followList/${widget.memberIdx}/userPage/${widget.name}/${widget.memberIdx}/${widget.oldMemberIdx}");
                                    },
                                    child: Row(
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
                                        widget.memberIdx == ref.read(userInfoProvider).userModel?.idx
                                            ? showCustomModalBottomSheet(
                                                context: context,
                                                widget: Column(
                                                  children: [
                                                    BottomSheetButtonItem(
                                                      icon: const Icon(
                                                        Puppycat_social.icon_modify,
                                                      ),
                                                      title: '수정하기',
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
                                                      title: '삭제하기',
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
                                                      title: '차단하기',
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                                      onTap: () async {
                                                        context.pop();

                                                        ref.read(userInfoProvider).userModel == null
                                                            ? context.pushReplacement("/loginScreen")
                                                            : showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return CustomDialog(
                                                                    content: Padding(
                                                                      padding: EdgeInsets.symmetric(vertical: 24.0.h),
                                                                      child: Column(
                                                                        children: [
                                                                          Text(
                                                                            "‘${widget.name}’님을\n차단할까요?",
                                                                            style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          SizedBox(
                                                                            height: 8.h,
                                                                          ),
                                                                          Text(
                                                                            "차단하게 되면 더 이상 서로의 피드를 보거나\n메시지 등을 보낼 수 없어요.\n차단 여부는 상대방에게 알리지 않아요.\n차단 풀기는 [마이페이지→설정→차단 유저 관리]에서\n얼마든지 가능해요.",
                                                                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    confirmTap: () async {
                                                                      context.pop();

                                                                      final result = await ref.read(commentListStateProvider.notifier).postBlock(
                                                                            memberIdx: ref.watch(userInfoProvider).userModel!.idx,
                                                                            blockIdx: widget.memberIdx,
                                                                            contentsIdx: widget.contentIdx,
                                                                          );

                                                                      if (result.result && mounted) {
                                                                        context.pop();

                                                                        toast(
                                                                          context: context,
                                                                          text: "'${widget.name.length > 8 ? '${widget.name.substring(0, 8)}...' : widget.name}'님을 차단했어요.",
                                                                          type: ToastType.purple,
                                                                        );
                                                                      }
                                                                    },
                                                                    cancelTap: () {
                                                                      context.pop();
                                                                    },
                                                                    confirmWidget: Text(
                                                                      "차단하기",
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
                                                      title: '신고하기',
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousErrorColor),
                                                      onTap: () {
                                                        context.pop();
                                                        ref.read(userInfoProvider).userModel == null ? context.pushReplacement("/loginScreen") : context.push("/home/report/true/${widget.commentIdx}");
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
                            SizedBox(
                              height: 6.h,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  children: replaceMentionsWithNicknamesInContent(
                                    widget.comment,
                                    widget.mentionListData,
                                    context,
                                    kBody11RegularStyle.copyWith(color: kPreviousSecondaryColor),
                                    ref,
                                    widget.oldMemberIdx,
                                  ),
                                  style: kBody11RegularStyle.copyWith(color: kPreviousTextTitleColor),
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
                          padding: EdgeInsets.only(left: 12.0.w, right: 2.w),
                          child: widget.isLike
                              ? InkWell(
                                  onTap: () {
                                    if (!ref.watch(commentLikeApiIsLoadingStateProvider)) {
                                      ref.watch(commentListStateProvider.notifier).deleteCommentLike(
                                            commentIdx: widget.commentIdx,
                                            memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                            contentsIdx: widget.contentIdx,
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
                                      : Icon(
                                          Puppycat_social.icon_comment_like_ac,
                                          color: kPreviousPrimaryColor,
                                        ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (ref.read(userInfoProvider).userModel == null) {
                                      context.pushReplacement("/loginScreen");
                                    } else {
                                      if (!ref.watch(commentLikeApiIsLoadingStateProvider)) {
                                        ref.watch(commentListStateProvider.notifier).postCommentLike(
                                              commentIdx: widget.commentIdx,
                                              memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                              contentsIdx: widget.contentIdx,
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
                            if (ref.read(userInfoProvider).userModel == null) {
                              context.pushReplacement("/loginScreen");
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
                              Padding(
                                padding: EdgeInsets.only(left: 12.0.w, right: 2.w),
                                child: const Icon(
                                  Puppycat_social.icon_comment_comment,
                                  color: kPreviousTextBodyColor,
                                ),
                              ),
                              Text(
                                '답글쓰기',
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
                        child: Center(
                          child: Text(
                            "답글 10개씩 더 보기",
                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
