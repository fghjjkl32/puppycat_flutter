import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
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

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    tabController.addListener(() {
      print('tabController Idx ${tabController.index}');
      ref.read(noticeListStateProvider.notifier).setNoticeType(NoticeType.values[tabController.index]);
    });

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
                  padding: EdgeInsets.only(right: 8.0.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 12.0.w),
                      child: Text(
                        "1:1채널톡",
                        style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
          bottom: TabBar(
              controller: tabController,
              indicatorWeight: 3,
              labelColor: kPrimaryColor,
              indicatorColor: kPrimaryColor,
              unselectedLabelColor: kNeutralColor500,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.only(
                top: 10.h,
                bottom: 10.h,
              ),
              tabs: [
                Text(
                  "전체",
                  style: kBody14BoldStyle,
                ),
                Text(
                  "일반",
                  style: kBody14BoldStyle,
                ),
                Text(
                  "이벤트",
                  style: kBody14BoldStyle,
                ),
              ]),
        ),
        body:
            // GestureDetector(
            //   on
            //   child: _buildListView(),
            // ),
            TabBarView(
          controller: tabController,
          children: [
            _buildListView(),
            _buildListView(),
            _buildListView(),
          ],
        ),
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
                    color: kNeutralColor300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 14.0.w),
                    child: Text(
                      itemModel.menuName ?? 'unknown',
                      style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemModel.title ?? 'unknown',
                      style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(itemModel.regDate != null ? DateTime.parse(itemModel.regDate!) : DateTime.now()),
                      style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ],
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kNeutralColor200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 20.0.w),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: const Divider(),
        ),
      ],
    );
  }
}
