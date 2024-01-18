import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_helper_provider.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_screen.dart';
import 'package:widget_mask/widget_mask.dart';

class HashTagItemWidget extends ConsumerStatefulWidget {
  const HashTagItemWidget({
    required this.hashTag,
    required this.hashTagCnt,
    Key? key,
  }) : super(key: key);

  final String hashTag;
  final String hashTagCnt;

  @override
  HashTagItemWidgetState createState() => HashTagItemWidgetState();
}

class HashTagItemWidgetState extends ConsumerState<HashTagItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final dbHelper = ref.read(dbHelperProvider);
        final hashtag = SearchesCompanion(
          name: Value(widget.hashTag),
          content: const Value("hashtag"),
          created: Value(DateTime.now()),
        );

        await dbHelper.insertSearch(hashtag);

        ref.refresh(searchProvider);

        context.push("/search/hashtag/${widget.hashTag}/0");
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 8, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: WidgetMask(
                    blendMode: BlendMode.srcATop,
                    childSaveLayer: true,
                    mask: Center(
                      child: Image.asset(
                        'assets/image/search/icon/icon_tag_large.png',
                        height: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/image/feed/image/squircle.svg',
                      height: 32,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hashTag,
                      style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${widget.hashTagCnt}+",
                      style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
