import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_deatil_list_widget.dart';
import 'package:pet_mobile_social_flutter/components/favorite_list/favorite_list_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_main_widget.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'components/feed/feed_detail_widget.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          routerConfig: router,
          title: 'Flutter Demo',
          theme: themeData(context),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          const FeedFollowWidget(),
          const FeedDetailWidget(),
          const FeedMainWidget(),
          const FavoriteListWidget(),
          const CommentDetailListWidget(),
          TextButton(
            onPressed: () {
              showCustomModalBottomSheet(
                context: context,
                widget: Column(
                  children: [
                    BottomSheetButtonItem(
                      iconImage:
                          'assets/image/feed/icon/small_size/icon_user_de.png',
                      title: '숨기기',
                      titleStyle: kButton14BoldStyle.copyWith(
                          color: kTextSubTitleColor),
                    ),
                    BottomSheetButtonItem(
                      iconImage:
                          'assets/image/feed/icon/small_size/icon_user_block_on.png',
                      title: '차단하기',
                      titleStyle: kButton14BoldStyle.copyWith(
                          color: kTextSubTitleColor),
                    ),
                    BottomSheetButtonItem(
                      iconImage:
                          'assets/image/feed/icon/small_size/icon_report.png',
                      title: '신고하기',
                      titleStyle:
                          kButton14BoldStyle.copyWith(color: kBadgeColor),
                    ),
                  ],
                ),
              );
            },
            child: const Text("feed bottom sheet button"),
          ),
          TextButton(
            onPressed: () {
              showCustomModalBottomSheet(
                context: context,
                widget: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        "태그된 대상",
                        style: kBody16BoldStyle.copyWith(
                            color: kTextSubTitleColor),
                      ),
                    ),
                    const FavoriteListWidget(),
                  ],
                ),
              );
            },
            child: const Text("태그된 대상"),
          ),
        ],
      ),
    );
  }
}
