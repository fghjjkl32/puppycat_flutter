import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/select_button.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/comment_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';

enum ReportSelectEnum {
  adOrPromotion,
  adultContent,
  offensiveLanguage,
  spam,
  personalInfo,
  legalIssue,
  solicitation,
  directInput
}

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({
    required this.isComment,
    required this.contentIdx,
    super.key,
  });

  final bool isComment;
  final int contentIdx;

  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends ConsumerState<ReportScreen> {
  final List<String> reportList = [
    "광고/홍보 글이에요.",
    "음란물이에요.",
    "욕설/비방/차별/혐오적 표현이 있어요.",
    "중복/도배 글이에요.",
    "개인정보 포함(노출)된 글이에요.",
    "명예훼손/저작권을 침해하는 글이에요.",
    "금전/물품/후원을 요구하는 글이에요.",
    "직접 입력할게요.",
  ];

  @override
  void initState() {
    super.initState();
  }

  ReportSelectEnum? reportSelectStatus;

  String? directInputText = "";
  int code = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();

        return false;
      },
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            context.pop();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(
                widget.isComment ? "댓글 신고" : "게시물 신고",
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
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "어떤 점이 불편하셨나요?",
                        style: kTitle16ExtraBoldStyle.copyWith(
                            color: kTextTitleColor),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ReportSelectEnum.values.length,
                        itemBuilder: (BuildContext context, int i) {
                          return SelectButton(
                            isDirectInput: reportSelectStatus ==
                                ReportSelectEnum.directInput,
                            title: reportList[i],
                            isSelected: reportSelectStatus ==
                                ReportSelectEnum.values[i],
                            onPressed: () {
                              setState(() {
                                reportSelectStatus = ReportSelectEnum.values[i];
                              });
                              code = i + 1;
                            },
                            onTextChanged: (text) {
                              directInputText = text ?? "";
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.0.w,
                      right: 20.0.w,
                      bottom: 20.0.h,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: kNeutralColor400,
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: reportSelectStatus == null ||
                                (reportSelectStatus ==
                                        ReportSelectEnum.directInput &&
                                    directInputText!.isEmpty)
                            ? null
                            : () async {
                                final result = widget.isComment
                                    ? await ref
                                        .watch(commentStateProvider.notifier)
                                        .postCommentReport(
                                          loginMemberIdx:
                                              ref.watch(userModelProvider)!.idx,
                                          contentIdx: widget.contentIdx,
                                          reportCode: code,
                                          reason: directInputText,
                                          reportType: "comment",
                                        )
                                    : await ref
                                        .watch(feedListStateProvider.notifier)
                                        .postContentReport(
                                          loginMemberIdx:
                                              ref.watch(userModelProvider)!.idx,
                                          contentIdx: widget.contentIdx,
                                          reportCode: code,
                                          reason: directInputText,
                                          reportType: "contents",
                                        );

                                if (result.result) {
                                  // ignore: use_build_context_synchronously
                                  toast(
                                    context: context,
                                    text: '정상적으로 신고 접수가 되었습니다.',
                                    type: ToastType.purple,
                                    buttonText: "신고취소",
                                    buttonOnTap: () async {
                                      final result = widget.isComment
                                          ? await ref
                                              .watch(
                                                  commentStateProvider.notifier)
                                              .deleteCommentReport(
                                                loginMemberIdx: ref
                                                    .watch(userModelProvider)!
                                                    .idx,
                                                contentIdx: widget.contentIdx,
                                                reportType: widget.isComment
                                                    ? "comment"
                                                    : "contents",
                                              )
                                          : await ref
                                              .watch(feedListStateProvider
                                                  .notifier)
                                              .deleteContentReport(
                                                loginMemberIdx: ref
                                                    .watch(userModelProvider)!
                                                    .idx,
                                                contentIdx: widget.contentIdx,
                                                reportType: widget.isComment
                                                    ? "comment"
                                                    : "contents",
                                              );

                                      if (result.result) {
                                        toast(
                                          context: context,
                                          text: '신고 접수가 취소되었습니다.',
                                          type: ToastType.grey,
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            '신고하기',
                            style: kBody14BoldStyle.copyWith(
                                color: reportSelectStatus == null
                                    ? kTextSubTitleColor
                                    : kNeutralColor100),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
