import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/search/hashtag/feed_search_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_screen.dart';

class SearchRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SearchScreen();
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => build(context, state),
      routes: [
        HashtagRoute().createRoute(),
      ],
    );
  }
}

class HashtagRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'hashtag/:searchWord/:oldMemberUuid',
      name: 'hashtag/:searchWord/:oldMemberUuid',
      builder: (BuildContext context, GoRouterState state) {
        final searchWord = state.pathParameters['searchWord']!;
        final oldMemberUuid = state.pathParameters['oldMemberUuid']!;
        return FeedSearchListScreen(
          searchWord: searchWord,
          oldMemberUuid: oldMemberUuid,
        );
      },
    );
  }
}
