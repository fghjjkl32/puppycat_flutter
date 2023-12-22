import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/menu_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/notice_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MyPageSettingNoticeScreen extends ConsumerStatefulWidget {
  const MyPageSettingNoticeScreen({super.key});

  @override
  MyPageSettingNoticeScreenState createState() => MyPageSettingNoticeScreenState();
}

class MyPageSettingNoticeScreenState extends ConsumerState<MyPageSettingNoticeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PagingController<int, CustomerSupportItemModel> _noticePagingController;
  final AutoScrollController _scrollController = AutoScrollController();

  late Future _getMenuListFuture;

  @override
  void initState() {
    _getMenuListFuture = _getMenuList();
    // tabController = TabController(
    //   initialIndex: 0,
    //   length: 3,
    //   vsync: this,
    // );

    // tabController.addListener(() {
    //   print('tabController Idx ${tabController.index}');
    //   ref.read(noticeListStateProvider.notifier).setNoticeType(NoticeType.values[tabController.index]);
    // });

    _noticePagingController = ref.read(noticeListStateProvider);
    super.initState();

    _noticePagingController.addListener(() async {
      print('not run? ');
      if (_noticePagingController.itemList != null) {
        int focusIdx = ref.read(noticeFocusIdxStateProvider);

        int scrollIdx = ref.read(noticeListStateProvider).itemList!.indexWhere((element) => element.idx == focusIdx);
        print('run?? $focusIdx / scrollIdx $scrollIdx');
        if (scrollIdx < 0) {
          return;
        }

        await _scrollController.scrollToIndex(
          // _commentFocusIndex!,
          scrollIdx,
          preferPosition: AutoScrollPosition.begin,
        );
        ref.read(noticeFocusIdxStateProvider.notifier).state = 0;
      }
    });
  }

  Future<List<MenuItemModel>> _getMenuList() async {
    List<MenuItemModel> menuList = await ref.read(noticeListStateProvider.notifier).getNoticeMenuList();
    tabController = TabController(
      initialIndex: 0,
      length: menuList.length,
      vsync: this,
    );

    tabController.addListener(() {
      print('tabController Idx ${tabController.index}');
      ref.read(noticeListStateProvider.notifier).setNoticeType(NoticeType.values[tabController.index]);
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
            "공지사항",
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
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
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
          // bottom:
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
              final menuLength = menuList.length;

              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      controller: tabController,
                      indicatorWeight: 2.4,
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
                  const SizedBox(
                    height: 4,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
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
      pagingController: _noticePagingController,
      scrollController: _scrollController,
      builderDelegate: PagedChildBuilderDelegate<CustomerSupportItemModel>(
        // animateTransitions: true,
        noItemsFoundIndicatorBuilder: (context) {
          // return const Text('No Comments');
          return const SizedBox.shrink();
        },
        firstPageProgressIndicatorBuilder: (context) {
          // ref.read(commentListStateProvider.notifier).getComments(_contentsIdx);
          return const Center(child: CircularProgressIndicator());
        },
        itemBuilder: (context, item, index) {
          return AutoScrollTag(
            key: UniqueKey(),
            controller: _scrollController,
            index: index,
            child: _noticeItem(item),
          );
        },
      ),
    );
  }

  Widget _noticeItem(CustomerSupportItemModel itemModel) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: itemModel.idx == ref.watch(noticeExpansionIdxStateProvider),
            onExpansionChanged: (isExpansion) {
              if (isExpansion) {
                ref.read(noticeExpansionIdxStateProvider.notifier).state = itemModel.idx!;
              }
            },
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemModel.title ?? 'unknown',
                      style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(itemModel.regDate != null ? DateTime.parse(itemModel.regDate!) : DateTime.now()),
                      style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
                    ),
                  ],
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
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
      ],
    );
  }
}
