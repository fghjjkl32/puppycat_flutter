import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/webview_widget.dart';

class WebviewRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final url = Uri.decodeComponent(state.pathParameters['url']!);
    return WebViewWidget(url: url);
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/webview/:url',
      name: 'webview',
      builder: (context, state) => build(context, state),
    );
  }
}
