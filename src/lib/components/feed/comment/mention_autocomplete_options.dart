import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

class MentionAutocompleteOptions extends ConsumerStatefulWidget {
  const MentionAutocompleteOptions({
    Key? key,
    required this.query,
    required this.onMentionUserTap,
  }) : super(key: key);

  final String query;
  final ValueSetter<SearchData> onMentionUserTap;

  @override
  MentionAutocompleteOptionsState createState() => MentionAutocompleteOptionsState();
}

class MentionAutocompleteOptionsState extends ConsumerState<MentionAutocompleteOptions> {
  int mentionOldLength = 0;
  ScrollController mentionController = ScrollController();

  @override
  void initState() {
    mentionController.addListener(_commentScrollListener);

    super.initState();
  }

  void _commentScrollListener() {
    if (mentionController.position.pixels > mentionController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (mentionOldLength == ref.read(searchStateProvider).list.length) {
        ref.read(searchStateProvider.notifier).loadMoreMentionSearchList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(searchStateProvider).list;

    mentionOldLength = users.length ?? 0;

    if (users.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   color: const Color(0xFFF7F7F8),
          //   child: ListTile(
          //     dense: true,
          //     horizontalTitleGap: 0,
          //     title: Text("Users matching '${widget.query}'"),
          //   ),
          // ),
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
            child: ListView.separated(
              controller: mentionController,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: users.length,
              separatorBuilder: (_, __) => Container(),
              itemBuilder: (context, i) {
                final user = users[i];
                return ListTile(
                  // shape: Border(
                  //   bottom: BorderSide(color: kWhiteColor, width: 1),
                  // ),
                  tileColor: kPreviousNeutralColor100,
                  dense: true,
                  leading: user.profileImgUrl == null || user.profileImgUrl == ""
                      ? WidgetMask(
                          blendMode: BlendMode.srcATop,
                          childSaveLayer: true,
                          mask: Center(
                            child: Icon(
                              Puppycat_social.icon_profile_small,
                              size: 42,
                              color: kPreviousNeutralColor400,
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/image/feed/image/squircle.svg',
                            height: 42,
                            fit: BoxFit.fill,
                          ),
                        )
                      : WidgetMask(
                          blendMode: BlendMode.srcATop,
                          childSaveLayer: true,
                          mask: Center(
                            child: Image.network(
                              Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${user.profileImgUrl!}").toUrl(),
                              height: 42,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/image/feed/image/squircle.svg',
                            height: 42,
                            fit: BoxFit.fill,
                          ),
                        ),
                  title: Text(user.nick ?? ''),
                  subtitle: user.intro == null || user.intro == "" ? Text('소개 글이 없어요.') : Text('${user.intro}'),
                  onTap: () => widget.onMentionUserTap(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
