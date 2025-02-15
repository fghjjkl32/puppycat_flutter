import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_button_selected_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_content_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_cropped_files_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_information_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_edit/component/edit_feed_view.dart';

class FeedEditScreen extends ConsumerWidget {
  const FeedEditScreen({super.key, required this.feedData, required this.contentIdx});

  final FeedData feedData;
  final int contentIdx;

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
                      "피드.피드 나가기 경고".tr(),
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
                ref.watch(feedEditContentProvider.notifier).state = TextEditingController(text: "");
                ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
                ref.read(hashtagListProvider.notifier).state = [];
                ref.read(mentionListProvider.notifier).state = [];
              },
              confirmWidget: Text(
                "피드.이어서 하기".tr(),
                style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
              ),
              cancelWidget: Text(
                "피드.나가기".tr(),
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
          title: Text(
            '피드.피드 수정'.tr(),
          ),
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
                            "피드.피드 나가기 경고".tr(),
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
                      ref.watch(feedEditContentProvider.notifier).state = TextEditingController(text: "");
                      ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
                      ref.read(hashtagListProvider.notifier).state = [];
                      ref.read(mentionListProvider.notifier).state = [];
                    },
                    confirmWidget: Text(
                      "피드.이어서 하기".tr(),
                      style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
                    ),
                    cancelWidget: Text(
                      "피드.나가기".tr(),
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
                '피드.등록'.tr(),
                style: kTitle14BoldStyle.copyWith(color: kPreviousPrimaryColor),
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

                String tempContents;

                tempContents = await processHashtagEditedText(
                  ref.watch(feedEditContentProvider.notifier).state.text,
                  ref.read(hashtagListProvider),
                );

                tempContents = await processMentionEditedText(
                  tempContents,
                  ref.read(mentionListProvider),
                );

                final result = await ref.watch(feedWriteProvider.notifier).putFeed(
                      isView: ref.watch(feedWriteButtonSelectedProvider),
                      location: ref.watch(feedWriteLocationInformationProvider.notifier).state,
                      contents: tempContents,
                      feedState: ref.watch(feedWriteProvider),
                      contentIdx: contentIdx,
                      initialTagList: ref.read(feedWriteProvider.notifier).state.initialTagList,
                    );

                context.pop();

                if (result.result) {
                  if (ref.watch(feedWriteButtonSelectedProvider) == 0) {
                    ref.read(feedListStateProvider.notifier).feedRefresh(
                          contentIdx,
                          "postKeepContents",
                        );

                    context.pop();
                  } else {
                    await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("myContent", contentIdx, isUpdateState: false).then((value) {
                      if (value == null) {
                        return;
                      }

                      ref.read(feedListStateProvider.notifier).editFeedRefresh(
                            editData: value,
                            contentIdx: contentIdx,
                          );

                      ref.read(feedWriteProvider.notifier).resetTag();
                      ref.watch(feedWriteLocationInformationProvider.notifier).state = "";
                      ref.watch(feedEditContentProvider.notifier).state = TextEditingController(text: "");
                      ref.watch(feedWriteCroppedFilesProvider.notifier).removeAll();
                      ref.read(hashtagListProvider.notifier).state = [];
                      ref.read(mentionListProvider.notifier).state = [];

                      context.pop();
                    });
                  }
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
                                  "피드.피드 올리는데 문제가 생겼어요".tr(),
                                  style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "피드.올리기를 다시 시도해 주세요".tr(),
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
                            "피드.확인".tr(),
                            style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
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
    );
  }
}
