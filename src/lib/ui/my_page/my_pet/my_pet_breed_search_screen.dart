import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/components/post_feed/location_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/item_model.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/location_item.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_search_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/create_my_pet/cat_breed_search_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/create_my_pet/dog_breed_search_state_provider.dart';

class MyPetBreedSearchScreen extends ConsumerStatefulWidget {
  const MyPetBreedSearchScreen({super.key});

  @override
  MyPetBreedSearchScreenState createState() => MyPetBreedSearchScreenState();
}

class MyPetBreedSearchScreenState extends ConsumerState<MyPetBreedSearchScreen> with SingleTickerProviderStateMixin {
  late PagingController<int, ItemModel> _catPagingController;
  late PagingController<int, ItemModel> _dogPagingController;

  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounceTimer;
  TabController? _tabController;
  bool isTextEdit = false;
  int? petIdx;

  @override
  void initState() {
    _dogPagingController = ref.read(dogBreedSearchStateProvider);
    _catPagingController = ref.read(catBreedSearchStateProvider);

    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    searchController.addListener(() {
      _search();
    });

    ref.read(catBreedSearchStateProvider.notifier).searchBreed(ref.read(userInfoProvider).userModel!.idx, "");
    ref.read(dogBreedSearchStateProvider.notifier).searchBreed(ref.read(userInfoProvider).userModel!.idx, "");

    _dogPagingController.refresh();
    _catPagingController.refresh();
  }

  void _search() {
    if (_searchDebounceTimer?.isActive ?? false) {
      _searchDebounceTimer?.cancel();
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      ref.watch(catBreedSearchStateProvider.notifier).searchBreed(ref.read(userInfoProvider).userModel!.idx, searchController.text);
      ref.watch(dogBreedSearchStateProvider.notifier).searchBreed(ref.read(userInfoProvider).userModel!.idx, searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('반려동물 품종 검색'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Puppycat_social.icon_close_large,
          ),
        ),
        actions: [
          (searchController.text.isEmpty && !isTextEdit)
              ? TextButton(
                  child: Text(
                    '확인',
                    style: kButton12BoldStyle.copyWith(color: kNeutralColor500),
                  ),
                  onPressed: null,
                )
              : TextButton(
                  child: Text(
                    '확인',
                    style: kButton12BoldStyle.copyWith(color: isTextEdit ? kNeutralColor500 : kPrimaryColor),
                  ),
                  onPressed: isTextEdit
                      ? null
                      : () {
                          Navigator.of(context).pop({"idx": petIdx, "name": searchController.text});
                        },
                ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FormBuilderTextField(
              name: 'search',
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  isTextEdit = true;
                });
              },
              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: kNeutralColor200,
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
                // ignore: invalid_use_of_protected_member
                suffixIcon: searchController.text.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ImageIcon(
                          AssetImage('assets/image/chat/icon_search_medium.png'),
                          size: 20,
                          color: kTextTitleColor,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            searchController.text = '';
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: ImageIcon(
                            AssetImage('assets/image/chat/icon_close_large.png'),
                            size: 20,
                            color: kTextTitleColor,
                          ),
                        ),
                      ),
                hintText: "품종을 입력해주세요.",
                hintStyle: kBody11RegularStyle.copyWith(color: kNeutralColor500),
              ),
            ),
          ),
          TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorWeight: 3,
            labelColor: kNeutralColor600,
            indicatorColor: kNeutralColor600,
            unselectedLabelColor: kNeutralColor500,
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.only(
              top: 10.h,
              bottom: 10.h,
            ),
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "강아지",
                  style: kBody16MediumStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "고양이",
                  style: kBody16MediumStyle,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBreedList(type: 1), // 강아지
                _buildBreedList(type: 2), // 고양이
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildBreedList({required int type}) {
    return PagedListView<int, ItemModel>(
      pagingController: type == 1 ? _dogPagingController : _catPagingController,
      builderDelegate: PagedChildBuilderDelegate<ItemModel>(
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
        noItemsFoundIndicatorBuilder: (context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 140.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/chat/character_01_nopost_88_x2.png',
                    width: 88,
                    height: 88,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "품종을 찾을 수 없습니다",
                    textAlign: TextAlign.center,
                    style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                  ),
                ],
              ),
            ),
          );
        },
        itemBuilder: (context, item, index) {
          return InkWell(
            onTap: () {
              if (item.idx == 1 || item.idx == 2) {
                Navigator.of(context).pop({"idx": item.idx, "name": ""});
              } else {
                setState(() {
                  searchController.text = item.name!;
                  petIdx = item.idx;
                  isTextEdit = false;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("${item.name}"),
            ),
          );
        },
      ),
    );
  }
}
