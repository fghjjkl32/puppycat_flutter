import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_best_post_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';

class FeedBestPostWidget extends ConsumerWidget {
  const FeedBestPostWidget({Key? key, required this.feedData}) : super(key: key);

  final List<FeedData> feedData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return feedData.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 10, bottom: 12),
                child: Text(
                  "인기 급상승",
                  style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 112,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ListView.builder(
                    itemCount: feedData.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> extraMap = {
                            'firstTitle': 'null',
                            'secondTitle': '인기 급상승',
                            'memberUuid': feedData[index].memberInfo!.uuid,
                            'contentIdx': '${feedData[index].idx}',
                            'contentType': 'popularWeekContent',
                          };
                          await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('popularWeekContent', feedData[index].idx).then((value) {
                            if (value == null) {
                              return;
                            }
                            // context.push("/home/myPage/detail/null/인기 급상승/${feedData[index].memberInfoList![0].memberIdx}/${feedData[index].idx}/popularWeekContent");
                            context.push('/home/myPage/detail', extra: extraMap);
                          });
                        },
                        child: FeedBestPostItemWidget(
                          imageCount: feedData[index].imgList!.length,
                          image: feedData[index].imgList![0].url!,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Divider(),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          );
  }
}
