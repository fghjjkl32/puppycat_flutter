import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geocoding/geocoding.dart';

class KpostalView extends StatefulWidget {
  static const String routeName = '/kpostal';

  /// AppBar's title
  ///
  /// 앱바 타이틀
  final String title;

  /// AppBar's background color
  ///
  /// 앱바 배경색
  final Color appBarColor;

  /// AppBar's contents color
  ///
  /// 앱바 아이콘, 글자 색상
  final Color titleColor;

  /// this callback function is called when user selects addresss.
  ///
  /// 유저가 주소를 선택했을 때 호출됩니다.
  final Function(Kpostal result)? callback;

  /// build custom AppBar.
  ///
  /// 커스텀 앱바를 추가할 수 있습니다. 추가할 경우 다른 관련 속성은 무시됩니다.
  final PreferredSizeWidget? appBar;

  /// if [userLocalServer] is true, the search page is running on localhost. Default is false.
  ///
  /// [userLocalServer] 값이 ture면, 검색 페이지를 로컬 서버에서 동작시킵니다.
  /// 기본적으로 연결된 웹페이지에 문제가 생기더라도 작동 가능합니다.
  final bool useLocalServer;

  /// Localhost port number. Default is 8080.
  ///
  /// 로컬 서버 포트. 기본값은 8080
  final int localPort;

  /// 웹뷰 로딩 시 인디케이터 색상
  final Color loadingColor;

  /// 웹뷰 로딩 시 표시할 커스텀 위젯
  ///
  /// 해당 옵션 사용 시, 기존 인디케이터를 대체하며, [loadingColor] 옵션은 무시됩니다.
  final Widget? onLoading;

  /// 카카오 API를 통한 경위도 좌표 지오코딩 사용 여부
  final bool useKakaoGeocoder;

  /// [kakaoKey] 설정 시, [kakaoLatitude], [kakaoLongitude] 값을 받을 수 있습니다.
  ///
  /// `developers.kakao.com` 에서 발급받은 유효한 자바스크립트 키를 사용하세요.
  ///
  /// 플랫폼 설정에서 허용 도메인도 추가해야 합니다.
  /// ex) `http://localhost:8080`, `https://tykann.github.io`
  final String kakaoKey;

  KpostalView({
    Key? key,
    this.title = '주소검색',
    this.appBarColor = Colors.white,
    this.titleColor = Colors.black,
    this.appBar,
    this.callback,
    this.useLocalServer = false,
    this.localPort = 8080,
    this.loadingColor = Colors.blue,
    this.onLoading,
    this.kakaoKey = '',
  })  : assert(1024 <= localPort && localPort <= 49151, 'localPort is out of range. It should be from 1024 to 49151(Range of Registered Port)'),
        useKakaoGeocoder = (kakaoKey != ''),
        super(key: key);

  @override
  _KpostalViewState createState() => _KpostalViewState();
}

class _KpostalViewState extends State<KpostalView> {
  InAppLocalhostServer? _localhost;

