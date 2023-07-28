import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/comment_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
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
    this.replies,
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
  final ChildCommentData? replies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // List<InlineSpan> replaceMentionsWithNicknamesInContent(String content,
    //     List<FeedMentionListData> mentionList, BuildContext context) {
    //   List<InlineSpan> spans = [];
    //
    //   String remainingContent = content;
    //
    //   for (var mention in mentionList) {
    //     String nick = mention.nick ?? '';
    //     String uuid = mention.uuid ?? '';
    //     int memberIdx = mention.memberIdx ?? 0;
    //
    //     String pattern = '[@[' + uuid + ']]';
    //     int startIdx = remainingContent.indexOf(pattern);
    //
    //     if (startIdx != -1) {
    //       if (startIdx > 0) {
    //         spans.add(TextSpan(text: remainingContent.substring(0, startIdx)));
    //       }
    //
    //       spans.add(WidgetSpan(
    //         child: GestureDetector(
    //           onTap: () {
    //             context.push(
    //                 "/home/myPage/followList/$memberIdx/userPage/$nick/$memberIdx");
    //           },
    //           child: Text('@' + nick,
    //               style: kBody13RegularStyle.copyWith(color: kSecondaryColor)),
    //         ),
    //       ));
    //
    //       remainingContent =
    //           remainingContent.substring(startIdx + pattern.length);
    //     }
    //   }
    //
    //   // Process hashtags
    //   String remainingContentAfterMentions = remainingContent;
    //   while (true) {
    //     RegExp exp = new RegExp(r"\[#\[(.*?)\]\]");
    //     var match = exp.firstMatch(remainingContentAfterMentions);
    //
    //     if (match == null) break;
    //
    //     String beforeHashtag =
    //         remainingContentAfterMentions.substring(0, match.start);
    //     String hashtag = match.group(1) ?? '';
    //
    //     spans.add(TextSpan(text: beforeHashtag));
    //
    //     spans.add(WidgetSpan(
    //       child: GestureDetector(
    //         onTap: () {
    //           print(hashtag);
    //         },
    //         child: Text('#' + hashtag,
    //             style: kBody13RegularStyle.copyWith(color: kSecondaryColor)),
    //       ),
    //     ));
    //
    //     remainingContentAfterMentions =
    //         remainingContentAfterMentions.substring(match.end);
    //   }
    //
    //   // Add the remaining content after the last pattern
    //   spans.add(TextSpan(text: remainingContentAfterMentions));
    //
    //   return spans;
    // }

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
              profileImage == null
                  ? WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Center(
                        child: Image.asset(
                          'assets/image/feed/icon/large_size/icon_taguser.png',
                          height: 30.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/feed/image/squircle.svg',
                        height: 30.h,
                      ),
                    )
                  : WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Center(
                        child: Image.asset(
                          profileImage!,
                          height: 30.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/feed/image/squircle.svg',
                        height: 30.h,
                        fit: BoxFit.fill,
                      ),
                    ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bubble(
                      isComment: true,
                      radius: Radius.circular(10.w),
                      elevation: 0,
                      alignment: Alignment.topLeft,
                      nip: BubbleNip.leftTop,
                      nipOffset: 15.h,
                      color: kNeutralColor200,
                      padding: BubbleEdges.only(
                          left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
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
                                    style: kBody12SemiBoldStyle.copyWith(
                                        color: kTextSubTitleColor),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    displayedAt(time),
                                    style: kBody11RegularStyle.copyWith(
                                        color: kTextBodyColor),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showCustomModalBottomSheet(
                                        context: context,
                                        widget: Column(
                                          children: [
                                            BottomSheetButtonItem(
                                              iconImage:
                                                  'assets/image/feed/icon/small_size/icon_user_de.png',
                                              title: '차단하기',
                                              titleStyle:
                                                  kButton14BoldStyle.copyWith(
                                                      color:
                                                          kTextSubTitleColor),
                                              onTap: () {},
                                            ),
                                            BottomSheetButtonItem(
                                              iconImage:
                                                  'assets/image/feed/icon/small_size/icon_report.png',
                                              title: '신고하기',
                                              titleStyle:
                                                  kButton14BoldStyle.copyWith(
                                                      color:
                                                          kTextSubTitleColor),
                                              onTap: () {
                                                context.pop();
                                                context
                                                    .push("/home/report/true");
                                              },
                                            ),
                                            BottomSheetButtonItem(
                                              iconImage:
                                                  'assets/image/feed/icon/small_size/icon_report.png',
                                              title: '삭제하기',
                                              titleStyle: kButton14BoldStyle
                                                  .copyWith(color: kBadgeColor),
                                              onTap: () async {
                                                final result = await ref
                                                    .watch(commentStateProvider
                                                        .notifier)
                                                    .deleteContents(
                                                      memberIdx: ref
                                                          .read(
                                                              userModelProvider)!
                                                          .idx,
                                                      contentsIdx: contentIdx,
                                                      commentIdx: commentIdx,
                                                    );

                                                if (result.result) {
                                                  context.pop();
                                                }
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
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          //   child: Container(
                          //     alignment: Alignment.centerLeft,
                          //     child: RichText(
                          //       text: TextSpan(
                          //         children:
                          //             replaceMentionsWithNicknamesInContent(
                          //                 feedData.contents!,
                          //                 feedData.mentionList!,
                          //                 context),
                          //         style: kBody13RegularStyle.copyWith(
                          //             color: kTextTitleColor),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          LinkifyText(
                            comment,
                            textStyle: kBody11RegularStyle.copyWith(
                                color: kTextSubTitleColor),
                            linkStyle: kBody11RegularStyle.copyWith(
                                color: kSecondaryColor),
                            linkTypes: const [
                              LinkType.hashTag,
                              LinkType.userTag
                            ],
                            onTap: (link) {},
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 12.0.w, top: 2.h, right: 2.w),
                          child: isLike
                              ? InkWell(
                                  onTap: () {
                                    ref
                                        .watch(commentStateProvider.notifier)
                                        .deleteCommentLike(
                                          commentIdx: commentIdx,
                                          memberIdx:
                                              ref.read(userModelProvider)!.idx,
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
                                    ref
                                        .watch(commentStateProvider.notifier)
                                        .postCommentLike(
                                          commentIdx: commentIdx,
                                          memberIdx:
                                              ref.read(userModelProvider)!.idx,
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
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            replies != null
                                ? ref
                                    .watch(commentHeaderProvider.notifier)
                                    .addCommentHeader(name, commentIdx)
                                : ref
                                    .watch(commentHeaderProvider.notifier)
                                    .addCommentHeader(name, parentIdx);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 12.0.w, top: 2.h, right: 2.w),
                                child: Image.asset(
                                  'assets/image/feed/icon/small_size/icon_comment_comment.png',
                                  height: 24.w,
                                ),
                              ),
                              Text(
                                '답글쓰기',
                                style: kBody11SemiBoldStyle.copyWith(
                                    color: kTextBodyColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (replies != null)
            Column(
              children: [
                SizedBox(
                  height: replies!.list.length > 2
                      ? 100.h * 2
                      : 100.h * replies!.list.length.toDouble(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          replies!.list.length > 2 ? 2 : replies!.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CommentDetailItemWidget(
                          parentIdx: replies!.list[index].parentIdx,
                          commentIdx: replies!.list[index].idx,
                          profileImage: replies!.list[index].url ??
                              'assets/image/feed/image/sample_image1.png',
                          name: replies!.list[index].nick,
                          comment: replies!.list[index].contents,
                          isSpecialUser: replies!.list[index].isBadge == 1,
                          time: DateTime.parse(replies!.list[index].regDate),
                          isReply: true,
                          likeCount: replies!.list[index].likeCnt,
                          replies: replies!.list[index].childCommentData,
                          contentIdx: replies!.list[0].contentsIdx,
                          isLike: replies!.list[index].likeState == 1,
                        );
                      },
                    ),
                  ),
                ),
                if (replies!.list.length > 2)
                  SizedBox(
                    height: replies!.list.length > 2
                        ? 10.h * 2
                        : 10.h * replies!.list.length.toDouble(),
                    child: Text(
                      "답글 ${replies!.list.length - 2}개 더 보기",
                      style:
                          kBody12RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
