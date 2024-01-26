import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/insta_assets_crop_controller.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_button_selected_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_content_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_cropped_files_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_information_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/component/post_feed_view.dart';

class FeedWriteScreen extends ConsumerWidget {
  const FeedWriteScreen({super.key, required this.cropStream});

  final Stream<InstaAssetsExportDetails> cropStream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultOnWillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    Text(
                      "잠깐! 지금 나가면\n작성한 내용은 모두 사라져요.",
                      style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              confirmTap: () {
                context.pop();
              },
              cancelTap: () {
                context.pop();
                context.pop();

                ref.read(feedWriteProvider.notifier).resetTag();
                ref.watch(feedWriteLocationInformationProvider.notifier).state = "";
                ref.watch(feedWriteContentProvider.notifier).state = TextEditingController(text: "");
                ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
              },
              confirmWidget: Text(
                "이어서 하기",
                style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
              ),
              cancelWidget: Text(
                "나가기",
                style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
              ),
            );
          },
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('새로운 피드'),
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          Text(
                            "잠깐! 지금 나가면\n작성한 내용은 모두 사라져요.",
                            style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    confirmTap: () {
                      context.pop();
                    },
                    cancelTap: () {
                      context.pop();
                      context.pop();

                      ref.read(feedWriteProvider.notifier).resetTag();
                      ref.watch(feedWriteContentProvider.notifier).state = TextEditingController(text: "");
                      ref.watch(feedWriteLocationInformationProvider.notifier).state = "";
                      ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
                    },
                    confirmWidget: Text(
                      "이어서 하기",
                      style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
                    ),
                    cancelWidget: Text(
                      "나가기",
                      style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                '등록',
                style: kButton12BoldStyle.copyWith(color: kPreviousPrimaryColor),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/lottie/icon_loading.json',
                              fit: BoxFit.fill,
                              width: 80,
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                final result = await ref.read(feedWriteProvider.notifier).postFeed(
                      files: ref.read(feedWriteCroppedFilesProvider),
                      isView: ref.read(feedWriteButtonSelectedProvider),
                      location: ref.read(feedWriteLocationInformationProvider.notifier).state,
                      contents: ref.read(feedWriteContentProvider.notifier).state.text,
                      feedState: ref.read(feedWriteProvider),
                    );
                // context.pop();

                if (result.result) {
                  ref.read(feedWriteProvider.notifier).resetTag();
                  ref.watch(feedWriteLocationInformationProvider.notifier).state = "";
                  ref.watch(feedWriteContentProvider.notifier).state = TextEditingController(text: "");
                  ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
                  context.pushReplacement("/home");
                } else {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Column(
                              children: [
                                Text(
                                  "피드 올리는데 문제가 생겼어요.",
                                  style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "올리기를 다시 시도해 주세요.",
                                  style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
                            style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
                          ));
                    },
                  );
                }
              },
            ),
          ],
        ),
        body: StreamBuilder<InstaAssetsExportDetails>(
          stream: cropStream,
          builder: (context, snapshot) => PostFeedView(
            croppedFiles: snapshot.data?.croppedFiles ?? [],
            progress: snapshot.data?.progress,
          ),
        ),
      ),
    );
  }
}