  bool initLoadComplete = false;
  bool isLocalhostOn = false;

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.useLocalServer) {
      _localhost = InAppLocalhostServer(port: widget.localPort);
      _localhost!.start().then((_) {
        setState(() {
          isLocalhostOn = true;
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.useLocalServer) _localhost?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ??
          AppBar(
            backgroundColor: widget.appBarColor,
            title: Text(
              widget.title,
              style: TextStyle(
                color: widget.titleColor,
              ),
            ),
            iconTheme: IconThemeData().copyWith(color: widget.titleColor),
          ),
      body: Stack(
        children: [
          _buildWebView(),
          initLoadComplete
              ? const SizedBox.shrink()
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: widget.onLoading ?? CircularProgressIndicator(color: widget.loadingColor),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildWebView() {
    String _initialUrl = widget.useLocalServer ? 'http://localhost:${widget.localPort}/lib/common/web/kakao_postcode.html' : 'https://tykann.github.io/kpostal/assets/kakao_postcode.html';

    String _queryParams = '?key=${widget.kakaoKey}&enableKakao=${widget.useKakaoGeocoder}';

    if (widget.useLocalServer && !this.isLocalhostOn) {
      return Center(child: CircularProgressIndicator());
    }

    return InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
        android: AndroidInAppWebViewOptions(useHybridComposition: true),
      ),
      onWebViewCreated: (controller) async {
        // 안드로이드는 롤리팝 버전 이상 빌드에서만 작동 유의
        // WEB_MESSAGE_LISTENER 지원 여부 확인
        if (!Platform.isAndroid || await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.WEB_MESSAGE_LISTENER)) {
          await controller.addWebMessageListener(
            WebMessageListener(
              jsObjectName: "onComplete",
              allowedOriginRules: Set.from(["*"]),
              onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) => handleMessage(message?.toJson().toString()),
            ),
          );
        } else {
          controller.addJavaScriptHandler(
            handlerName: 'onComplete',
            callback: (args) => handleMessage(args[0]),
          );
        }

        await controller.loadUrl(
          urlRequest: URLRequest(
            url: WebUri(_initialUrl + _queryParams),
            headers: {},
          ),
        );
      },
      onLoadStop: (_, __) {
        setState(() {
          initLoadComplete = true;
        });
      },
    );
  }

  handleMessage(String? message) async {
    try {
      if (message != null) {
        Kpostal result = Kpostal.fromJson(jsonDecode(message));

        Location? _latLng = await result.latLng;

        if (_latLng != null) {
          result.latitude = _latLng.latitude;
          result.longitude = _latLng.longitude;
        }
        if (widget.callback != null) {
          widget.callback!(result);
        }

        Navigator.pop(context, result);
      } else {
        throw 'fail to load message : message is null';
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }
}

class Kpostal {
  /// 국가기초구역번호. 2015년 8월 1일부터 시행된 새 우편번호.
  final String postCode;

  /// 기본 주소
  final String address;

  /// 기본 영문 주소
  final String addressEng;

  /// 도로명 주소
  final String roadAddress;

  /// 영문 도로명 주소
  final String roadAddressEng;

  /// 지번 주소
  final String jibunAddress;

  /// 영문 지번 주소
  final String jibunAddressEng;

  /// 건물관리번호
  final String buildingCode;

  /// 건물명
  final String buildingName;

  /// 공동주택 여부(Y/N)
  final String apartment;

  /// 검색된 기본 주소 타입: R(도로명), J(지번)
  final String addressType;

  /// 도/시 이름
  final String sido;

  /// 영문 도/시 이름
  final String sidoEng;

  /// 시/군/구 이름
  final String sigungu;

  /// 영문 시/군/구 이름
  final String sigunguEng;

  /// 시/군/구 코드
  final String sigunguCode;

  /// 도로명 코드, 7자리로 구성된 도로명 코드입니다. 추후 7자리 이상으로 늘어날 수 있습니다.
  final String roadnameCode;

  /// 법정동/법정리 코드
  final String bcode;

  /// 도로명 값, 검색 결과 중 선택한 도로명주소의 "도로명" 값이 들어갑니다.(건물번호 제외)
  final String roadname;

  /// 도로명 값, 검색 결과 중 선택한 도로명주소의 "도로명의 영문" 값이 들어갑니다.(건물번호 제외)
  final String roadnameEng;

  /// 법정동/법정리 이름
  final String bname;

  /// 영문 법정동/법정리 이름
  final String bnameEng;

  /// 법정리의 읍/면 이름
  final String bname1;

  /// 사용자가 입력한 검색어
  final String query;

  /// 검색 결과에서 사용자가 선택한 주소의 타입
  final String userSelectedType;

  /// 검색 결과에서 사용자가 선택한 주소의 언어 타입: K(한글주소), E(영문주소)
  final String userLanguageType;

  /// 위도(플랫폼 geocoding)
  late double? latitude;

  /// 경도(플랫폼 geocoding)
  late double? longitude;

  /// 위도(카카오 geocoding)
  final double? kakaoLatitude;

  /// 경도(카카오 geocoding)
  final double? kakaoLongitude;

  Kpostal({
    required this.postCode,
    required this.address,
    required this.addressEng,
    required this.roadAddress,
    required this.roadAddressEng,
    required this.jibunAddress,
    required this.jibunAddressEng,
    required this.buildingCode,
    required this.buildingName,
    required this.apartment,
    required this.addressType,
    required this.sido,
    required this.sidoEng,
    required this.sigungu,
    required this.sigunguEng,
    required this.sigunguCode,
    required this.roadnameCode,
    required this.roadname,
    required this.roadnameEng,
    required this.bcode,
    required this.bname,
    required this.bnameEng,
    required this.query,
    required this.userSelectedType,
    required this.userLanguageType,
    required this.bname1,
    this.latitude,
    this.longitude,
    this.kakaoLatitude,
    this.kakaoLongitude,
  });

  factory Kpostal.fromJson(Map json) => Kpostal(
        postCode: json[KpostalConst.postCode] as String,
        address: json[KpostalConst.address] as String,
        addressEng: json[KpostalConst.addressEng] as String,
        roadAddress: json[KpostalConst.roadAddress] as String,
        roadAddressEng: json[KpostalConst.roadAddressEng] as String,
        jibunAddress: (json[KpostalConst.jibunAddress] as String).isNotEmpty ? json[KpostalConst.jibunAddress] as String : json[KpostalConst.autoJibunAddress] as String,
        jibunAddressEng: (json[KpostalConst.jibunAddressEng] as String).isNotEmpty ? json[KpostalConst.jibunAddressEng] as String : json[KpostalConst.autoJibunAddressEng] as String,
        buildingCode: json[KpostalConst.buildingCode] as String,
        buildingName: json[KpostalConst.buildingName] as String,
        apartment: json[KpostalConst.apartment] as String,
        addressType: json[KpostalConst.addressType] as String,
        sido: json[KpostalConst.sido] as String,
        sidoEng: json[KpostalConst.sidoEng] as String,
        sigungu: json[KpostalConst.sigungu] as String,
        sigunguEng: json[KpostalConst.sigunguEng] as String,
        sigunguCode: json[KpostalConst.sigunguCode] as String,
        roadnameCode: json[KpostalConst.roadnameCode] as String,
        roadname: json[KpostalConst.roadname] as String,
        roadnameEng: json[KpostalConst.roadnameEng] as String,
        bcode: json[KpostalConst.bcode] as String,
        bname: json[KpostalConst.bname] as String,
        bname1: json[KpostalConst.bname1] as String,
        bnameEng: json[KpostalConst.bnameEng] as String,
        query: json[KpostalConst.query] as String,
        userSelectedType: json[KpostalConst.userSelectedType] as String,
        userLanguageType: json[KpostalConst.userLanguageType] as String,
        kakaoLatitude: double.tryParse(json[KpostalConst.kakaoLatitude] ?? ''),
        kakaoLongitude: double.tryParse(json[KpostalConst.kakaoLongitude] ?? ''),
      );

  @override
  String toString() {
    return "우편번호: $postCode, 주소: $address, 경위도: N$latitude° E$longitude°";
  }

  /// 유저가 화면에서 선택한 주소를 그대로 return합니다.
  String get userSelectedAddress {
    if (this.userSelectedType == 'J') {
      if (this.userLanguageType == 'E') return this.jibunAddressEng;
      return this.jibunAddress;
    }
    if (this.userLanguageType == 'E') return this.roadAddressEng;
    return this.roadAddress;
  }

  Future<List<Location>> searchLocation(String address) async {
    try {
      final List<Location> result = await locationFromAddress(address, localeIdentifier: KpostalConst.localeKo);
      log('LatLng Found from "$address"', name: KpostalConst.packageName);
      return result;
    }
    // 경위도 조회 결과가 없는 경우
    on NoResultFoundException {
      log('LatLng NotFound from "$address"', name: KpostalConst.packageName);
      return <Location>[];
    } catch (_) {
      return <Location>[];
    }
  }

  Future<Location?> get latLng async {
    try {
      final List<Location> fromEngAddress = await searchLocation(addressEng);
      if (fromEngAddress.isNotEmpty) {
        return fromEngAddress.last;
      }
      final List<Location> fromAddress = await searchLocation(address);
      return fromAddress.last;
    } on StateError {
      log('Location is not found from geocoding', name: KpostalConst.packageName);
      return null;
    }
  }
}

class KpostalConst {
  KpostalConst._();

  static const String packageName = 'Kpostal';

  static const String localeKo = 'ko_KR';
  static const String localeUs = 'en_US';

  static const String postCode = 'zonecode';
  static const String address = 'address';
  static const String addressEng = 'addressEnglish';
  static const String roadAddress = 'roadAddress';
  static const String roadAddressEng = 'roadAddressEnglish';
  static const String jibunAddress = 'jibunAddress';
  static const String jibunAddressEng = 'jibunAddressEnglish';
  static const String autoJibunAddress = 'autoJibunAddress';
  static const String autoJibunAddressEng = 'autoJibunAddressEnglish';
  static const String buildingCode = 'buildingCode';
  static const String buildingName = 'buildingName';
  static const String apartment = 'apartment';
  static const String addressType = 'addressType';
  static const String sido = 'sido';
  static const String sidoEng = 'sidoEnglish';
  static const String sigungu = 'sigungu';
  static const String sigunguEng = 'sigunguEnglish';
  static const String sigunguCode = 'sigunguCode';
  static const String roadnameCode = 'roadnameCode';
  static const String roadname = 'roadname';
  static const String roadnameEng = 'roadnameEnglish';
  static const String bcode = 'bcode';
  static const String bname = 'bname';
  static const String bname1 = 'bname1';
  static const String bnameEng = 'bnameEnglish';
  static const String query = 'query';
  static const String userSelectedType = 'userSelectedType';
  static const String userLanguageType = 'userLanguageType';
  static const String kakaoLatitude = 'kakaoLat';
  static const String kakaoLongitude = 'kakaoLng';
}
