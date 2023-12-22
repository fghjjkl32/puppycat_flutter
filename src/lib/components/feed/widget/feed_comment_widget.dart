import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';

class FeedCommentWidget extends ConsumerWidget {
  const FeedCommentWidget({
    required this.memberUuid,
    required this.profileImage,
    required this.name,
    required this.comment,
    required this.isSpecialUser,
    required this.mentionListData,
    required this.contentIdx,
    required this.oldMemberUuid,
    Key? key,
  }) : super(key: key);

  final String memberUuid;
  final String? profileImage;
  final String name;
  final String comment;
  final bool isSpecialUser;
  final List<MentionListData> mentionListData;
  final int contentIdx;
  final String oldMemberUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myInfo = ref.read(myInfoStateProvider);

    return GestureDetector(
      onTap: () {
        //TODO
        //Route 다시
        context.push("/home/commentDetail/$contentIdx/$oldMemberUuid");
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                myInfo.uuid == memberUuid
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPageMainScreen(
                            oldMemberUuid: oldMemberUuid,
                          ),
                        ),
                      )
                    //TODO
                    //Route 다시
                    : context.push("/home/myPage/followList/$memberUuid/userPage/$name/$memberUuid/$oldMemberUuid");
              },
              child: getProfileAvatar(profileImage ?? "", 30, 30),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Bubble(
                isComment: true,
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
                      children: [
                        isSpecialUser
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
                        Text(
                          name,
                          style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
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
                            comment,
                            mentionListData,
                            context,
                            kBody11RegularStyle.copyWith(color: kPreviousSecondaryColor),
                            ref,
                            oldMemberUuid,
                          ),
                          style: kBody11RegularStyle.copyWith(color: kPreviousTextTitleColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
