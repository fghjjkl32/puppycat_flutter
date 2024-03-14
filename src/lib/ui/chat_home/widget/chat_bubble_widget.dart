import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

enum ChatBubbleAlignment {
  left,
  right,
}

class ChatBubbleWidget extends Bubble {
  // final Widget childWidget;
  final Widget? sideWidget;
  final ChatBubbleAlignment chatBubbleAlignment;
  final GestureLongPressCallback? onLongPress;
  final ValueChanged<bool>? onHighlightChanged;
  final GestureTapCallback? onDoubleTap;
  final double borderRadius;

  ChatBubbleWidget({
    super.key,
    super.child,
    // required this.childWidget,
    this.borderRadius = 10.0,
    super.showNip,
    super.nip,
    super.nipWidth,
    super.nipHeight,
    super.nipOffset,
    super.nipRadius,
    super.stick,
    super.color,
    super.borderColor,
    super.borderWidth,
    super.borderUp,
    super.elevation,
    super.shadowColor,
    super.padding,
    super.margin,
    // super.alignment,
    super.style,
    this.sideWidget,
    this.chatBubbleAlignment = ChatBubbleAlignment.left,
    this.onDoubleTap,
    this.onHighlightChanged,
    this.onLongPress,
  }) : super(radius: Radius.circular(borderRadius));

  @override
  Widget build(BuildContext context) {
    bool isLeft = chatBubbleAlignment == ChatBubbleAlignment.left ? true : false;

    List<Widget> buildWidgets = [
      Flexible(
        child: InkWell(
          highlightColor: super.color,
          borderRadius: BorderRadius.circular(borderRadius),
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onHighlightChanged: onHighlightChanged,
          child: super.build(context),
        ),
        // child: super.build(context),
      ),
    ];

    if (sideWidget != null) {
      if (isLeft) {
        buildWidgets.add(sideWidget!);
      } else {
        buildWidgets.insert(0, sideWidget!);
      }
    }

    return Row(
      mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...buildWidgets,
      ],
    );
    return super.build(context);
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class ChatBubbleWidget extends ConsumerStatefulWidget {
//   const ChatBubbleWidget({super.key});
//
//   @override
//   ChatBubbleWidgetState createState() => ChatBubbleWidgetState();
// }
//
// class ChatBubbleWidgetState extends ConsumerState<ChatBubbleWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
