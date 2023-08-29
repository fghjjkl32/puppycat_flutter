import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_data.dart';

import 'widget/feed_follow_card_widget.dart';

class FeedFollowWidget extends StatelessWidget {
  const FeedFollowWidget({
    Key? key,
    required this.popularUserListData,
    required this.oldMemberIdx,
  }) : super(key: key);

  final List<PopularUserListData> popularUserListData;
  final int oldMemberIdx;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.push("/home/myPage/detail/아지다멍/게시물");
      },
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 205.h,
            child: ListView.builder(
              itemCount: popularUserListData.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return FeedFollowCardWidget(
                  imageList: popularUserListData[index].contentsList!,
                  profileImage: popularUserListData[index].profileImgUrl,
                  userName: popularUserListData[index].nick!,
                  followCount: popularUserListData[index].followerCnt!,
                  isSpecialUser: popularUserListData[index].isBadge! == 1,
                  memberIdx: popularUserListData[index].memberIdx!,
                  oldMemberIdx: oldMemberIdx,
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
