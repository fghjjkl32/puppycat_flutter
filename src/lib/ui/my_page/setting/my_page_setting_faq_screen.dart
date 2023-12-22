import 'dart:async';

import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/menu_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/faq_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class MyPageSettingFaqScreen extends ConsumerStatefulWidget {
  const MyPageSettingFaqScreen({super.key});

  @override
  MyPageSettingFaqScreenState createState() => MyPageSettingFaqScreenState();
}

class MyPageSettingFaqScreenState extends ConsumerState<MyPageSettingFaqScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PagingController<int, CustomerSupportItemModel> _faqPagingController;
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounceTimer;

  late Future _getMenuListFuture;

  @override
  void initState() {
    _getMenuListFuture = _getMenuList();

    _faqPagingController = ref.read(faqListStateProvider);
    super.initState();
  }

  Future<List<MenuItemModel>> _getMenuList() async {
    List<MenuItemModel> menuList = await ref.read(faqListStateProvider.notifier).getFaqMenuList();
    tabController = TabController(
      initialIndex: 0,
      length: menuList.length,
      vsync: this,
    );

    tabController.addListener(() {
      ref.read(faqListStateProvider.notifier).setFaqType(FaqType.values[tabController.index]);
    });
    print('menuList $menuList');
    return menuList;
  }

  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "자주하는 질문",
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                !isLogined
                    ? await ChannelTalk.boot(
                        pluginKey: 'cb3dc42b-c554-4722-b8d3-f25be06cadb3',
                      )
                    : await ChannelTalk.boot(
                        pluginKey: 'cb3dc42b-c554-4722-b8d3-f25be06cadb3',
                        memberId: myInfo.uuid,
                        email: myInfo.email,
                        name: myInfo.name,
                        memberHash: myInfo.channelTalkHash,
                        mobileNumber: myInfo.phone,
                      );
                await ChannelTalk.showMessenger();
              },
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 12.0.w),
                      child: Text(
                        "1:1채널톡",
                        style: kButton12BoldStyle.copyWith(color: kPreviousPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: FormBuilderTextField(
                    name: 'search',
                    // initialValue: '',
                    controller: searchController,
                    onChanged: (value) {
                      if (_searchDebounceTimer?.isActive ?? false) {
                        _searchDebounceTimer?.cancel();
                      }
                      // _searchWord = keyword;
                      _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
                        setState(() {});
                        ref.read(faqListStateProvider.notifier).search(searchController.text);
                      });
                    },
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
                      suffixIcon: searchController.text.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey[600],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                searchController.text = '';
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                      hintText: "궁금한 내용을 검색해 보세요.",
                      hintStyle: kBody11RegularStyle.copyWith(color: kPreviousNeutralColor500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
            future: _getMenuListFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('snapshot error ${snapshot.error}');
                return const Text('error');
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<MenuItemModel> menuList = snapshot.data!;
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      controller: tabController,
                      indicatorWeight: 4,
                      labelColor: kPreviousPrimaryColor,
                      indicatorColor: kPreviousPrimaryColor,
                      unselectedLabelColor: kPreviousNeutralColor500,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 14,
                        right: 10,
                      ),
                      isScrollable: true,
                      tabs: menuList
                          .map(
                            (e) => Text(
                              e.menuName ?? 'unknown',
                              style: kBody14BoldStyle,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        _buildListView(),
                        _buildListView(),
                        _buildListView(),
                        _buildListView(),
                        _buildListView(),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildListView() {
    return PagedListView<int, CustomerSupportItemModel>(
      pagingController: _faqPagingController,
      builderDelegate: PagedChildBuilderDelegate<CustomerSupportItemModel>(
        noItemsFoundIndicatorBuilder: (context) {
          return const SizedBox.shrink();
        },
        firstPageProgressIndicatorBuilder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
        itemBuilder: (context, item, index) {
          return _faqItem(item);
        },
      ),
    );
  }

  Widget _faqItem(CustomerSupportItemModel itemModel) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              title: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kPreviousNeutralColor300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                      child: Text(
                        itemModel.menuName ?? 'unknown',
                        style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      itemModel.title ?? 'unknown',
                      style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kPreviousNeutralColor200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      child: Html(
                        data: itemModel.contents ?? 'unknown',
                      ),
                      // Text(
                      //   itemModel.contents ?? 'unknown',
                      //   style: kBody13RegularStyle.copyWith(
                      //       color: kTextSubTitleColor),
                      // ),
                    ),
                  ),
                ),
              ]),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:intl/intl.dart';
