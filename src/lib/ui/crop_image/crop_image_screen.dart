import 'package:crop_your_image/crop_your_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class CropImageScreen extends ConsumerStatefulWidget {
  Uint8List uint8List;

  CropImageScreen({required this.uint8List, super.key});

  @override
  CropImageScreenState createState() => CropImageScreenState();
}

class CropImageScreenState extends ConsumerState<CropImageScreen> {
  final _controller = CropController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlackColor,
          title: Text(
            "",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              color: kWhiteColor,
              size: 40,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _controller.crop();
                // context.pop();
              },
              child: Text(
                '회원.완료'.tr(),
                style: kButton14BoldStyle.copyWith(
                  color: kPreviousPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        body: Crop(
          image: widget.uint8List,
          controller: _controller,
          baseColor: kBlackColor,
          maskColor: kBlackColor.withOpacity(0.6),
          initialSize: 0.5,
          onCropped: (image) {
            context.pop(image);
          },
          withCircleUi: true,
        ),
      ),
    );
  }
}
