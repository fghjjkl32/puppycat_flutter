import 'package:appspector/appspector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_deatil_list_widget.dart';
import 'package:pet_mobile_social_flutter/components/favorite_list/favorite_list_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_main_widget.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'components/feed/feed_detail_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runAppSpector();
  runApp(
    const ProviderScope(
      child : MyApp(),
    ),
  );
}
final routerProvider = Provider<GoRouter>((ref) => AppRouter().router);
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
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


Future runAppSpector() async {
  final config = Config()
    ..androidApiKey =
        "android_ODg1YjU5NmEtMTcwYi00M2NiLWIxMTYtMjIyN2VjY2M5OTk5";

  // If you don't want to start all monitors you can specify a list of necessary ones
  // config.monitors = [Monitors.http, Monitors.sqLite, Monitors.fileSystem];
  AppSpectorPlugin.run(config);
  Future(() async {
    final isStarted = await AppSpectorPlugin.shared().isStarted();
    if (!isStarted) {
      await AppSpectorPlugin.shared().start();
    }
  },) ;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void onTap() {
    setState(() {
      testValue = !testValue;
    });
  }

  bool testValue = false;
  @override
  Widget build(BuildContext context) {
    final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);

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
          TextButton(
            onPressed: () {
              toast(
                  context: context,
                  text: '광고성 정보 수신 여부가 ‘동의’로 변경되었습니다.',
                  type: ToastType.purple,
                  secondText:
                      "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
            },
            child: const Text("수신 동의 토스트"),
          ),
          TextButton(
            onPressed: () {
              toast(
                context: context,
                text: '광고성 정보 수신 여부가 ‘거부’로 변경되었습니다.',
                type: ToastType.red,
              );
            },
            child: const Text("수신 거부 토스트"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                activeColor: kPrimaryLightColor,
                visualDensity: VisualDensity.standard,
                value: testValue,
                checkColor: kPrimaryColor,
                onChanged: (value) {
                  if (value != null) onTap();
                },
              ),
              Checkbox(
                visualDensity: VisualDensity.compact,
                activeColor: kPrimaryLightColor,
                value: !testValue,
                checkColor: kPrimaryColor,
                onChanged: (value) {
                  if (value != null) onTap();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterSwitch(
                padding: 4,
                width: 48.w,
                height: 20.h,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: kNeutralColor500,
                toggleSize: 20.0.w,
                value: testValue,
                borderRadius: 50.0.w,
                onToggle: (value) async {
                  onTap();
                },
              ),
              FlutterSwitch(
                padding: 4,
                width: 48.w,
                height: 20.h,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: kNeutralColor500,
                toggleSize: 20.0.w,
                value: !testValue,
                borderRadius: 50.0.w,
                onToggle: (value) async {
                  onTap();
                },
              ),
            ],
          ),
          TextButton(
            onPressed: () => InstaAssetPicker.pickAssets(
              context,
              maxAssets: 12,
              pickerTheme: themeData(context).copyWith(
                canvasColor: kNeutralColor100, // body background color
                colorScheme: theme.colorScheme.copyWith(
                  background: kNeutralColor100, // albums list background color
                ),
                appBarTheme: theme.appBarTheme.copyWith(
                  backgroundColor: kNeutralColor100,
                ),
              ),
              onCompleted: (cropStream) {},
            ),
            child: const Text(
              '이미지 선택',
            ),
          ),
          TextButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();

              await picker.pickImage(source: ImageSource.camera);
            },
            child: const Text(
              '카메라 연결',
            ),
          ),
        ],
      ),
    );
  }
}
