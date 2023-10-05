import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/my_pet_list/my_pet_list_state_provider.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

class MyPetListScreen extends ConsumerStatefulWidget {
  const MyPetListScreen({Key? key}) : super(key: key);

  @override
  MyPetListScreenState createState() => MyPetListScreenState();
}

class MyPetListScreenState extends ConsumerState<MyPetListScreen> {
  late final PagingController<int, MyPetItemModel> _myPetListPagingController = ref.read(myPetListStateProvider);

  @override
  void initState() {
    _myPetListPagingController.refresh();
    ref.read(myPetListStateProvider.notifier).memberIdx = ref.read(userInfoProvider).userModel?.idx;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "우리집 아이들",
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
      body: CustomScrollView(
        slivers: <Widget>[
          PagedSliverList<int, MyPetItemModel>(
            shrinkWrapFirstPageIndicators: true,
            pagingController: _myPetListPagingController,
            builderDelegate: PagedChildBuilderDelegate<MyPetItemModel>(
              noItemsFoundIndicatorBuilder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "등록된 아이들이\n존재하지 않아요!",
                        style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
              noMoreItemsIndicatorBuilder: (context) {
                return const SizedBox.shrink();
              },
              newPageProgressIndicatorBuilder: (context) {
                return Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/icon_loading.json',
                      fit: BoxFit.fill,
                      width: 80,
                      height: 80,
                    ),
                  ],
                );
              },
              firstPageProgressIndicatorBuilder: (context) {
                return Container();
              },
              itemBuilder: (context, item, index) {
                return Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: Center(
                          child: item.url == null || item.url == ""
                              ? const Icon(
                                  Puppycat_social.icon_profile_large,
                                  size: 92,
                                  color: kNeutralColor500,
                                )
                              : Image.network(
                                  Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${item.url}").toUrl(),
                                  width: 135,
                                  height: 135,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: SvgPicture.asset(
                          'assets/image/feed/image/squircle.svg',
                          height: 84.h,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${item.name}"),
                        Row(
                          children: [
                            Text("${item.breedIdx == 1 || item.breedIdx == 2 ? item.breedNameEtc : item.breedName} | "),
                            Text("${item.genderText}"),
                          ],
                        ),
                        Row(
                          children: [
                            Text("${item.sizeText} | "),
                            Text("${item.weight}kg | "),
                            Text("${item.ageText}"),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        context.push("/home/myPage/myPetList/myPetRegistration/myPetEdit/${item.idx}");
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
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
                    disabledBackgroundColor: kNeutralColor400,
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    context.push("/home/myPage/myPetList/myPetRegistration");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      '우리 아이 등록하기',
                      style: kBody14BoldStyle.copyWith(color: kNeutralColor100),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
