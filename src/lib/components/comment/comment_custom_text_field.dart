import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/components/feed/comment/mention_autocomplete_options.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class CommentCustomTextField extends ConsumerStatefulWidget {
  const CommentCustomTextField({required this.contentIdx, super.key});

  final int contentIdx;

  @override
  CommentCustomTextFieldState createState() => CommentCustomTextFieldState();
}

class CommentCustomTextFieldState extends ConsumerState<CommentCustomTextField> {
  // TextEditingController _controller = TextEditingController();
  int lineCount = 0;
  final initialized = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Material(
      child: Container(
        color: kPreviousNeutralColor100,
        child: Theme(
          data: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
          ),
          child: Consumer(builder: (context, ref, child) {
            final commentHeaderState = ref.watch(commentHeaderProvider);

            if (commentHeaderState.hasSetControllerValue && commentHeaderState.controllerValue != ref.watch(commentValueProvider).text) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  ref.watch(commentValueProvider).text = commentHeaderState.controllerValue;
                  ref.read(commentHeaderProvider.notifier).resetHasSetControllerValue();
                }
              });
            }

            if (ref.watch(commentValueProvider).text != '@${commentHeaderState.name} ' && commentHeaderState.isReply && !initialized.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  ref.watch(commentValueProvider).value = TextEditingValue(
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
                        color: kPreviousNeutralColor300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "@${ref.watch(commentHeaderProvider).name} 님에게 답글 남기기",
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref.watch(commentHeaderProvider.notifier).resetReplyCommentHeader();
                                ref.watch(commentValueProvider).text = '';
                                ref.read(commentHeaderProvider.notifier).setHasInput(false);
                                initialized.value = false;
                              },
                              icon: const Icon(
                                Puppycat_social.icon_close,
                                size: 26,
                                color: kPreviousTextBodyColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                commentHeaderState.isEdit
                    ? Container(
                        width: double.infinity,
                        color: kPreviousNeutralColor300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "댓글 수정",
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref.watch(commentHeaderProvider.notifier).resetReplyCommentHeader();
                                ref.watch(commentValueProvider).text = '';
                                ref.read(commentHeaderProvider.notifier).setHasInput(false);

                                initialized.value = false;
                              },
                              icon: const Icon(
                                Puppycat_social.icon_close,
                                size: 26,
                                color: kPreviousTextBodyColor,
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
                      optionsViewBuilder: (context, autocompleteQuery, controller) {
                        return MentionAutocompleteOptions(
                          query: autocompleteQuery.query,
                          onMentionUserTap: (user) {
                            final autocomplete = MultiTriggerAutocomplete.of(context);
                            return autocomplete.acceptAutocompleteOption(user.nick!);
                          },
                        );
                      },
                    ),
                  ],
                  fieldViewBuilder: (context, controller, focusNode) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.watch(commentValueProvider.notifier).state = controller;
                    });

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kPreviousNeutralColor400, width: 1),
                          borderRadius: BorderRadius.all(lineCount <= 2 ? const Radius.circular(50) : const Radius.circular(10)),
                        ),
                        child: TextField(
                          readOnly: !isLogined ? true : false,
                          focusNode: focusNode,
                          controller: controller,
                          onChanged: (text) {
                            setState(() {
                              lineCount = text.split('\n').length;

                              ref.read(commentHeaderProvider.notifier).setHasInput(text.isNotEmpty);
                            });

                            int cursorPos = ref.watch(commentValueProvider).selection.baseOffset;
                            if (cursorPos > 0) {
                              int from = text.lastIndexOf('@', cursorPos);
                              if (from != -1) {
                                int prevCharPos = from - 1;
                                if (prevCharPos >= 0 && text[prevCharPos] != ' ') {
                                  return;
                                }

                                int nextSpace = text.indexOf(' ', from);
                                if (nextSpace == -1 || nextSpace >= cursorPos) {
                                  String toSearch = text.substring(from + 1, cursorPos);
                                  toSearch = toSearch.trim();

                                  if (toSearch.isNotEmpty) {
                                    if (toSearch.length >= 1) {
                                      ref.watch(searchStateProvider.notifier).searchQuery.add(toSearch);
                                    }
                                  } else {
                                    ref.watch(searchStateProvider.notifier).getMentionRecommendList(initPage: 1);
                                  }
                                }
                              }
                            }
                          },
                          scrollPhysics: const ClampingScrollPhysics(),
                          maxLength: 200,
                          maxLines: lineCount > 4 ? 4 : null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            counterText: "",
                            hintText: !isLogined ? "로그인 하면 쓸 수 있어요." : '댓글을 남겨 보세요.',
                            hintStyle: kBody12RegularStyle.copyWith(color: kPreviousNeutralColor500),
                            contentPadding: const EdgeInsets.all(16),
                            suffixIcon: ref.read(commentHeaderProvider).hasInput
                                ? IconButton(
                                    onPressed: () async {
                                      final restrain = await ref.read(restrainStateProvider.notifier).checkRestrainStatus(RestrainCheckType.writeComment);

                                      if (restrain) {
                                        if (commentHeaderState.isEdit) {
                                          String tempContents;
                                          tempContents = await processHashtagEditedText(
                                            ref.watch(commentValueProvider.notifier).state.text,
                                            ref.read(hashtagListProvider),
                                          );

                                          tempContents = await processMentionEditedText(
                                            tempContents,
                                            ref.read(mentionListProvider),
                                          );

                                          await ref.watch(commentListStateProvider.notifier).editContents(
                                                contents: tempContents,
                                                contentIdx: widget.contentIdx,
                                                commentIdx: ref.watch(commentHeaderProvider).commentIdx!,
                                              );
                                        } else {
                                          await ref.watch(commentListStateProvider.notifier).postContents(
                                                contents: ref.watch(commentValueProvider).value.text,
                                                contentIdx: widget.contentIdx,
                                                parentIdx: ref.watch(commentHeaderProvider).isReply ? ref.watch(commentHeaderProvider).commentIdx : null,
                                              );
                                        }

                                        int commentIdx = -1;
                                        if (ref.read(commentHeaderProvider).commentIdx != null) {
                                          commentIdx = ref.read(commentHeaderProvider).commentIdx!;
                                        }

                                        print('ref.watch(commentHeaderProvider).isReply ${ref.watch(commentHeaderProvider).isReply}');
                                        if (ref.watch(commentHeaderProvider).isReply) {
                                          ref.read(commentListRefreshFocusProvider.notifier).state = ref.read(commentHeaderProvider).commentIdx!;
                                          // ref.read(commentListStateProvider.notifier).getFocusingComments(widget.contentIdx, ref.watch(commentHeaderProvider).commentIdx!);
                                          ref.read(commentListStateProvider).refresh();
                                        } else {
                                          ref.read(commentListStateProvider).refresh();
                                        }

                                        // if (result.result) {
                                        //   FocusScope.of(context).unfocus();
                                        ref.watch(commentHeaderProvider.notifier).resetReplyCommentHeader();
                                        ref.watch(commentValueProvider).text = '';
                                        ref.read(commentHeaderProvider.notifier).setHasInput(false);
                                        initialized.value = false;

                                        ref.read(hashtagListProvider.notifier).state = [];
                                        ref.read(mentionListProvider.notifier).state = [];
                                        // }
                                      }
                                    },
                                    icon: const Icon(
                                      Puppycat_social.icon_send,
                                      color: kPreviousPrimaryColor,
                                    ),
                                  )
                                : const Icon(
                                    Puppycat_social.icon_send,
                                    color: Colors.grey,
                                  ),
                          ),
                          style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
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
      ),
    );
  }
}
