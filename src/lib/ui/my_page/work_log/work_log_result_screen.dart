import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/components/feed/comment/mention_autocomplete_options.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/work_log/work_log_calendar_screen.dart';

final workLogContentProvider = StateProvider<TextEditingController>((ref) => TextEditingController());

class WorkLogResultScreen extends ConsumerStatefulWidget {
  final List<WalkResultItemModel> events;
  final int initialIndex;

  const WorkLogResultScreen({
    Key? key,
    required this.events,
    required this.initialIndex,
  }) : super(key: key);

  @override
  WorkLogResultScreenState createState() => WorkLogResultScreenState();
}

class WorkLogResultScreenState extends ConsumerState<WorkLogResultScreen> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex; // <-- Initialize the variable here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "산책 결과",
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Puppycat_social.icon_back,
            size: 40,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.events.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              // Text(widget.events[index].title),
              // Text(widget.events[currentIndex].title),
              // Text("${DateFormat('yyyy-MM-dd').format(widget.events[currentIndex].date)}"),
              // MultiTriggerAutocomplete(
              //   optionsAlignment: OptionsAlignment.topStart,
              //   autocompleteTriggers: [
              //     AutocompleteTrigger(
              //       trigger: '@',
              //       optionsViewBuilder: (context, autocompleteQuery, controller) {
              //         return MentionAutocompleteOptions(
              //           query: autocompleteQuery.query,
              //           onMentionUserTap: (user) {
              //             final autocomplete = MultiTriggerAutocomplete.of(context);
              //             return autocomplete.acceptAutocompleteOption(user.nick!);
              //           },
              //         );
              //       },
              //     ),
              //   ],
              //   fieldViewBuilder: (context, controller, focusNode) {
              //     WidgetsBinding.instance.addPostFrameCallback((_) {
              //       ref.watch(workLogContentProvider.notifier).state = controller;
              //     });
              //
              //     return Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Container(
              //         child: FormBuilderTextField(
              //           focusNode: focusNode,
              //           controller: ref.watch(workLogContentProvider),
              //           onChanged: (text) {
              //             int cursorPos = ref.watch(workLogContentProvider).selection.baseOffset;
              //             if (cursorPos > 0) {
              //               int from = text!.lastIndexOf('@', cursorPos);
              //               if (from != -1) {
              //                 int prevCharPos = from - 1;
              //                 if (prevCharPos >= 0 && text[prevCharPos] != ' ') {
              //                   return;
              //                 }
              //
              //                 int nextSpace = text.indexOf(' ', from);
              //                 if (nextSpace == -1 || nextSpace >= cursorPos) {
              //                   String toSearch = text.substring(from + 1, cursorPos);
              //                   toSearch = toSearch.trim();
              //
              //                   if (toSearch.isNotEmpty) {
              //                     if (toSearch.length >= 1) {
              //                       ref.watch(searchStateProvider.notifier).searchQuery.add(toSearch);
              //                     }
              //                   } else {
              //                     ref.watch(searchStateProvider.notifier).getMentionRecommendList(initPage: 1);
              //                   }
              //                 }
              //               }
              //             }
              //           },
              //           scrollPhysics: const ClampingScrollPhysics(),
              //           maxLength: 500,
              //           maxLines: 6,
              //           decoration: InputDecoration(
              //               counterText: "",
              //               hintText: '산책 중 일어난 일을 메모해 보세요 . (최대 500자)\n작성한 메모는 마이페이지 산책일지에서 나만 볼 수 있습니다.',
              //               hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
              //               contentPadding: const EdgeInsets.all(16)),
              //           name: 'content',
              //           style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
              //           keyboardType: TextInputType.multiline,
              //           textAlignVertical: TextAlignVertical.center,
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ); // Replace with your actual event display widget
        },
        onPageChanged: (index) {
          setState(() {
            currentIndex = index; // <-- Update the variable here
          });
        },
      ),
    );
  }
}
