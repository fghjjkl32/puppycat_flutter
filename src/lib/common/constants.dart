part of 'common.dart';

final hashtagListProvider = StateProvider<List<String>>((ref) => []);

final mentionListProvider = StateProvider<List<MentionListData>>((ref) => []);

// const int APP_BUILD_NUMBER = 12;

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> contextProvider = GlobalKey<NavigatorState>();
final GlobalKey<ChatRoomScreenState> chatScreenKey = GlobalKey<ChatRoomScreenState>();
final GlobalKey rowKey = GlobalKey();

String firstInstallTime = "";
// String lastestBuildVersion = "";
bool isAppLinkHandled = false;

Widget getProfileAvatar(
  String avatarUrl, [
  double width = 48,
  double height = 48,
]) {
  return WidgetMask(
    blendMode: BlendMode.srcATop,
    childSaveLayer: true,
    mask: Center(
      child: Image.network(
        thumborUrl(avatarUrl),
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, exception, stackTrace) {
          return const Icon(
            Puppycat_social.icon_profile_small,
            size: 30,
            color: kPreviousNeutralColor400,
          );
        },
      ),
    ),
    child: SvgPicture.asset(
      'assets/image/feed/image/squircle.svg',
      width: width,
      height: height,
      fit: BoxFit.fill,
    ),
  );
}

Widget getProfileAvatarWithBadge(
  String avatarUrl, [
  bool isBadge = false,
  double width = 48,
  double height = 48,
]) {
  return Stack(
    children: [
      getProfileAvatar(avatarUrl, width, height),
      Visibility(
          visible: isBadge,
          child: Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              'assets/image/feed/icon/small_size/icon_special.png',
              height: 13,
            ),
          )),
    ],
  );
}

Widget getSquircleImage(
  String avatarUrl, [
  double width = 48,
  double height = 48,
  Color colorFilter = Colors.transparent,
]) {
  return WidgetMask(
    blendMode: BlendMode.srcATop,
    childSaveLayer: true,
    mask: Center(
      child: Stack(
        children: [
          Image.network(
            thumborUrl(avatarUrl),
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, exception, stackTrace) {
              return Icon(
                Puppycat_social.icon_profile_small,
                size: 30,
                color: colorFilter == kPreviousPrimaryColor ? colorFilter : kPreviousNeutralColor400,
              );
            },
          ),
          Visibility(
            visible: colorFilter == kPreviousPrimaryColor,
            child: const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.check,
                  color: kPreviousNeutralColor100,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    child: SvgPicture.asset(
      'assets/image/feed/image/squircle.svg',
      width: width,
      height: height,
      fit: BoxFit.fill,
      colorFilter: colorFilter == kPreviousPrimaryColor ? ColorFilter.mode(colorFilter.withAlpha(50), BlendMode.srcATop) : null,
    ),
  );
}

final ContentResponseModel contentNullResponseModel = ContentResponseModel(
  result: false,
  code: "",
  data: const ContentDataListModel(
    list: [],
    params: ParamsModel(
      memberUuid: '',
      pagination: Pagination(
        startPage: 0,
        limitStart: 0,
        totalPageCount: 0,
        existNextPage: false,
        endPage: 0,
        existPrevPage: false,
        totalRecordCount: 0,
      ),
      offset: 0,
      limit: 0,
      pageSize: 0,
      page: 0,
      recordSize: 0,
    ),
  ),
  message: "",
);

final FeedResponseModel feedNullResponseModel = FeedResponseModel(
  result: false,
  code: "",
  data: const FeedDataListModel(
    list: [],
    params: ParamsModel(
      memberUuid: '',
      pagination: Pagination(
        startPage: 0,
        limitStart: 0,
        totalPageCount: 0,
        existNextPage: false,
        endPage: 0,
        existPrevPage: false,
        totalRecordCount: 0,
      ),
      offset: 0,
      limit: 0,
      pageSize: 0,
      page: 0,
      recordSize: 0,
    ),
  ),
  message: "",
);
