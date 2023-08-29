import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/insta_assets_crop_controller.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_button_selected_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_content_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_search_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/componenet/edit_feed_view.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/componenet/post_feed_view.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_cropped_files_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_information_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';

class FeedEditScreen extends ConsumerWidget {
  const FeedEditScreen(
      {super.key, required this.feedData, required this.contentIdx});

  final FeedData feedData;
  final int contentIdx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0.h),
                child: Column(
                  children: [
                    Text(
                      "이전으로 돌아가시겠어요?",
                      style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      "지금 돌아가시면\n입력한 내용이 모두 삭제됩니다.",
                      style:
                          kBody12RegularStyle.copyWith(color: kTextBodyColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              confirmTap: () {
                context.pop();
                context.pop();

                ref.read(feedWriteProvider.notifier).resetTag();
                ref.watch(feedWriteLocationInformationProvider.notifier).state =
                    "";
                ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
              },
              cancelTap: () {
                context.pop();
              },
              confirmWidget: Text(
                "삭제",
                style: kButton14MediumStyle.copyWith(color: kBadgeColor),
              ),
            );
          },
        );
        return false;
      },
      child: WillPopScope(
        onWillPop: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0.h),
                  child: Column(
                    children: [
                      Text(
                        "이전으로 돌아가시겠어요?",
                        style:
                            kBody16BoldStyle.copyWith(color: kTextTitleColor),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "지금 돌아가시면\n입력한 내용이 모두 삭제됩니다.",
                        style:
                            kBody12RegularStyle.copyWith(color: kTextBodyColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                confirmTap: () {
                  context.pop();
                  context.pop();

                  ref.read(feedWriteProvider.notifier).resetTag();
                  ref
                      .watch(feedWriteLocationInformationProvider.notifier)
                      .state = "";
                  ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
                },
                cancelTap: () {
                  context.pop();
                },
                confirmWidget: Text(
                  "삭제",
                  style: kButton14MediumStyle.copyWith(color: kBadgeColor),
                ),
              );
            },
          );
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('게시물 수정'),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();

                ref.read(feedWriteProvider.notifier).resetTag();
                ref.watch(feedWriteLocationInformationProvider.notifier).state =
                    "";
                ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
              },
              icon: const Icon(
                Puppycat_social.icon_close_large,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  '등록',
                  style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                          ),
                          child: const SpinKitCircle(
                            size: 100,
                            color: kNeutralColor500,
                          ),
                        ),
                      );
                    },
                  );

                  final result = await ref
                      .watch(feedWriteProvider.notifier)
                      .putFeed(
                        memberIdx: ref.watch(userModelProvider)!.idx,
                        isView: ref.watch(feedWriteButtonSelectedProvider),
                        location: ref
                            .watch(
                                feedWriteLocationInformationProvider.notifier)
                            .state,
                        contents: ref
                            .watch(feedEditContentProvider.notifier)
                            .state
                            .text,
                        feedState: ref.watch(feedWriteProvider),
                        contentIdx: contentIdx,
                        initialTagList: ref
                            .read(feedWriteProvider.notifier)
                            .state
                            .initialTagList,
                      );

                  context.pop();

                  if (result.result) {
                    ref.read(feedWriteProvider.notifier).resetTag();
                    ref
                        .watch(feedWriteLocationInformationProvider.notifier)
                        .state = "";
                    ref
                        .watch(feedWriteCroppedFilesProvider.notifier)
                        .removeAll();
                    context.pushReplacement("/home");
                  } else {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            content: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0.h),
                              child: Column(
                                children: [
                                  Text(
                                    "게시물을 등록할 수 없습니다.",
                                    style: kBody16BoldStyle.copyWith(
                                        color: kTextTitleColor),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    "죄송합니다.\n게시물 등록 중 오류가 발생하였습니다.\n다시 시도해 주세요.",
                                    style: kBody12RegularStyle.copyWith(
                                        color: kTextBodyColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            confirmTap: () {
                              context.pop();
                            },
                            confirmWidget: Text(
                              "확인",
                              style: kButton14MediumStyle.copyWith(
                                  color: kPrimaryColor),
                            ));
                      },
                    );
                  }
                },
              ),
            ],
          ),
          body: EditFeedView(
            feedData: feedData,
          ),
        ),
      ),
    );
  }
}
