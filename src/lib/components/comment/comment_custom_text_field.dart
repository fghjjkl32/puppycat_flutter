import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';

class CommentCustomTextField extends ConsumerStatefulWidget {
  const CommentCustomTextField({super.key});

  @override
  CommentCustomTextFieldState createState() => CommentCustomTextFieldState();
}

class CommentCustomTextFieldState
    extends ConsumerState<CommentCustomTextField> {
  final TextEditingController _controller = TextEditingController();
  int lineCount = 0;
  bool hasInput = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        lineCount = _controller.value.text.split('\n').length;
        hasInput = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Theme(
        data: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                ref.watch(commentHeaderProvider).isReply
                    ? Container(
                        width: double.infinity,
                        color: kNeutralColor300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 12.0.w),
                              child: Text(
                                "@bichon_딩동 님에게 답글 남기기",
                                style: kBody11RegularStyle.copyWith(
                                    color: kTextBodyColor),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref
                                    .watch(commentHeaderProvider.notifier)
                                    .resetCommentHeader();
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                                color: kTextBodyColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kNeutralColor400, width: 1),
                      borderRadius: BorderRadius.all(lineCount <= 2
                          ? const Radius.circular(50)
                          : const Radius.circular(10)),
                    ),
                    child: TextField(
                      // focusNode: _focusNode,
                      controller: _controller,
                      scrollPhysics: const ClampingScrollPhysics(),
                      maxLength: 200,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        counterText: "",
                        hintText: '댓글을 입력해주세요.',
                        hintStyle: kBody12RegularStyle.copyWith(
                            color: kNeutralColor500),
                        contentPadding: const EdgeInsets.all(16),
                        suffixIcon: hasInput
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.check_circle,
                                color: Colors.grey,
                              ),
                      ),
                      // name: 'comment',
                      style: kBody13RegularStyle.copyWith(
                          color: kTextSubTitleColor),
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
