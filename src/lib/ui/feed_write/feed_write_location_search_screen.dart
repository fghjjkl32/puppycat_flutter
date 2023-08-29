import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/post_feed/location_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/location_item.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_search_provider.dart';

class FeedWriteLocationSearchScreen extends ConsumerWidget {
  const FeedWriteLocationSearchScreen({
    Key? key,
  }) : super(key: key);

  static final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('위치 추가'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Puppycat_social.icon_close_large,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: FormBuilderTextField(
                        name: 'search',
                        initialValue:
                            ref.watch(feedWriteLocationSearchProvider),
                        // controller: locationSearchController,
                        onChanged: (value) => ref
                            .read(feedWriteLocationSearchProvider.notifier)
                            .onTextChanged(value!),
                        style: kBody13RegularStyle.copyWith(
                            color: kTextSubTitleColor),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kNeutralColor200,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100.0),
                            gapPadding: 10.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100.0),
                            gapPadding: 10.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(100.0),
                            gapPadding: 10.0,
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          suffixIcon: ref
                                  .watch(feedWriteLocationSearchProvider)
                                  .isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Icon(
                                    Puppycat_social.icon_search_medium,
                                    color: kNeutralColor600,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    ref
                                        .watch(feedWriteLocationSearchProvider
                                            .notifier)
                                        .onTextChanged('');
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Icon(
                                      Puppycat_social.icon_close_large,
                                      color: kNeutralColor600,
                                    ),
                                  ),
                                ),
                          hintText: "장소를 입력해 주세요.",
                          hintStyle: kBody11RegularStyle.copyWith(
                              color: kNeutralColor500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    ref.watch(feedWriteLocationSearchProvider).isEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "최근 검색어",
                                      style: kTitle16ExtraBoldStyle.copyWith(
                                          color: kTextTitleColor),
                                    ),
                                    Text(
                                      "전체 삭제",
                                      style: kBody11SemiBoldStyle.copyWith(
                                          color: kTextBodyColor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                            ],
                          )
                        : Container(),
                    Expanded(
                      child: ref
                              .watch(feedWriteLocationSearchProvider.notifier)
                              .searchResult
                              .isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/image/feed_write/image/corgi-2 1.png',
                                    height: 68.h,
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Text(
                                    "장소를 찾을 수 없습니다.",
                                    style: kBody12RegularStyle.copyWith(
                                        color: kTextBodyColor),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: ref
                                  .watch(
                                      feedWriteLocationSearchProvider.notifier)
                                  .searchResult
                                  .length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(ref
                                        .watch(feedWriteLocationSearchProvider
                                            .notifier)
                                        .searchResult[index]
                                        .name);
                                  },
                                  child: LocationUserItemWidget(
                                    locationItem: LocationItem(
                                      name: ref
                                          .watch(feedWriteLocationSearchProvider
                                              .notifier)
                                          .searchResult[index]
                                          .name,
                                      subName: ref
                                          .watch(feedWriteLocationSearchProvider
                                              .notifier)
                                          .searchResult[index]
                                          .subName,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
