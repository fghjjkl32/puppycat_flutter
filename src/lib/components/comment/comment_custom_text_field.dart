import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_textfield/flutter_social_textfield.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/components/feed/comment/mention_autocomplete_options.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/tag_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/comment_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';

class CommentCustomTextField extends ConsumerStatefulWidget {
  const CommentCustomTextField({required this.contentIdx, super.key});

  final int contentIdx;

  @override
  CommentCustomTextFieldState createState() => CommentCustomTextFieldState();
}

class CommentCustomTextFieldState
    extends ConsumerState<CommentCustomTextField> {
  TextEditingController _controller = TextEditingController();
  int lineCount = 0;
  bool hasInput = false;
  final initialized = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Theme(
        data: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
        ),
        child: Consumer(builder: (context, ref, child) {
          final commentHeaderState = ref.watch(commentHeaderProvider);

          if (commentHeaderState.hasSetControllerValue &&
              commentHeaderState.controllerValue != _controller.text) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                hasInput = commentHeaderState.hasInput;
                _controller.text = commentHeaderState.controllerValue;
                ref
                    .read(commentHeaderProvider.notifier)
                    .resetHasSetControllerValue();
              }
            });
          }

          if (_controller.text != '@${commentHeaderState.name} ' &&
              commentHeaderState.isReply &&
              !initialized.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _controller.value = TextEditingValue(
                  text: '@${commentHeaderState.name} ',
                  selection: TextSelection.collapsed(
                    offset: '@${commentHeaderState.name} '.length,
                  ),
                );
                initialized.value = true;
              }
            });
          }
          return Column(
            children: [
              commentHeaderState.isReply
                  ? Container(
                      width: double.infinity,
                      color: kNeutralColor300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.0.w),
                            child: Text(
                              "@${ref.watch(commentHeaderProvider).name} 님에게 답글 남기기",
                              style: kBody11RegularStyle.copyWith(
                                  color: kTextBodyColor),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ref
                                  .watch(commentHeaderProvider.notifier)
                                  .resetReplyCommentHeader();
                              _controller.text = '';
                              hasInput = false;
                              initialized.value = false;
                            },
                            icon: const Icon(
                              Puppycat_social.icon_close,
                              size: 26,
                              color: kTextBodyColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              commentHeaderState.isEdit
                  ? Container(
                      width: double.infinity,
                      color: kNeutralColor300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.0.w),
                            child: Text(
                              "댓글 수정",
                              style: kBody11RegularStyle.copyWith(
                                  color: kTextBodyColor),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ref
                                  .watch(commentHeaderProvider.notifier)
                                  .resetReplyCommentHeader();
                              _controller.text = '';
                              hasInput = false;
                              initialized.value = false;
                            },
                            icon: const Icon(
                              Puppycat_social.icon_close,
                              size: 26,
                              color: kTextBodyColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              MultiTriggerAutocomplete(
                optionsAlignment: OptionsAlignment.topStart,
                autocompleteTriggers: [
                  AutocompleteTrigger(
                    trigger: '@',
                    optionsViewBuilder:
                        (context, autocompleteQuery, controller) {
                      return MentionAutocompleteOptions(
                        query: autocompleteQuery.query,
                        onMentionUserTap: (user) {
                          final autocomplete =
                              MultiTriggerAutocomplete.of(context);
                          return autocomplete
                              .acceptAutocompleteOption(user.nick!);
                        },
                      );
                    },
                  ),
                ],
                fieldViewBuilder: (context, controller, focusNode) {
                  _controller = controller;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kNeutralColor400, width: 1),
                        borderRadius: BorderRadius.all(lineCount <= 2
                            ? const Radius.circular(50)
                            : const Radius.circular(10)),
                      ),
                      child: TextField(
                        focusNode: focusNode,
                        controller: _controller,
                        onChanged: (text) {
                          setState(() {
                            lineCount = text.split('\n').length;
                            hasInput = text.isNotEmpty;
                          });

                          int cursorPos = _controller.selection.baseOffset;
                          if (cursorPos > 0) {
                            int from = text.lastIndexOf('@', cursorPos);
                            if (from != -1) {
                              int prevCharPos = from - 1;
                              if (prevCharPos >= 0 &&
                                  text[prevCharPos] != ' ') {
                                return;
                              }

                              int nextSpace = text.indexOf(' ', from);
                              if (nextSpace == -1 || nextSpace >= cursorPos) {
                                String toSearch =
                                    text.substring(from + 1, cursorPos);
                                toSearch = toSearch.trim();

                                if (toSearch.isNotEmpty) {
                                  if (toSearch.length >= 1) {
                                    ref
                                        .watch(searchStateProvider.notifier)
                                        .searchQuery
                                        .add(toSearch);
                                  }
                                } else {
                                  ref
                                      .watch(searchStateProvider.notifier)
                                      .getMentionRecommendList(initPage: 1);
                                }
                              }
                            }
                          }
                        },
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
                              ? IconButton(
                                  onPressed: () async {
                                    final result = commentHeaderState.isEdit
                                        ? await ref
                                            .watch(
                                                commentStateProvider.notifier)
                                            .editContents(
                                              memberIdx: ref
                                                  .read(userModelProvider)!
                                                  .idx,
                                              contents: _controller.value.text,
                                              contentIdx: widget.contentIdx,
                                              commentIdx: ref
                                                  .watch(commentHeaderProvider)
                                                  .commentIdx!,
                                            )
                                        : await ref
                                            .watch(
                                                commentStateProvider.notifier)
                                            .postContents(
                                              memberIdx: ref
                                                  .read(userModelProvider)!
                                                  .idx,
                                              contents: _controller.value.text,
                                              contentIdx: widget.contentIdx,
                                              parentIdx: ref
                                                      .watch(
                                                          commentHeaderProvider)
                                                      .isReply
                                                  ? ref
                                                      .watch(
                                                          commentHeaderProvider)
                                                      .commentIdx
                                                  : null,
                                            );

                                    if (result.result) {
                                      FocusScope.of(context).unfocus();
                                      ref
                                          .watch(commentHeaderProvider.notifier)
                                          .resetReplyCommentHeader();
                                      _controller.text = '';
                                      hasInput = false;
                                      initialized.value = false;
                                    }
                                  },
                                  icon: const Icon(
                                    Puppycat_social.icon_send,
                                    color: kPrimaryColor,
                                  ),
                                )
                              : const Icon(
                                  Puppycat_social.icon_send,
                                  color: Colors.grey,
                                ),
                        ),
                        style: kBody13RegularStyle.copyWith(
                            color: kTextSubTitleColor),
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
