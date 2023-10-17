import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:pet_mobile_social_flutter/providers/single_walk/single_walk_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/map/bottom_drawer.dart';
import 'package:pet_mobile_social_flutter/ui/map/walk_info_widget.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({
    super.key,
    required this.appBarTitle,
  });

  final String appBarTitle;

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  double drawerHeight = 0;
  late NaverMapController mapController;
  int _walkCount = 0;

  late final drawerTool = ExampleAppBottomDrawer(
    context: context,
    onDrawerHeightChanged: (height) => setState(() => drawerHeight = height),
    rebuild: () => setState(() {}),
    // onPageDispose: () {},
    widget: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 200,
          height: 180,
          child: Center(
            child: Text('산책 일지 ${index + 1}'),
          ),
        );
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    ref.read(walkStateProvider.notifier).getTodayWalkCount().then((value) {
      setState(() {
        _walkCount = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(singleWalkStateProvider, (previous, next) async {
      if (previous == null) {
        return;
      }

      final mapController = ref.read(naverMapControllerStateProvider);
      NCameraPosition updatePosition = NCameraPosition(target: NLatLng(next.last.latitude, next.last.longitude!), zoom: 16.0);
      await mapController!.updateCamera(NCameraUpdate.withParams(
        target: updatePosition.target,
        zoom: updatePosition.zoom,
      ));

      if (next.length <= 1) {
        return;
      }
      List<NLatLng> routeList = next.map((e) => NLatLng(e.latitude, e.longitude)).toList();

      await mapController.addOverlay(NPathOverlay(id: '2', coords: routeList, color: Colors.deepPurpleAccent));
    });

    final bool isWalking = ref.watch(singleWalkStatusStateProvider) == WalkStatus.walking;
    // print('isWalking $isWalking');

    final walkStateModelList = ref.watch(singleWalkStateProvider);

    // final mapPadding =

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: FutureBuilder(
        future: Location().getLocation(),
        builder: (context, AsyncSnapshot<LocationData> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final locationData = snapshot.data;

          /// NOTE
          /// Default 좌표는 서울 시청 좌표
          final coordinate = NLatLng(locationData?.latitude ?? 37.555759, locationData?.longitude ?? 126.972939);

          return Stack(
            children: [
              NaverMap(
                options: const NaverMapViewOptions().copyWith(
                  locationButtonEnable: true,
                  contentPadding: EdgeInsets.only(bottom: (drawerHeight + 34) - MediaQuery
                      .of(context)
                      .padding
                      .bottom),
                  //TODO
                  logoAlign: NLogoAlign.leftTop,
                  scaleBarEnable: false,
                  initialCameraPosition: NCameraPosition(target: coordinate, zoom: 16),
                ),
                //, liteModeEnable: true),
                onMapReady: (controller) async {
                  print("네이버 맵 로딩됨!");
                  final locationOverlay = await controller.getLocationOverlay();
                  // locationOverlay.setAnchor(NPoint(0.5, 1));
                  // locationOverlay.setIcon(const NOverlayImage.fromAssetImage('assets/test.png'));
                  // locationOverlay.setIconSize(const Size(28.35,28.35));

                  controller.setLocationTrackingMode(NLocationTrackingMode.noFollow);

                  ///NOTE
                  ///initialCameraPosition와 동일한 좌표를 사용하는데도 불구하고 현재 위치가 가운데로 잡히지 않아서 카메라 위치를 한번 더 조정
                  NCameraPosition updatePosition = NCameraPosition(target: coordinate, zoom: 16.0);
                  await controller.updateCamera(NCameraUpdate.withParams(
                    target: updatePosition.target,
                    zoom: updatePosition.zoom,
                  ));
                  mapController = controller;
                  ref
                      .read(naverMapControllerStateProvider.notifier)
                      .state = controller;
                },
              ),
              Visibility(
                visible: !isWalking,
                child: Positioned.fill(
                  bottom: drawerHeight,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 18.0,
                              spreadRadius: 35,
                              offset: Offset(0.0, 20),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () async {
                            final currentLocationData = await Location().getLocation();
                            final petWeight = 20.0; //TODO
                            ref.read(singleWalkStateProvider.notifier).startLocationCollection(currentLocationData, petWeight);
                            await ref.read(walkStateProvider.notifier).startWalk();
                            // ref.read(walkStateProvider.notifier).testLocation();
                          },
                          child: const Text('산책하기'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isWalking && _walkCount > 0,
                child: Positioned.fill(
                  bottom: drawerHeight + 57,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20.0), // 모든 모서리를 둥글게 만듭니다.
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 12, 20, 12),
                          child: Text('오늘 아이들과 $_walkCount번째 산책을 다녀왔어요!'),
                        ),
                      ),
                    ),
                  ),
                ),
                // FutureBuilder(
                //   future: ref.read(singleWalkStateProvider.notifier).getTodayWalkCount(),
                //   builder: (context, AsyncSnapshot<int> snapshot) {
                //     if(snapshot.hasError) {
                //       return const SizedBox.shrink();
                //     }
                //
                //     if(!snapshot.hasData) {
                //       return const SizedBox.shrink();
                //     }
                //
                //     if(snapshot.data == 0) {
                //       return const SizedBox.shrink();
                //     }
                //
                //     return Positioned.fill(
                //       bottom: drawerHeight + 57,
                //       child: Align(
                //         alignment: Alignment.bottomCenter,
                //         child: Padding(
                //           padding: const EdgeInsets.all(12.0),
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: Colors.blue,
                //               borderRadius: BorderRadius.circular(20.0), // 모든 모서리를 둥글게 만듭니다.
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.fromLTRB(20.0, 12, 20, 12),
                //               child: Text('오늘 아이들과 ${snapshot.data}번째 산책을 다녀왔어요!'),
                //             ),
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ),
              Visibility(
                visible: !isWalking,
                child: drawerTool.bottomDrawer,
              ),
              Visibility(
                visible: isWalking,
                child: Positioned.fill(
                  bottom: 10,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 24.0),
                      child: WalkInfoWidget(walkStateModel: walkStateModelList.isEmpty ? null : walkStateModelList.last),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
