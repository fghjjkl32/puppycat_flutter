import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/comment_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:widget_mask/widget_mask.dart';

class CommentDetailItemWidget extends ConsumerWidget {
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
  final bool isLastDisPlayChild;

  // final int remainChildCount;
  final Function? onMoreChildComment;
  final int pageNumber;
  final bool isDisplayPreviousMore;
  final Function? onPrevMoreChildComment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isReply
                  ? SizedBox(
                      width: 30.w,
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  ref.read(userModelProvider)!.idx == memberIdx ? context.push("/home/myPage") : context.push("/home/myPage/followList/$memberIdx/userPage/$name/$memberIdx");
                },
                child: getProfileAvatar(profileImage!, 30.w, 30.h),
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDisplayPreviousMore)
                      GestureDetector(
                        onTap: () {
                          if (onPrevMoreChildComment != null) {
                            onPrevMoreChildComment!(pageNumber);
                          }
                        },
                        child: Center(
                          child: Text(
                            "이전 답글 10개씩 더 보기",
                            style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onDoubleTap: () {
                        isLike
                            ? null
                            : ref.watch(commentStateProvider.notifier).postCommentLike(
                                  commentIdx: commentIdx,
                                  memberIdx: ref.read(userModelProvider)!.idx,
                                  contentsIdx: contentIdx,
                                );
                      },
                      child: Bubble(
                        isComment: true,
                        radius: Radius.circular(10.w),
                        elevation: 0,
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftTop,
                        nipOffset: 15.h,
                        color: kNeutralColor200,
                        padding: BubbleEdges.only(left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ref.read(userModelProvider)!.idx == memberIdx ? context.push("/home/myPage") : context.push("/home/myPage/followList/$memberIdx/userPage/$name/$memberIdx");
                                  },
                                  child: Row(
                                    children: [
                                      isSpecialUser
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
                                      Text(
                                        name,
                                        style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      displayedAt(time),
                                      style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        memberIdx == ref.read(userModelProvider)!.idx
                                            ? showCustomModalBottomSheet(
                                                context: context,
                                                widget: Column(
                                                  children: [
                                                    BottomSheetButtonItem(
                                                      iconImage: 'assets/image/feed/icon/small_size/icon_report.png',
                                                      title: '수정하기',
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
                                                      onTap: () async {
                                                        final commentHeaderState = ref.watch(commentHeaderProvider.notifier);

                                                        // context.pop();

                                                        commentHeaderState.addEditCommentHeader(comment, commentIdx);

                                                        commentHeaderState.setHasInput(true);

                                                        commentHeaderState.setControllerValue(replaceMentionsWithNicknamesInContentAsString(comment, mentionListData));
                                                        context.pop();
                                                      },
                                                    ),
                                                    BottomSheetButtonItem(
                                                      iconImage: 'assets/image/feed/icon/small_size/icon_report.png',
                                                      title: '삭제하기',
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
                                                      onTap: () async {
                                                        final result = await ref.watch(commentStateProvider.notifier).deleteContents(
                                                              memberIdx: ref.read(userModelProvider)!.idx,
                                                              contentsIdx: contentIdx,
                                                              commentIdx: commentIdx,
                                                              parentIdx: parentIdx,
                                                            );

                                                        if (result.result) {
                                                          context.pop();
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
                                                      iconImage: 'assets/image/feed/icon/small_size/icon_user_block_on.png',
                                                      title: '차단하기',
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                                      onTap: () async {
                                                        context.pop();

                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return CustomDialog(
                                                                content: Padding(
                                                                  padding: EdgeInsets.symmetric(vertical: 24.0.h),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        "‘${name}’님을\n차단하시겠어요?",
                                                                        style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 8.h,
                                                                      ),
                                                                      Text(
                                                                        "‘${name}’님은 더 이상 회원님의\n게시물을 보거나 메시지 등을 보낼 수 없습니다.",
                                                                        style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 8.h,
                                                                      ),
                                                                      Text(
                                                                        " ‘${name}’님에게는 차단 정보를 알리지 않으며\n[마이페이지 → 설정 → 차단 친구 관리] 에서\n언제든지 해제할 수 있습니다.",
                                                                        style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                confirmTap: () async {
                                                                  context.pop();

                                                                  final result = await ref.read(commentStateProvider.notifier).postBlock(
                                                                        memberIdx: ref.watch(userModelProvider)!.idx,
                                                                        blockIdx: memberIdx,
                                                                        contentsIdx: contentIdx,
                                                                      );

                                                                  if (result.result) {
                                                                    context.pop();

                                                                    toast(
                                                                      context: context,
                                                                      text: "‘${name}’님을 차단하였습니다.",
                                                                      type: ToastType.purple,
                                                                    );
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
                                                      },
                                                    ),
                                                    BottomSheetButtonItem(
                                                      iconImage: 'assets/image/feed/icon/small_size/icon_report.png',
                                                      title: '신고하기',
                                                      titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
                                                      onTap: () {
                                                        context.pop();
                                                        context.push("/home/report/true/$commentIdx");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                      },
                                      child: Image.asset(
                                        'assets/image/feed/icon/small_size/icon_more.png',
                                        height: 26.w,
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
                                    comment,
                                    mentionListData,
                                    context,
                                    kBody11RegularStyle.copyWith(color: kSecondaryColor),
                                    ref,
                                  ),
                                  style: kBody11RegularStyle.copyWith(color: kTextTitleColor),
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
                          padding: EdgeInsets.only(left: 12.0.w, top: 2.h, right: 2.w),
                          child: isLike
                              ? InkWell(
                                  onTap: () {
                                    ref.watch(commentStateProvider.notifier).deleteCommentLike(
                                          commentIdx: commentIdx,
                                          memberIdx: ref.read(userModelProvider)!.idx,
                                          contentsIdx: contentIdx,
                                        );
                                  },
                                  child: Image.asset(
                                    'assets/image/feed/icon/small_size/icon_comment_like_on.png',
                                    height: 26.w,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    ref.watch(commentStateProvider.notifier).postCommentLike(
                                          commentIdx: commentIdx,
                                          memberIdx: ref.read(userModelProvider)!.idx,
                                          contentsIdx: contentIdx,
                                        );
                                  },
                                  child: Image.asset(
                                    'assets/image/feed/icon/small_size/icon_comment_like_off.png',
                                    height: 26.w,
                                  ),
                                ),
                        ),
                        Text(
                          '$likeCount',
                          style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!isReply) {
                              ref.watch(commentHeaderProvider.notifier).addReplyCommentHeader(name, commentIdx);
                              ref.watch(commentHeaderProvider.notifier).setHasInput(true);
                            } else {
                              ref.watch(commentHeaderProvider.notifier).addReplyCommentHeader(name, parentIdx);
                            }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 12.0.w, top: 2.h, right: 2.w),
                                child: Image.asset(
                                  'assets/image/feed/icon/small_size/icon_comment_comment.png',
                                  height: 24.w,
                                ),
                              ),
                              Text(
                                '답글쓰기',
                                style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isLastDisPlayChild)
                      GestureDetector(
                        onTap: () {
                          if (onMoreChildComment != null) {
                            onMoreChildComment!(pageNumber);
                          }
                        },
                        child: Center(
                          child: Text(
                            "답글 10개씩 더 보기",
                            style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
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
