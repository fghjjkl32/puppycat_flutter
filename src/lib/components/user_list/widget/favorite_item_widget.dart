import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/content_like_user_list/content_like_user_list_state_provider.dart';
import 'package:widget_mask/widget_mask.dart';

class FavoriteItemWidget extends ConsumerStatefulWidget {
  const FavoriteItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.isFollow,
    required this.followerIdx,
    required this.contentsIdx,
    required this.oldMemberIdx,
    this.contentType,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final bool isFollow;
  final int followerIdx;
  final int contentsIdx;
  final String? contentType;
  final int oldMemberIdx;
  @override
  FavoriteItemWidgetState createState() => FavoriteItemWidgetState();
}

class FavoriteItemWidgetState extends ConsumerState<FavoriteItemWidget> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();

    isFollowing = widget.isFollow;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ref.read(userInfoProvider).userModel!.idx == widget.followerIdx
            ? context.push("/home/myPage")
            : context.push("/home/myPage/followList/${widget.followerIdx}/userPage/${widget.userName}/${widget.followerIdx}/${widget.oldMemberIdx}");
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 8.h, top: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                  ),
                  child: getProfileAvatar(widget.profileImage ?? "", 32.w, 32.h),
                ),
                Column(
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
                        Text(
                          widget.userName,
                          style: kBody13BoldStyle.copyWith(color: kTextTitleColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      widget.content,
                      style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ],
            ),
            ref.read(userInfoProvider).userModel?.idx == widget.followerIdx
                ? Container()
                : !isFollowing
                    ? GestureDetector(
                        onTap: () async {
                          if (ref.read(userInfoProvider).userModel == null) {
                            context.pushReplacement("/loginScreen");
                          } else {
                            setState(() {
                              isFollowing = true;
                            });
                            if (widget.contentType == null) {
                              await ref.watch(contentLikeUserListStateProvider.notifier).postFollow(
                                    memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                    followIdx: widget.followerIdx,
                                    contentsIdx: widget.contentsIdx,
                                  );
                            } else {
                              ref.watch(feedListStateProvider.notifier).postFollow(
                                    memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                    followIdx: widget.followerIdx,
                                    contentsIdx: widget.contentsIdx,
                                    contentType: widget.contentType,
                                  );
                            }
                          }
                        },
                        child: Container(
                          width: 56.w,
                          height: 32.h,
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "팔로우",
                              style: kButton12BoldStyle.copyWith(color: kNeutralColor100),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          setState(() {
                            isFollowing = false;
                          });

                          if (widget.contentType == null) {
                            await ref.watch(contentLikeUserListStateProvider.notifier).deleteFollow(
                                  memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                  followIdx: widget.followerIdx,
                                  contentsIdx: widget.contentsIdx,
                                );
                          } else {
                            ref.watch(feedListStateProvider.notifier).deleteFollow(
                                  memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                  followIdx: widget.followerIdx,
                                  contentsIdx: widget.contentsIdx,
                                  contentType: widget.contentType,
                                );
                          }
                        },
                        child: Container(
                          width: 56.w,
                          height: 32.h,
                          decoration: const BoxDecoration(
                            color: kNeutralColor300,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "팔로잉",
                              style: kButton12BoldStyle.copyWith(color: kTextBodyColor),
                            ),
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
