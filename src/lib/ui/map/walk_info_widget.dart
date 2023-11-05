import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:pet_mobile_social_flutter/providers/single_walk/single_walk_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_selected_pet_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/write_walk_log_screen.dart';

class WalkInfoWidget extends ConsumerStatefulWidget {
  const WalkInfoWidget({
    super.key,
    required this.walkStateModel,
  });

  final WalkStateModel? walkStateModel;

  @override
  WalkInfoWidgetState createState() => WalkInfoWidgetState();
}

class WalkInfoWidgetState extends ConsumerState<WalkInfoWidget> with TickerProviderStateMixin {
  WalkStateModel? walkStateModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    walkStateModel = widget.walkStateModel;

    String walkTime = '00:00';
    if (walkStateModel != null) {
      double walkMinutes = (walkStateModel!.walkTime / 60000);
      walkTime = '${(walkMinutes / 60).floor().toString().padLeft(2, '0')}:${(walkMinutes % 60).floor().toString().padLeft(2, '0')}';
    }

    return Container(
      height: 145,
      padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WalkInfoItemWidget(
                  title: '시간',
                  value: walkTime,
                ),
                const VerticalDivider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                WalkInfoItemWidget(
                  title: '걸음',
                  value: walkStateModel?.walkCount.toString() ?? '0',
                ),
                const VerticalDivider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                WalkInfoItemWidget(
                  title: 'km',
                  value: walkStateModel?.distance.toStringAsFixed(2) ?? '0.00',
                ),
                const VerticalDivider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                WalkInfoItemWidget(
                  title: 'kacal',
                  value: walkStateModel?.getPetCalorie(ref.read(walkSelectedPetStateProvider.notifier).getFirstRegPet().uuid ?? '').toStringAsFixed(2) ?? '0.00',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();

                  final pickedFile = await picker.pickImage(source: ImageSource.camera);

                  if (pickedFile != null) {
                    await ImageGallerySaver.saveFile(pickedFile.path);
                  }
                },
                child: Image.asset(
                  'assets/image/character/character_02_button_camera.png',
                  width: 48,
                  height: 48,
                ),
              ),
              InkWell(
                onTap: () async {
                  print('stop buttion!!!!!!!');
                  // final mapController = ref.read(naverMapControllerStateProvider);
                  // final walkStateList = ref.read(singleWalkStateProvider);
                  // File walkPathImgFile;
                  FlutterBackgroundService().invoke("stopService");
                  ref.read(singleWalkStateProvider.notifier).stopBackgroundLocation();

                  final walkUuid = await ref.read(walkStateProvider.notifier).stopWalk();
                  if (walkUuid.isNotEmpty) {
                    if (context.mounted) {
                      context.push('/writeWalkLog');
                    }
                  }
                },
                child: Image.asset(
                  'assets/image/character/character_02_button_stop.png',
                  width: 48,
                  height: 48,
                ),
              ),
              InkWell(
                onTap: () {
                  if (GoRouter.of(context).location() == "/home") {
                    context.push('/map');
                  } else {
                    ref.read(isNavigatedFromMapProvider.notifier).state = true;
                    context.pushReplacement('/home');
                  }
                },
                child: GoRouter.of(context).location() == "/home"
                    ? Image.asset(
                        'assets/image/character/character_03_walking_walk_icon.png',
                        width: 48,
                        height: 48,
                      )
                    : Image.asset(
                        'assets/image/character/character_03_walking_walk_icon.png',
                        width: 48,
                        height: 48,
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class WalkInfoItemWidget extends StatelessWidget {
  const WalkInfoItemWidget({super.key, required this.title, required this.value});

  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value),
        Text(title),
      ],
    );
  }
}
