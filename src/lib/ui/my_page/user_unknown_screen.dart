import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class UserUnknownScreen extends StatelessWidget {
  const UserUnknownScreen({super.key});

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
            Center(
              child: Image.asset(
                'assets/image/character/character_08_user_notfound_100.png',
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "유저를 찾을 수 없습니다.",
              style: kTitle14BoldStyle.copyWith(color: kTextTitleColor),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "클릭하신 링크가 잘못되었거나\n페이지가 삭제되었습니다.",
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
                      context.pushReplacement("/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        '홈으로 이동',
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
