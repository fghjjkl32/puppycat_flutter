import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_detail_state_provider.dart';

class FeedBottomIconWidget extends ConsumerWidget {
  const FeedBottomIconWidget({
    super.key,
    required this.contentIdx,
    required this.memberIdx,
    required this.likeCount,
    required this.commentCount,
    required this.isLike,
    required this.isSave,
    required this.contentType,
    required this.oldMemberIdx,
  });

  final int contentIdx;
  final int? memberIdx;
  final int likeCount;
  final int commentCount;
  final bool isLike;
  final bool isSave;
  final String contentType;
  final int oldMemberIdx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              isLike
                  ? GestureDetector(
                      onTap: () {
                        ref.watch(feedDetailStateProvider.notifier).deleteLike(
                              loginMemberIdx: ref.read(userModelProvider)!.idx,
                              memberIdx: memberIdx,
                              contentIdx: contentIdx,
                              contentType: contentType,
                            );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Puppycat_social.icon_like_ac,
                            color: kPrimaryColor,
                            size: 32,
                          ),
                          Text(
                            '$likeCount',
                            style: kBody12RegularStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ref.read(userModelProvider) == null
                            ? context.pushReplacement("/loginScreen")
                            : ref
                                .watch(feedDetailStateProvider.notifier)
                                .postLike(
                                  loginMemberIdx:
                                      ref.read(userModelProvider)!.idx,
                                  memberIdx: memberIdx,
                                  contentIdx: contentIdx,
                                  contentType: contentType,
                                );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Puppycat_social.icon_like_de,
                            color: kTextBodyColor,
                            size: 32,
                          ),
                          Text(
                            '$likeCount',
                            style: kBody12RegularStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                        ],
                      ),
                    ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  context.push("/home/commentDetail/$contentIdx/$oldMemberIdx");
                },
                child: Row(
                  children: [
                    const Icon(
                      Puppycat_social.icon_comment,
                      color: kTextBodyColor,
                      size: 32,
                    ),
                    Text(
                      '$commentCount',
                      style:
                          kBody12RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isSave
              ? GestureDetector(
                  onTap: () {
                    ref.read(userModelProvider) == null
                        ? context.pushReplacement("/loginScreen")
                        : ref
                            .watch(feedDetailStateProvider.notifier)
                            .deleteSave(
                              loginMemberIdx: ref.read(userModelProvider)!.idx,
                              memberIdx: memberIdx,
                              contentIdx: contentIdx,
                              contentType: contentType,
                            );
                  },
                  child: const Icon(
                    Puppycat_social.icon_bookmark,
                    size: 32,
                    color: kPrimaryColor,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    ref.read(userModelProvider) == null
                        ? context.pushReplacement("/loginScreen")
                        : ref.watch(feedDetailStateProvider.notifier).postSave(
                              loginMemberIdx: ref.read(userModelProvider)!.idx,
                              memberIdx: memberIdx,
                              contentIdx: contentIdx,
                              contentType: contentType,
                            );
                  },
                  child: const Icon(
                    Puppycat_social.icon_bookmark,
                    size: 32,
                    color: kTextBodyColor,
                  ),
                ),
        ],
      ),
    );
  }
}
