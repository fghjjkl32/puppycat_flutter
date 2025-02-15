import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/location_item.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_search_provider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/component/location_item_widget.dart';

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
        title: Text('피드.위치 추가'.tr()),
        leading: IconButton(
          onPressed: () {
            context.pop();
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: FormBuilderTextField(
                        name: 'search',
                        initialValue: ref.watch(feedWriteLocationSearchProvider),
                        // controller: locationSearchController,
                        onChanged: (value) => ref.read(feedWriteLocationSearchProvider.notifier).onTextChanged(value!),
                        style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kPreviousNeutralColor200,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                          suffixIcon: ref.watch(feedWriteLocationSearchProvider).isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Icon(
                                    Puppycat_social.icon_search_medium,
                                    color: kPreviousNeutralColor600,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    ref.watch(feedWriteLocationSearchProvider.notifier).onTextChanged('');
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Icon(
                                      Puppycat_social.icon_close_large,
                                      color: kPreviousNeutralColor600,
                                    ),
                                  ),
                                ),
                          hintText: "피드.장소를 입력해 주세요".tr(),
                          hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ref.watch(feedWriteLocationSearchProvider).isEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "피드.최근 검색어".tr(),
                                      style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                                    ),
                                    Text(
                                      "피드.전체 삭제".tr(),
                                      style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          )
                        : Container(),
                    Expanded(
                      child: ref.watch(feedWriteLocationSearchProvider.notifier).searchResult.isEmpty
                          ? Container(
                              color: kPreviousNeutralColor100,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/image/character/character_08_user_notfound_100.png',
                                      width: 88,
                                      height: 88,
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      '피드.장소를 찾을 수 없어요'.tr(),
                                      textAlign: TextAlign.center,
                                      style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: ref.watch(feedWriteLocationSearchProvider.notifier).searchResult.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(ref.watch(feedWriteLocationSearchProvider.notifier).searchResult[index].name);
                                  },
                                  child: LocationUserItemWidget(
                                    locationItem: LocationItem(
                                      name: ref.watch(feedWriteLocationSearchProvider.notifier).searchResult[index].name,
                                      subName: ref.watch(feedWriteLocationSearchProvider.notifier).searchResult[index].subName,
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
