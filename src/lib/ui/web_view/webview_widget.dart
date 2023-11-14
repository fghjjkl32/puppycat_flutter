import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/controller/webview_bridge/webview_bridge.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/web_view.dart';

class WebViewWidget extends ConsumerStatefulWidget {
  final String url;

  const WebViewWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  WebViewWidgetState createState() => WebViewWidgetState();
}

class WebViewWidgetState extends ConsumerState<WebViewWidget> {
  final List<WebViewView> webViewList = [];
  final List<InAppWebViewController> webViewControllerList = [];

  late String defaultUrl;
  int adminCount = 0;
  int lastTap = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();

    defaultUrl = widget.url;

    webViewList.add(WebViewView(
      key: GlobalKey(),
      url: defaultUrl,
      onCreateWindow: webViewOnCreateWindow,
      onWebViewCreated: webViewOnWebViewCreated,
      onCloseWindow: webViewOnCloseWindow,
    ));
  }

  void webViewOnWebViewCreated(InAppWebViewController controller) {
    webViewControllerList.add(controller);
    // registerJavascriptBridge(controller);
    controller.addJavaScriptHandler(
        handlerName: 'setPassAuthToken',
        callback: (args) {
          String? data = args.first;
          print('pass data : $data');
          if (data != null) {
            ref.read(authStateProvider.notifier).setPassAuthData(data);
            context.pop();
          } else {
            return false;
          }
          return true;
        });
  }

  void webViewOnCloseWindow(InAppWebViewController controller) {
    setState(() {
      webViewControllerList.remove(controller);
      webViewList.removeWhere((element) => element.windowId == controller.getViewId());
    });
  }

  Future<bool?> webViewOnCreateWindow(InAppWebViewController controller, CreateWindowAction createWindowAction) async {
    // print('createWindowAction.windowId ${createWindowAction.windowId}');
    // var origin = await webViewControllerList.last.getOriginalUrl();

    final webview = WebViewView(
      key: GlobalKey(),
      onCreateWindow: webViewOnCreateWindow,
      onWebViewCreated: webViewOnWebViewCreated,
      onCloseWindow: webViewOnCloseWindow,
      windowId: createWindowAction.windowId,
      url: createWindowAction.request.url.toString(),
    );

    setState(() {
      webViewList.add(webview);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () => _goBack(context),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: webViewList,
            // children: [
            //   webviewList.last,
            // ],
          ),
        ),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    final webViewController = webViewControllerList.last;
    // ignore: unnecessary_null_comparison
    if (webViewController == null) {
      return false;
    }

    final curUrl = await webViewController.getUrl();
    if (curUrl.toString().contains('error.html')) {
      return Future.value(true);
    }

    if (await webViewController.canGoBack()) {
      if (webViewControllerList.first == webViewController) {
        if (compareUrl(curUrl.toString(), defaultUrl)) {
          return Future.value(true);
        }
      }

      await webViewController.goBack();
      return Future.value(false);
    } else {
      if (webViewControllerList.first == webViewController) {
        if (!compareUrl(curUrl.toString(), defaultUrl)) {
          if (defaultTargetPlatform == TargetPlatform.android) {
            webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(defaultUrl)));
            await webViewController.clearHistory();
          }
          return Future.value(false);
        }

        return Future.value(true);
      } else {
        webViewControllerList.removeLast();
        setState(() {
          webViewList.removeLast();
        });
        return Future.value(false);
      }
    }
  }

  bool compareUrl(String url1, String url2) {
    Uri uri1 = Uri.parse(url1);
    Uri uri2 = Uri.parse(url2);

    if (uri1 == uri2) {
      return true;
    } else {
      if (uri1.path == '/' && uri2.path == '') {
        return true;
      } else if (uri2.path == '/' && uri1.path == '') {
        return true;
      } else {
        return false;
      }
    }
  }
}
