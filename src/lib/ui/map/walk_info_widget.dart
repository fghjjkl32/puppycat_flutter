import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:pet_mobile_social_flutter/providers/single_walk/single_walk_provider.dart';

class WalkInfoWidget extends ConsumerStatefulWidget {
  const WalkInfoWidget({
    super.key,
    required this.walkStateModel,
  });

  final WalkStateModel? walkStateModel;

  @override
  WalkInfoWidgetState createState() => WalkInfoWidgetState();
}

class WalkInfoWidgetState extends ConsumerState<WalkInfoWidget> {
  WalkStateModel? walkStateModel;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    walkStateModel = widget.walkStateModel;

    String walkTime = '00:00';
    if(walkStateModel != null) {
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
                  value: walkStateModel?.calorie.toStringAsFixed(2) ??'0.00',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.camera)),
              IconButton(
                  onPressed: () {
                    ref.read(singleWalkStateProvider.notifier).stopLocationCollection();
                    final mapController = ref.read(naverMapControllerStateProvider);
                    if (mapController != null) {
                      mapController.clearOverlays(type: NOverlayType.pathOverlay);
                    }
                  },
                  icon: Icon(Icons.stop)),
              IconButton(onPressed: () {}, icon: Icon(Icons.view_compact_alt_outlined)),
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
