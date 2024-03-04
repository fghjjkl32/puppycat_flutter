import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/new_notification_state_provider.dart';

class PopupMenuWithReddot extends ConsumerStatefulWidget {
  const PopupMenuWithReddot({super.key});

  @override
  PopupMenuWithReddotState createState() => PopupMenuWithReddotState();
}

class PopupMenuWithReddotState extends ConsumerState<PopupMenuWithReddot> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addObserver(this);
  }

  bool showLottieAnimation = false;

  //
  // @override
  // void didChangeMetrics() {
  //   super.didChangeMetrics();
  //   // Function called when the widget metrics change (e.g., when the widget is drawn on screen)
  //   if (ModalRoute.of(context)?.isCurrent ?? false) {
  //     print('ohg run??');
  //     yourFunction();
  //   }
  // }
  //
  // void yourFunction() {
  //   print("Widget is now on the screen");
  // }

  @override
  void dispose() {
    // WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLogined = ref.read(loginStatementProvider);

    return PopupMenuButton(
      offset: Offset(0, 46),
      shape: const TooltipShape(),
      padding: EdgeInsets.zero,
      onSelected: (id) {
        setState(() {
          showLottieAnimation = false;
        });
        if (id == 'notification') {
          !isLogined ? context.push("/home/login") : context.push("/notification");
        }
        if (id == 'search') {
          context.push("/search");
        }
        if (id == 'message') {
          !isLogined ? context.push("/home/login") : context.push('/chatHome');
        }
        if (id == 'setting') {
          context.push("/setting");
        }
      },
      onCanceled: () {
        setState(() {
          showLottieAnimation = false;
        });
      },
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     bottomLeft: Radius.circular(16.0),
      //     bottomRight: Radius.circular(16.0),
      //     topLeft: Radius.circular(16.0),
      //     topRight: Radius.circular(16.0),
      //   ),
      // ),
      itemBuilder: (context) {
        Future.delayed(Duration.zero, () {
          setState(() {
            showLottieAnimation = true;
          });
        });

        final list = <PopupMenuEntry>[];
        list.add(
          diaryPopUpMenuItem(
            'notification',
            '알림',
            const Icon(
              Puppycat_social.icon_bell,
            ),
            ref.watch(newNotificationStateProvider),
          ),
        );
        list.add(
          const PopupMenuDivider(
            height: 5,
          ),
        );
        list.add(
          diaryPopUpMenuItem(
            'search',
            '검색',
            const Icon(
              Puppycat_social.icon_search_medium,
            ),
            false,
          ),
        );
        list.add(
          const PopupMenuDivider(
            height: 5,
          ),
        );
        list.add(
          diaryPopUpMenuItem(
            'message',
            '메시지',
            const Icon(
              Puppycat_social.icon_chat,
            ),
            false,
          ),
        );
        list.add(
          const PopupMenuDivider(
            height: 5,
          ),
        );
        list.add(
          diaryPopUpMenuItem(
            'setting',
            '설정',
            const Icon(
              Puppycat_social.icon_set_small,
            ),
            false,
          ),
        );
        return list;
      },
      child: Stack(
        children: [
          showLottieAnimation
              ? Lottie.asset(
                  'assets/lottie/icon_more_header.json',
                  repeat: false,
                )
              : const Icon(
                  Puppycat_social.icon_more_header,
                  size: 40,
                ),
          Visibility(
            visible: ref.watch(newNotificationStateProvider),
            child: const Positioned(
              top: 4,
              right: 4,
              child: Icon(
                Icons.circle,
                color: Colors.red,
                size: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem diaryPopUpMenuItem(
    String title,
    String value,
    Widget icon,
    bool isReddot,
  ) {
    print('isReddot $isReddot');
    return PopupMenuItem(
      value: title,
      child: Center(
        child: Row(
          children: [
            Stack(
              children: [
                icon,
                Visibility(
                  visible: isReddot,
                  child: const Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: kButton12BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
            ),
          ],
        ),
      ),
    );
  }
}

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(rrect.width - 35, 0);
    path.lineTo(rrect.width - 20, -10);
    path.lineTo(rrect.width - 20, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}
