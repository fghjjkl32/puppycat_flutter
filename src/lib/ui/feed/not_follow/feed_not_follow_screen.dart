import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';

class FeedNotFollowScreen extends ConsumerWidget {
  final String nick;
  final String memberUuid;

  const FeedNotFollowScreen({
    super.key,
    required this.nick,
    required this.memberUuid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              "$nick님의\n팔로우 공개 피드예요!",
              style: kTitle18BoldStyle.copyWith(color: kPreviousTextTitleColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "팔로우하면 피드를 볼 수 있어요.",
              style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPreviousPrimaryLightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      // 팔로우 api 연결
                      await ref.read(followStateProvider.notifier).postFollow(followUuid: memberUuid);

                      await ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: memberUuid, followState: true, isActionButton: false);

                      ref.read(followUserStateProvider.notifier).setInitFollowState(memberUuid, true);

                      await Future.delayed(const Duration(milliseconds: 300));

                      final feedDetailState = ref.read(feedDetailParameterProvider.notifier).state;

                      await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(feedDetailState["contentType"], int.parse(feedDetailState["contentIdx"])).then((value) async {
                        if (value == null) {
                          return;
                        }

                        context.pushReplacement('/feed/detail', extra: feedDetailState);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        '팔로우하고 피드보기',
                        style: kBody16MediumStyle.copyWith(
                          color: kPreviousPrimaryColor,
                        ),
                      ),
                    ),
                  ).throttle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
