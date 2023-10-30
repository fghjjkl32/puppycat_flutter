import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:pet_mobile_social_flutter/common/util/location/geolocator_util.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/walk_result/walk_result_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/single_walk/single_walk_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_selected_pet_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/map/bottom_drawer.dart';
import 'package:pet_mobile_social_flutter/ui/map/walk_info_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/walk_log_result_edit_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/walk_log_result_view_screen.dart';
import 'package:thumbor/thumbor.dart';

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
    widget: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12.0),
        itemCount: ref.read(walkResultStateProvider).list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalkLogResultViewScreen(
                    events: ref.read(walkResultStateProvider).list,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 200,
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: kNeutralColor100,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${ref.read(walkResultStateProvider).list[index].resultImgUrl}}").toUrl(),
                        width: 200,
                        height: 88,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              // Center(
              //   child: Text('${ref.read(walkResultStateProvider).list[index]}'),
              // ),
            ),
          );
        },
      );
    }),
  );

  @override
  void initState() {
    super.initState();
    ref.read(walkStateProvider.notifier).getTodayWalkCount().then((value) {
      setState(() {
        _walkCount = value;
      });
    });
    init();
  }

  init() async {
    await ref.read(walkResultStateProvider.notifier).getWalkResultForMap();
    print(ref.read(walkResultStateProvider).list);
    print(ref.read(walkResultStateProvider.notifier));
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

    final bool isWalking = ref.watch(walkStatusStateProvider) == WalkStatus.walking;
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
                  contentPadding: EdgeInsets.only(bottom: (drawerHeight + 34) - MediaQuery.of(context).padding.bottom),
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
                  ref.read(naverMapControllerStateProvider.notifier).state = controller;
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
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: kNeutralColor400,
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async {
                            // final currentLocationData = await Location().getLocation();
                            // ref.read(singleWalkStateProvider.notifier).startLocationCollection(currentLocationData);
                            await ref.read(walkStateProvider.notifier).startWalk().then((walkUuid) async {
                              if (walkUuid.isNotEmpty) {
                                final currentLocationData = await GeolocatorUtil.getCurrentLocation();
                                // ref.read(singleWalkStateProvider.notifier).startLocationCollection(currentLocationData);
                                ref.read(singleWalkStateProvider.notifier).startBackgroundLocation(currentLocationData);
                                final userInfo = ref.read(userInfoProvider).userModel;
                                print('start userModel $userInfo');
                                final String memberUuid = ref.read(userInfoProvider).userModel!.uuid!;
                                final selectedPetList = ref.read(walkSelectedPetStateProvider);
                                List<Map<String, dynamic>> petMap = selectedPetList.map((e) => e.toJson()).toList();

                                CookieJar cookieJar = GetIt.I<CookieJar>();
                                var cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
                                Map<String, dynamic> cookieMap = {};
                                for (var cookie in cookies) {
                                  cookieMap[cookie.name] = cookie.value;
                                }

                                FlutterBackgroundService().startService().then((isBackStarted) async {
                                  if(isBackStarted) {
                                    print('background start!!');
                                    FlutterBackgroundService().invoke("setAsForeground");
                                    FlutterBackgroundService().invoke('setData', {
                                      'memberUuid' : memberUuid,
                                      'walkUuid' : walkUuid,
                                      'cookieMap' : cookieMap,
                                      'selectedPetList' : petMap,
                                    });
                                  }
                                });
                              } else {
                                print('Error Start Walk');
                              }
                            });
                          },
                          child: Text(
                            '산책하기',
                            style: kBody14BoldStyle.copyWith(color: kNeutralColor100),
                          ),
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
