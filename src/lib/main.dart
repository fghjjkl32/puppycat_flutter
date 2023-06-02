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

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

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
            child: const Divider(),
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
              '''제천 근처 사는 멍멍이들 주목❕🐶

아지가 너무 조아서 추천할게 있어...💓 사실 지난주에 아지가 우리 눈나야랑 제천 구독 #jc_goodog 여기에 같이 출근을 했거든🐾 근데 진짜 짱짱이라 멍멍이 친구들 많이많이 놀러왔으면 조케써서!!! 추천하려구 해💓

애견카페🥨 유치원🍼 호텔링🎀 행동교정🧸 미용🧼 루프탑🏝

실내, 야외 모두 소형견·대형견 공간이 분리되어 있으니까 다들 꼬옥 놀러와죠❕❤ ''',
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
            child: const Divider(),
          ),
          //-------------------
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
          //feed main image
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
            child: Column(
              children: [
                if (imgList.length == 1) ...[
                  Padding(
                    padding: kPrimarySideFeedImagePadding,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/image/feed/image/sample_image2.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ] else if (imgList.length == 2) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            topLeft: Radius.circular(12.0),
                          ),
                          child: Image.network(
                            imgList[0],
                            fit: BoxFit.cover,
                            height: 266.h,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                          child: Image.network(
                            imgList[1],
                            fit: BoxFit.cover,
                            height: 266.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (imgList.length == 3) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            topLeft: Radius.circular(12.0),
                          ),
                          child: Image.network(
                            imgList[0],
                            fit: BoxFit.cover,
                            height: 266.h,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                              ),
                              child: Image.network(
                                imgList[1],
                                fit: BoxFit.cover,
                                height: 132.h,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12.0),
                              ),
                              child: Image.network(
                                imgList[1],
                                fit: BoxFit.cover,
                                height: 132.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ] else if (imgList.length > 4) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            topLeft: Radius.circular(12.0),
                          ),
                          child: Image.network(
                            imgList[0],
                            fit: BoxFit.cover,
                            height: 266.h,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                              ),
                              child: Image.network(
                                imgList[1],
                                fit: BoxFit.cover,
                                height: 132.h,
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(12.0),
                                  ),
                                  child: Image.network(
                                    imgList[1],
                                    fit: BoxFit.cover,
                                    height: 132.h,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Container(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                      '+ ${imgList.length - 4}',
                                      style: kTitle18BoldStyle.copyWith(
                                          color: kNeutralColor100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          //feed content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Text(
              "눈토끼🐰 우리 테테의 두번째 겨울",
              style: kBody13RegularStyle.copyWith(color: kTextTitleColor),
            ),
          ),
          //feed icon
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
        ],
      ),
    );
  }
}
