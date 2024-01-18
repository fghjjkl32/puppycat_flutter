import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/models/user_list/popular_user_list/popular_user_list_data.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/feed_follow_card_widget.dart';

class FeedFollowWidget extends StatelessWidget {
  const FeedFollowWidget({
    Key? key,
    required this.popularUserListData,
    required this.oldMemberUuid,
  }) : super(key: key);

  final List<PopularUserListData> popularUserListData;
  final String oldMemberUuid;

  @override
  Widget build(BuildContext context) {
    return popularUserListData.isEmpty
        ? Container()
        : Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 222,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: popularUserListData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return FeedFollowCardWidget(
                      imageList: popularUserListData[index].contentsList!,
                      profileImage: popularUserListData[index].profileImgUrl,
                      userName: popularUserListData[index].nick!,
                      followCount: popularUserListData[index].followerCnt!,
                      isSpecialUser: popularUserListData[index].isBadge! == 1,
                      memberUuid: popularUserListData[index].uuid!,
                      oldMemberUuid: oldMemberUuid,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          );
  }
}
