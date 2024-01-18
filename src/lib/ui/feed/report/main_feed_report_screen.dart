import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/report/report_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/select_button.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({
    required this.isComment,
    required this.contentIdx,
    required this.onTapReport,
    super.key,
  });

  final bool isComment;
  final int contentIdx;

  final Function onTapReport;

  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends ConsumerState<ReportScreen> {
  @override
  void initState() {
    super.initState();

    widget.isComment ? ref.read(reportStateProvider.notifier).getInitCommentReportList() : ref.read(reportStateProvider.notifier).getInitContentReportList();
  }

  String? directInputText = "";
  int code = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.isComment ? "댓글 신고" : "피드 신고",
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
        body: Consumer(builder: (context, ref, child) {
          final reportState = ref.watch(reportStateProvider);
          final reportLists = reportState.list;
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "어떤 점이 불편하신가요?",
                      style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: reportLists.length,
                      itemBuilder: (BuildContext context, int i) {
                        return SelectButton(
                          isDirectInput: reportLists[i].reportCode! == 8,
                          title: reportLists[i].name!,
                          isSelected: code == reportLists[i].reportCode!,
                          onPressed: () {
                            setState(() {
                              code = reportLists[i].reportCode!;
                            });
                          },
                          onTextChanged: (text) {
                            setState(() {
                              directInputText = text ?? "";
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: kPreviousNeutralColor400,
                      backgroundColor: kPreviousPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: code == 0 || (code == 8 && directInputText!.isEmpty)
                        ? null
                        : () async {
                            final result = widget.isComment
                                ? await ref.watch(commentListStateProvider.notifier).postCommentReport(
                                      contentIdx: widget.contentIdx,
                                      reportCode: code,
                                      reason: directInputText,
                                      reportType: "comment",
                                    )
                                : await ref.watch(feedListStateProvider.notifier).postContentReport(
                                      contentIdx: widget.contentIdx,
                                      reportCode: code,
                                      reason: directInputText,
                                      reportType: "contents",
                                    );

                            if (result.result && mounted) {
                              context.pop();

                              widget.onTapReport();

                              // toast(
                              //   context: context,
                              //   text: '정상적으로 신고 접수가 되었습니다.',
                              //   type: ToastType.purple,
                              //   buttonText: "신고취소",
                              //   buttonOnTap: () async {
                              //     final result = widget.isComment
                              //         ? await ref.read(commentListStateProvider.notifier).deleteCommentReport(
                              //               loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                              //               contentIdx: widget.contentIdx,
                              //               reportType: widget.isComment ? "comment" : "contents",
                              //             )
                              //         : await ref.read(feedListStateProvider.notifier).deleteContentReport(
                              //               loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                              //               contentIdx: widget.contentIdx,
                              //               reportType: widget.isComment ? "comment" : "contents",
                              //             );
                              //
                              //     if (result.result && mounted) {
                              //       toast(
                              //         context: context,
                              //         text: '신고 접수가 취소되었습니다.',
                              //         type: ToastType.grey,
                              //       );
                              //     }
                              //   },
                              // );
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        '신고하기',
                        style: kBody14BoldStyle.copyWith(color: code == 0 || (code == 8 && directInputText!.isEmpty) ? kPreviousTextBodyColor : kPreviousNeutralColor100),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
