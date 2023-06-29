import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';

void registerJavascriptBridge(InAppWebViewController controller) {
  // controller.addJavaScriptHandler(
  //     handlerName: 'setPassAuthToken',
  //     callback: (args) {
  //       String? data = args.first;
  //
  //       if (data != null) {
  //         // ref.read(authTokenProvider.notifier).state = data;
  //       } else {
  //         return false;
  //       }
  //       return true;
  //     });
}