// import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
// import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
// import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/setting/faq_list_state_provider.dart';
//
// class MyPageSettingFaqScreen extends ConsumerStatefulWidget {
//   const MyPageSettingFaqScreen({super.key});
//
//   @override
//   MyPageSettingFaqScreenState createState() => MyPageSettingFaqScreenState();
// }
//
// class MyPageSettingFaqScreenState extends ConsumerState<MyPageSettingFaqScreen> with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   late PagingController<int, CustomerSupportItemModel> _faqPagingController;
//
//   @override
//   void initState() {
//     tabController = TabController(
//       initialIndex: 0,
//       length: 4,
//       vsync: this,
//     );
//     _faqPagingController = ref.read(faqListStateProvider);
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         context.pop();
//
//         return false;
//       },
//       child: Material(
//         child: WillPopScope(
//           onWillPop: () async {
//             context.pop();
//             return false;
//           },
//           child: DefaultTabController(
//             length: 4,
//             child: Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//                 title: const Text(
//                   "자주하는 질문",
//                 ),
//                 leading: IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   icon: const Icon(
//                     Puppycat_social.icon_back,
//                     size: 40,
//                   ),
//                 ),
//                 actions: [
//                   Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: EdgeInsets.only(right: 8.0.w),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: kPrimaryLightColor,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 12.0.w),
//                           child: Text(
//                             "1:1채널톡",
//                             style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               body: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                     child: FormBuilderTextField(
//                       name: 'search',
//                       initialValue: '', //ref.watch(myPageSettingFaqProvider),
//                       style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//                       onChanged: (value) {},
//                           // ref.read(myPageSettingFaqProvider.notifier).onTextChanged(value!),
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: kNeutralColor200,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(100.0),
//                           gapPadding: 10.0,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(100.0),
//                           gapPadding: 10.0,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(100.0),
//                           gapPadding: 10.0,
//                         ),
//                         suffixIconConstraints: const BoxConstraints(
//                           minWidth: 24,
//                           minHeight: 24,
//                         ),
//                         suffixIcon:
//                             // ref
//                             //         .watch(myPageSettingFaqProvider.notifier)
//                             //         // ignore: invalid_use_of_protected_member
//                             //         .state
//                             //         .isEmpty
//                             true
//                                 ? Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//                                     child: Icon(
//                                       Icons.search,
//                                       color: Colors.grey[600],
//                                     ),
//                                   )
//                                 : GestureDetector(
//                                     onTap: () {
//                                       // ref
//                                       //     .read(myPageSettingFaqProvider.notifier)
//                                       //     .onTextChanged('');
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//                                       child: Icon(
//                                         Icons.close,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ),
//                         hintText: "검색어를 입력해 주세요.",
//                         hintStyle: kBody11RegularStyle.copyWith(color: kNeutralColor500),
//                       ),
//                     ),
//                   ),
//                   TabBar(
//                       controller: tabController,
//                       indicatorWeight: 2.4,
//                       labelColor: kPrimaryColor,
//                       indicatorColor: kPrimaryColor,
//                       unselectedLabelColor: kNeutralColor500,
//                       indicatorSize: TabBarIndicatorSize.label,
//                       labelPadding: EdgeInsets.only(
//                         top: 10.h,
//                         bottom: 10.h,
//                       ),
//                       tabs: [
//                         Text(
//                           "전체",
//                           style: kBody14BoldStyle,
//                         ),
//                         Text(
//                           "계정",
//                           style: kBody14BoldStyle,
//                         ),
//                         Text(
//                           "서비스",
//                           style: kBody14BoldStyle,
//                         ),
//                         Text(
//                           "이벤트",
//                           style: kBody14BoldStyle,
//                         ),
//                       ]),
//                   TabBarView(
//                     controller: tabController,
//                     children: [
//                       PagedListView<int, CustomerSupportItemModel>(
//                         pagingController: _faqPagingController,
//                         builderDelegate: PagedChildBuilderDelegate<CustomerSupportItemModel>(
//                           // animateTransitions: true,
//                           noItemsFoundIndicatorBuilder: (context) {
//                             // return const Text('No Comments');
//                             return const SizedBox.shrink();
//                           },
//                           firstPageProgressIndicatorBuilder: (context) {
//                             // ref.read(commentListStateProvider.notifier).getComments(_contentsIdx);
//                             return const Center(child: CircularProgressIndicator());
//                           },
//                           itemBuilder: (context, item, index) {
//                             return _noticeItem(item);
//                           },
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           const Text('a'),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           const Text('b'),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                           // _noticeItem(),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _noticeItem(CustomerSupportItemModel itemModel) {
//     return Column(
//       children: [
//         Theme(
//           data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//           child: ExpansionTile(
//               title: Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: kNeutralColor300,
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 14.0.w),
//                       child: Text(
//                         "계정",
//                         style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10.w,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "프로필 설정은 어떻게 하나요?",
//                         style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//                       ),
//                       Text(
//                         DateFormat('yyyy-MM-dd').format(DateTime.now()),
//                         style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 14.0.w),
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: kNeutralColor200,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 20.0.w),
//                       child: Column(
//                         children: [
//                           Text(
//                             '''프로필 설정하는법
//
// 1. 상단 [마이]를 클릭합니다.
// 2. 프로필 이미지 위치의 [내 정보 수정] 버튼을 클릭합니다.
// 3. [     ] 아이콘을 클릭합니다.
// 4. 닉네임 [변경] 버튼을 클릭합니다.
// 5. 프로필 이미지 또는 닉네임 변경 완료 후 상단의 [완료] 버튼을 클릭합니다.''',
//                             style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 10.0.h),
//                             child: const Divider(
//                               color: kNeutralColor300,
//                             ),
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 '문제를 해결하지 못하셨나요?',
//                                 style: kBody11RegularStyle.copyWith(color: kTextSubTitleColor),
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     '1:1 채널톡 문의하기',
//                                     style: kBody12RegularStyle.copyWith(color: kPrimaryColor),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ]),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//           child: const Divider(),
//         ),
//       ],
//     );
//   }
// }
