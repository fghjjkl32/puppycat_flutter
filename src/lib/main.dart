import 'package:bubble/bubble.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/size_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          //feed title
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, right: 10.w, bottom: 12.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/image/feed/image/sample_image1.png',
                        height: 32.h,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "아지다멍",
                          style: kTitle14BoldStyle.copyWith(
                              color: kTextTitleColor),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "강원도 평창군 평창읍 · 2분 전",
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Image.asset(
                  'assets/image/feed/icon/small_size/icon_more.png',
                  height: 32.w,
                ),
              ],
            ),
          ),
          //feed detail image
          Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 266.0.h,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    _counter.value = index;
                  },
                ),
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: kPrimarySideFeedImagePadding,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            'assets/image/feed/image/sample_image2.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: ValueListenableBuilder<int>(
                  valueListenable: _counter,
                  builder: (BuildContext context, int index, Widget? child) =>
                      AnimatedSmoothIndicator(
                    activeIndex: index,
                    axisDirection: Axis.horizontal,
                    count: 9,
                    effect: ScrollingDotsEffect(
                      dotColor: kNeutralColor400,
                      activeDotColor: kPrimaryColor,
                      dotWidth: 6.h,
                      dotHeight: 6.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //feed content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Text(
              "눈이 제일 좋은 멈멈미🌨🤍 눈만 보면 아주 그냥.. 흰둥이 다 됐어.. 널 언제 씻기니ㅠ",
              style: kBody13RegularStyle.copyWith(color: kTextTitleColor),
            ),
          ),
          //feed bottom icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/feed/icon/large_size/icon_like_off.png',
                          height: 32.w,
                        ),
                        Text(
                          "338",
                          style: kBody12RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/feed/icon/large_size/icon_comment.png',
                          height: 32.w,
                        ),
                        Text(
                          "12",
                          style: kBody12RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Image.asset(
                  'assets/image/feed/icon/large_size/icon_bookmark.png',
                  height: 32.w,
                ),
              ],
            ),
          ),
          //feed comment
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    color: kNeutralColor300,
                    child: Image.asset(
                      'assets/image/feed/icon/large_size/icon_taguser.png',
                      height: 32.h,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Bubble(
                    radius: Radius.circular(10.w),
                    elevation: 0,
                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftCenter,
                    color: kNeutralColor200,
                    padding: BubbleEdges.only(
                        left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'bichon_딩동',
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                        Text(
                          '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
                          style: kBody11RegularStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/image/feed/image/sample_image1.png',
                    height: 30.h,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Bubble(
                    radius: Radius.circular(10.w),
                    elevation: 0,
                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftCenter,
                    color: kNeutralColor200,
                    padding: BubbleEdges.only(
                        left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'baejji',
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                        Text(
                          '나 왜 제천 안살아ㅠㅜ',
                          style: kBody11RegularStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0.h),
            child: Divider(),
          ),
          //-------------------
          //feed title
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, right: 10.w, bottom: 12.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/image/feed/image/sample_image1.png',
                        height: 32.h,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "아지다멍",
                          style: kTitle14BoldStyle.copyWith(
                              color: kTextTitleColor),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "강원도 평창군 평창읍 · 2분 전",
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Image.asset(
                  'assets/image/feed/icon/small_size/icon_more.png',
                  height: 32.w,
                ),
              ],
            ),
          ),
          //feed detail image
          Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 266.0.h,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    _counter.value = index;
                  },
                ),
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: kPrimarySideFeedImagePadding,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            'assets/image/feed/image/sample_image2.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: ValueListenableBuilder<int>(
                  valueListenable: _counter,
                  builder: (BuildContext context, int index, Widget? child) =>
                      AnimatedSmoothIndicator(
                    activeIndex: index,
                    axisDirection: Axis.horizontal,
                    count: 9,
                    effect: ScrollingDotsEffect(
                      dotColor: kNeutralColor400,
                      activeDotColor: kPrimaryColor,
                      dotWidth: 6.h,
                      dotHeight: 6.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //feed content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Text(
              "눈이 제일 좋은 멈멈미🌨🤍 눈만 보면 아주 그냥.. 흰둥이 다 됐어.. 널 언제 씻기니ㅠ",
              style: kBody13RegularStyle.copyWith(color: kTextTitleColor),
            ),
          ),
          //feed bottom icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/feed/icon/large_size/icon_like_off.png',
                          height: 32.w,
                        ),
                        Text(
                          "338",
                          style: kBody12RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        Image.asset(
                          'assets/image/feed/icon/large_size/icon_comment.png',
                          height: 32.w,
                        ),
                        Text(
                          "12",
                          style: kBody12RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Image.asset(
                  'assets/image/feed/icon/large_size/icon_bookmark.png',
                  height: 32.w,
                ),
              ],
            ),
          ),
          //feed comment
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    color: kNeutralColor300,
                    child: Image.asset(
                      'assets/image/feed/icon/large_size/icon_taguser.png',
                      height: 32.h,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Bubble(
                    radius: Radius.circular(10.w),
                    elevation: 0,
                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftCenter,
                    color: kNeutralColor200,
                    padding: BubbleEdges.only(
                        left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'bichon_딩동',
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                        Text(
                          '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
                          style: kBody11RegularStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/image/feed/image/sample_image1.png',
                    height: 30.h,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Bubble(
                    radius: Radius.circular(10.w),
                    elevation: 0,
                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftCenter,
                    color: kNeutralColor200,
                    padding: BubbleEdges.only(
                        left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'baejji',
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                        Text(
                          '나 왜 제천 안살아ㅠㅜ',
                          style: kBody11RegularStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
