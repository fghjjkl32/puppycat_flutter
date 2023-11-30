import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedNotFollowScreen extends StatelessWidget {
  final String name;
  final int memberidx;

  const FeedNotFollowScreen({
    super.key,
    required this.name,
    required this.memberidx,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/image/character/character_02_follower_view.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "$name님의\n팔로우 공개 피드예요!",
              style: kTitle14BoldStyle.copyWith(color: kTextTitleColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "팔로우하면 피드를 볼 수 있어요.",
              style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20.0.w,
                  right: 20.0.w,
                  bottom: 20.0.h,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryLightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        '팔로우하고 피드보기',
                        style: kBody14BoldStyle.copyWith(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
