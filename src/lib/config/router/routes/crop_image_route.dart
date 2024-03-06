import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/crop_image/crop_image_screen.dart';

class CropImageRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: '/cropImage',
      name: 'cropImage',
      builder: (BuildContext context, GoRouterState state) {
        Uint8List? uint8List;

        if (state.extra != null) {
          Map<dynamic, dynamic> extraMap = {};
          extraMap = state.extra! as Map<String, dynamic>;

          if (extraMap.containsKey('uint8List')) {
            uint8List = extraMap['uint8List'];
          }
        }
        return CropImageScreen(uint8List: uint8List!);
      },
    );
  }
}
