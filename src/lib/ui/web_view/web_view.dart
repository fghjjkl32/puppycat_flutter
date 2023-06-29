import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pet_mobile_social_flutter/controller/channel/channel_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebViewView extends StatefulWidget {
  final String? url;
  final int? windowId;
  final Future<bool?> Function(InAppWebViewController controller, CreateWindowAction createWindowAction)? onCreateWindow;
  final void Function(InAppWebViewController controller)? onCloseWindow;
  final void Function(InAppWebViewController controller)? onWebViewCreated;
  final PullToRefreshController? pullToRefreshController;
  final InAppWebViewSettings? settings;

  const WebViewView({
    Key? key,
    this.url = 'about:blank',
    this.windowId,
    this.onCreateWindow,
    this.onWebViewCreated,
    this.onCloseWindow,
    this.pullToRefreshController,
    this.settings,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WebViewViewState createState() => _WebViewViewState();
}

class _WebViewViewState extends State<WebViewView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  InAppWebViewController? get controller => webViewController;

  late InAppWebViewSettings settings;

  PullToRefreshController? pullToRefreshController;

  bool isErrorVisible = true;
  bool isErrorState = false;
  bool isOpenedPopup = false;

  // Map<String, String> tempHeaders = {};
  // late String? popupReferer;

  // Set<String>? allowList = {
  //   '*',
  // };

  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    webViewController = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    //   await checkNetwork();
    // });

    if (widget.settings == null) {
      settings = InAppWebViewSettings(
        // useShouldOverrideUrlLoading: true,
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
        supportMultipleWindows: true,
        transparentBackground: true,
        databaseEnabled: true,
        domStorageEnabled: true,
        useShouldInterceptRequest: true,
        // requestedWithHeaderOriginAllowList: allowList,
        resourceCustomSchemes: ['intent'],
        // requestedWithHeaderMode: RequestedWithHeaderMode.NO_HEADER,
      );
    } else {
      settings = widget.settings!;
    }

    if (widget.pullToRefreshController == null) {
      pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(
          color: Colors.blue,
        ),
        onRefresh: () async {
          loadRefreshUrl();
        },
      );
    } else {
      pullToRefreshController = widget.pullToRefreshController;
    }
  }

  loadRefreshUrl() async {
    isErrorState = false;
    isOpenedPopup = false;

    if (defaultTargetPlatform == TargetPlatform.android) {
      webViewController?.reload();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
    }
  }

  // Future checkNetwork() async {
  //   if (isOpenedPopup) {
  //     return;
  //   }
  //
  //   await ConnectivityUtil.checkConnectivity().then((value) async {
  //     if (!value) {
  //       pullToRefreshController?.endRefreshing();
  //       webViewController?.stopLoading();
  //       setState(() {
  //         isErrorVisible = true;
  //       });
  //       await showReloadDialog();
  //     }
  //   });
  // }

  // Future showReloadDialog() async {
  //   if (isOpenedPopup) {
  //     return;
  //   }
  //
  //   isOpenedPopup = true;
  //
  //   await reloadDialog(
  //       context: context,
  //       onTap2: () {
  //         Navigator.pop(context, false);
  //       }).then((value) => loadRefreshUrl());
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          // key: GlobalKey(), //widget.windowId == null ? webViewKey : null,
          windowId: widget.windowId,
          initialUrlRequest: URLRequest(url: WebUri(widget.url ?? '')),
          initialSettings: settings,
          pullToRefreshController: pullToRefreshController,
          shouldInterceptRequest: (controller, request) async {
              var uri = request.url!;
              String finalUrl = uri.toString();

              if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                await controller.stopLoading();

                if (Platform.isAndroid) {
                  // Android는 Native(Kotlin)로 URL을 전달해 Intent 처리 후 리턴
                  await ChannelController.getAppUrl(uri.toString()).then((value) async {
                    finalUrl = value; // 앱이 설치되었을 경우
                  });

                  try {
                    await launchUrlString(finalUrl);
                  } catch (e) {
                    // URL 실행 불가 시, 앱 미설치로 판단하여 마켓 URL 실행
                    finalUrl = await ChannelController.getMarketUrl(uri.toString());
                    launchUrlString(finalUrl);
                  }
                } else if (Platform.isIOS) {
                  launchUrlString(finalUrl);
                }

                return null;
              }
          },
          onLoadResourceWithCustomScheme: (controller, request) async {
            await controller.stopLoading();
          },
          onWebViewCreated: (controller) {
            if (widget.onWebViewCreated != null) {
              widget.onWebViewCreated!(controller);
            }
            webViewController = controller;
          },
          onLoadStart: (controller, url) async {
            // await checkNetwork();
          },
          onLoadStop: (controller, url) async {
            pullToRefreshController?.endRefreshing();
          },
          onPageCommitVisible: (controller, url) {
            setState(() {
              if (isErrorState) {
                isErrorVisible = true;
              } else {
                isErrorVisible = false;
              }
            });
          },
          onReceivedError: (controller, request, error) async {
            pullToRefreshController?.endRefreshing();

            var isForMainFrame = request.isForMainFrame ?? false;

            if (!isForMainFrame || (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && error.type == WebResourceErrorType.CANCELLED)) {
              return;
            }

            isErrorState = true;
          },
          onProgressChanged: (controller, progress) async {
            if (progress == 100) {
              pullToRefreshController?.endRefreshing();
            }
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {},
          onConsoleMessage: (controller, consoleMessage) {
            debugPrint("consoleMessage : $consoleMessage");
          },
          onCreateWindow: (controller, createWindowRequest) async {
            if (widget.onCreateWindow != null) {
              widget.onCreateWindow!(controller, createWindowRequest);
            }
            // webviewOnCreateWindow(controller, createWindowRequest);
            return true;
          },
          onCloseWindow: (controller) {
            if (widget.onCloseWindow != null) {
              print('aaa');
              isErrorVisible = false;
              widget.onCloseWindow!(controller);
            }
          },
        ),
        Visibility(
          visible: isErrorVisible,
          child: Positioned.fill(
            child: Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
