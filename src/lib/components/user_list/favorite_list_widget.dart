import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';

class FavoriteListWidget extends StatelessWidget {
  const FavoriteListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // FavoriteItemWidget(
        //   profileImage: 'assets/image/feed/image/sample_image1.png',
        //   userName: '말티푸달콩',
        //   content: '사용자가 설정한 소개글',
        //   isSpecialUser: false,
        //   isFollow: true,
        //   followerIdx: 95,
        // ),
        // FavoriteItemWidget(
        //   profileImage: null,
        //   userName: '테테_te',
        //   content: '사용자가 설정한 소개글',
        //   isSpecialUser: true,
        //   isFollow: false,
        //   followerIdx: 95,
        // ),
        // FavoriteItemWidget(
        //   profileImage: 'assets/image/feed/image/sample_image1.png',
        //   userName: '로로님',
        //   content: '사용자가 설정한 소개글',
        //   isSpecialUser: true,
        //   isFollow: false,
        //   followerIdx: 95,
        // ),
        // FavoriteItemWidget(
        //   profileImage: null,
        //   userName: '아지다멍',
        //   content: '사용자가 설정한 소개글',
        //   isSpecialUser: true,
        //   isFollow: true,
        //   followerIdx: 95,
        // ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
      ],
    );
  }
}
