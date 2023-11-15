///NOTE
///2023.11.14.
///산책하기 보류로 전체 주석 처리
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dio/dio.dart';
// import 'package:dio_smart_retry/dio_smart_retry.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:focus_detector/focus_detector.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
// import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/insta_assets_crop_controller.dart';
// import 'package:pet_mobile_social_flutter/components/feed/comment/mention_autocomplete_options.dart';
// import 'package:pet_mobile_social_flutter/config/constanst.dart';
// import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
// import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
// import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
// import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_item_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_write_result_detail/walk_write_result_detail_item_model.dart';
// // import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_write_result_detail/walk_write_result_detail_item_model.dart';
// import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_button_selected_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_carousel_controller_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/walk_result/walk_write_result_detail_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:pet_mobile_social_flutter/providers/walk/walk_pet_bowel_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/walk/walk_state_provider.dart';
// import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/walk_log_result_edit_screen.dart';
// import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/write_walk_log_bowel_widget.dart';
//
// class WriteWalkLogScreen extends ConsumerStatefulWidget {
//   // final Uint8List? screenShotImage;
//   // final File walkPathImageFile;
//   // final String walkUuid;
//
//   const WriteWalkLogScreen({
//     Key? key,
//     // this.screenShotImage,
//     // required this.walkPathImageFile,
//     // required this.walkUuid,
//   }) : super(key: key);
//
//   @override
//   WriteWalkLogScreenState createState() => WriteWalkLogScreenState();
// }
//
// // class WriteWalkLogScreenState extends ConsumerState<WriteWalkLogScreen> with TickerProviderStateMixin {
// class WriteWalkLogScreenState extends ConsumerState<WriteWalkLogScreen> {
//   List<File> additionalCroppedFiles = [];
//   // late TabController tabController;
//   // int selectedButton = 0;
//
//   // List<PetState> petStates = [];
//
//   late File? _walkPathImageFile;
//   late String _walkUuid;
//
//   @override
//   void initState() {
//     _walkUuid = ref.read(walkStateProvider.notifier).walkUuid;
//     // _walkUuid = 'walkko42835b3876bf45a1834a0e16a09992841698643593';
//     _walkPathImageFile = ref.read(walkPathImgStateProvider);
//     super.initState();
//
//     // testImageFile();
//
//     // ref.read(walkWriteResultDetailStateProvider.notifier).getWalkWriteResultDetail(walkUuid: _walkUuid);
//     // tabController = TabController(
//     //   initialIndex: 0,
//     //   length: 0,
//     //   vsync: this,
//     // );
//     // init(_walkUuid);
//   }
//
//   void testImageFile() async {
//     final byteData = await rootBundle.load('assets/image/character/character_02_page_error_1.png');
//     final file = File('${(await getTemporaryDirectory()).path}/testImage.png');
//     await file.create(recursive: true);
//     await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//     ref.read(walkPathImgStateProvider.notifier).state = file;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final buttonSelected = ref.watch(feedWriteButtonSelectedProvider);
//
//
//     return FocusDetector(
//       onFocusLost: () {
//         context.pushReplacement('/home');
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//           title: const Text(
//             "산책 결과",
//           ),
//           leading: IconButton(
//             onPressed: () {
//               context.pushReplacement('/home');
//             },
//             icon: const Icon(
//               Puppycat_social.icon_back,
//               size: 40,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (BuildContext context) {
//                     return WillPopScope(
//                       onWillPop: () async => false,
//                       child: Container(
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.6),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Lottie.asset(
//                               'assets/lottie/icon_loading.json',
//                               fit: BoxFit.fill,
//                               width: 80,
//                               height: 80,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//
//                 MultipartFile firstFile = MultipartFileRecreatable.fromFileSync(
//                   ref.read(walkPathImgStateProvider)!.path,
//                   contentType: MediaType('image', 'png'),
//                 );
//
//                 List<MultipartFile> multiPartFiles = await Future.wait(
//                   additionalCroppedFiles.map((file) async {
//                     return MultipartFileRecreatable.fromFileSync(
//                       file.path,
//                       contentType: MediaType('image', 'jpg'),
//                     );
//                   }).toList(),
//                 );
//
//                 multiPartFiles.insert(0, firstFile);
//
//                 Map<String, dynamic> baseParams = {
//                   "walkUuid": _walkUuid,
//                   "memberUuid": ref.read(userInfoProvider).userModel!.uuid,
//                   "contents": ref.watch(walkLogContentProvider.notifier).state.text ?? "",
//                   "isView": buttonSelected,
//                   "uploadFile": multiPartFiles,
//                 };
//
//                 final petStates = ref.read(walkPetBowelStateProvider);
//                 print('petStates $petStates');
//                 for (int i = 0; i < petStates.length; i++) {
//                   baseParams["walkPetList[$i].petUuid"] = petStates[i].petUuid;
//                   baseParams["walkPetList[$i].peeCount"] = petStates[i].peeCount;
//                   baseParams["walkPetList[$i].peeAmount"] = petStates[i].peeAmount;
//                   baseParams["walkPetList[$i].peeColor"] = petStates[i].peeColor;
//                   baseParams["walkPetList[$i].poopCount"] = petStates[i].poopCount;
//                   baseParams["walkPetList[$i].poopAmount"] = petStates[i].poopAmount;
//                   baseParams["walkPetList[$i].poopColor"] = petStates[i].poopColor;
//                   baseParams["walkPetList[$i].poopForm"] = petStates[i].poopForm;
//                 }
//
//                 print( 'baseParams $baseParams');
//
//                 final result = await ref.watch(walkWriteResultDetailStateProvider.notifier).postWalkResult(formDataMap: baseParams);
//                 if (result.result) {
//                   if (context.mounted) {
//                     // context.pop();
//                     context.pushReplacement('/home');
//                   }
//                 }
//
//                 if (result.result) {
//                   ref.read(walkStatusStateProvider.notifier).state = WalkStatus.idle;
//                   //TODO
//                   // final Directory cacheDir = await getTemporaryDirectory();
//                   // if (cacheDir.existsSync()) {
//                   //   cacheDir.deleteSync(recursive: true);
//                   // }
//                 }
//               },
//               child: Text(
//                 '등록',
//                 style: kButton12BoldStyle.copyWith(
//                   color: kPrimaryColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: FutureBuilder(
//             future: ref.read(walkWriteResultDetailStateProvider.notifier).getWalkWriteResultDetail(walkUuid: _walkUuid),
//             builder: (context, snapshot) {
//               if(snapshot.hasError) {
//                 return const Text('error');
//               }
//
//               if(!snapshot.hasData) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//
//               // final resultDetailModelItemList = ref.read(walkWriteResultDetailStateProvider);
//               final resultDetailModelItemList = snapshot.data!;
//               WalkWriteResultDetailItemModel? resultDetailModel; // = resultDetailModelItemList.first;
//               List<WalkPetList> petList = [];
//
//               if (resultDetailModelItemList.isNotEmpty) {
//                 resultDetailModel = resultDetailModelItemList.first;
//                 petList = [...resultDetailModel.walkPetList!];
//               }
//               List<Widget> imageWidgets = [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 9.0),
//                   child: Center(
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.all(Radius.circular(10)),
//                       child: Stack(
//                         children: [
//                           Image.file(
//                             ref.read(walkPathImgStateProvider) ?? File('test.png'),
//                             width: double.infinity,
//                             height: 225,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, exception, stackTrace) {
//                               testImageFile();
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ];
//
//
//               print('resultDetailModel ${resultDetailModel}');
//               print('petList.length ${petList.length}');
//
//
//
//
//               additionalCroppedFiles.asMap().forEach((index, file) {
//                 imageWidgets.add(
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 9.0),
//                     child: Center(
//                       child: ClipRRect(
//                         borderRadius: const BorderRadius.all(Radius.circular(10)),
//                         child: Stack(
//                           children: [
//                             Image.file(
//                               file,
//                               width: double.infinity,
//                               height: 225,
//                               fit: BoxFit.cover,
//                             ),
//                             Positioned(
//                               top: 10,
//                               right: 10,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     additionalCroppedFiles.removeAt(index);
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.all(6),
//                                   decoration: BoxDecoration(
//                                     color: kTextSubTitleColor.withOpacity(0.8),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   height: 28,
//                                   child: const Icon(
//                                     Icons.close,
//                                     size: 18,
//                                     color: kNeutralColor100,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               });
//               // return const Text('aaaaa');
//               return ListView(
//                 shrinkWrap: true,
//                 children: [
//                   AnimatedContainer(
//                     duration: kThemeChangeDuration,
//                     curve: Curves.easeInOut,
//                     height: 250,
//                     width: 270,
//                     child: Column(
//                       children: <Widget>[
//                         Expanded(
//                           child: Stack(
//                             alignment: Alignment.centerLeft,
//                             children: [
//                               CarouselSlider.builder(
//                                 carouselController: ref.read(feedWriteCarouselControllerProvider),
//                                 options: CarouselOptions(
//                                   initialPage: 0,
//                                   height: 260.0,
//                                   enableInfiniteScroll: false,
//                                   aspectRatio: 1,
//                                   padEnds: false,
//                                 ),
//                                 itemCount: imageWidgets.length,
//                                 itemBuilder: (BuildContext context, int index, int realIndex) {
//                                   return imageWidgets[index];
//                                 },
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);
//
//                         InstaAssetPicker.pickAssets(
//                           context,
//                           maxAssets: 11,
//                           pickerTheme: themeData(context).copyWith(
//                             canvasColor: kNeutralColor100,
//                             colorScheme: theme.colorScheme.copyWith(
//                               background: kNeutralColor100,
//                             ),
//                             appBarTheme: theme.appBarTheme.copyWith(
//                               backgroundColor: kNeutralColor100,
//                             ),
//                           ),
//                           onCompleted: (cropStream) {
//                             cropStream.listen((event) {
//                               if (event.croppedFiles.isNotEmpty) {
//                                 setState(() {
//                                   additionalCroppedFiles = event.croppedFiles;
//                                 });
//                               }
//                             });
//
//                             context.pop();
//                           },
//                         );
//                       },
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 12.0),
//                             child: Container(
//                               width: 150,
//                               height: 36,
//                               decoration: BoxDecoration(
//                                 borderRadius: const BorderRadius.all(Radius.circular(100)),
//                                 color: kNeutralColor100,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: -2,
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         const Icon(
//                                           Puppycat_social.icon_add_small,
//                                           size: 20,
//                                           color: kTextSubTitleColor,
//                                         ),
//                                         Text(
//                                           "사진 업로드",
//                                           style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//                                         ),
//                                         Text(
//                                           "(",
//                                           style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
//                                         ),
//                                         Text(
//                                           "${additionalCroppedFiles.length + 1}",
//                                           style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//                                         ),
//                                         Text(
//                                           "/12)",
//                                           style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 150,
//                     child: MultiTriggerAutocomplete(
//                       optionsAlignment: OptionsAlignment.topStart,
//                       autocompleteTriggers: [
//                         AutocompleteTrigger(
//                           trigger: '@',
//                           optionsViewBuilder: (context, autocompleteQuery, controller) {
//                             return MentionAutocompleteOptions(
//                               query: autocompleteQuery.query,
//                               onMentionUserTap: (user) {
//                                 final autocomplete = MultiTriggerAutocomplete.of(context);
//                                 return autocomplete.acceptAutocompleteOption(user.nick!);
//                               },
//                             );
//                           },
//                         ),
//                       ],
//                       fieldViewBuilder: (context, controller, focusNode) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           ref.read(walkLogContentProvider.notifier).state = controller;
//                         });
//
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             child: FormBuilderTextField(
//                               focusNode: focusNode,
//                               controller: controller,
//                               onChanged: (text) {
//                                 int cursorPos = controller.selection.baseOffset;
//                                 if (cursorPos > 0) {
//                                   int from = text!.lastIndexOf('@', cursorPos);
//                                   if (from != -1) {
//                                     int prevCharPos = from - 1;
//                                     if (prevCharPos >= 0 && text[prevCharPos] != ' ') {
//                                       return;
//                                     }
//
//                                     int nextSpace = text.indexOf(' ', from);
//                                     if (nextSpace == -1 || nextSpace >= cursorPos) {
//                                       String toSearch = text.substring(from + 1, cursorPos);
//                                       toSearch = toSearch.trim();
//
//                                       if (toSearch.isNotEmpty) {
//                                         if (toSearch.length >= 1) {
//                                           ref.read(searchStateProvider.notifier).searchQuery.add(toSearch);
//                                         }
//                                       } else {
//                                         ref.read(searchStateProvider.notifier).getMentionRecommendList(initPage: 1);
//                                       }
//                                     }
//                                   }
//                                 }
//                               },
//                               scrollPhysics: const ClampingScrollPhysics(),
//                               maxLength: 500,
//                               maxLines: 6,
//                               decoration: InputDecoration(
//                                   counterText: "",
//                                   hintText: '산책 중 일어난 일을 메모해 보세요 . (최대 500자)\n작성한 메모는 마이페이지 산책일지에서 나만 볼 수 있습니다.',
//                                   hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
//                                   contentPadding: const EdgeInsets.all(16)),
//                               name: 'content',
//                               style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//                               keyboardType: TextInputType.multiline,
//                               textAlignVertical: TextAlignVertical.center,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
//                     child: Text(
//                       "공개 범위",
//                       style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               ref.read(feedWriteButtonSelectedProvider.notifier).state = 1;
//                             },
//                             child: Container(
//                               decoration: buttonSelected == 1
//                                   ? BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: kPrimaryLightColor,
//                                     )
//                                   : BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(color: kNeutralColor400),
//                                     ),
//                               height: 44,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Puppycat_social.icon_view_all,
//                                     size: 14,
//                                     color: buttonSelected == 1 ? kPrimaryColor : kTextBodyColor,
//                                   ),
//                                   SizedBox(
//                                     width: 9,
//                                   ),
//                                   Text(
//                                     "전체 공개",
//                                     style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 1 ? kPrimaryColor : kTextBodyColor),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               ref.read(feedWriteButtonSelectedProvider.notifier).state = 2;
//                             },
//                             child: Container(
//                               decoration: buttonSelected == 2
//                                   ? BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: kPrimaryLightColor,
//                                     )
//                                   : BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(color: kNeutralColor400),
//                                     ),
//                               height: 44,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Puppycat_social.icon_view_all,
//                                     size: 14,
//                                     color: buttonSelected == 2 ? kPrimaryColor : kTextBodyColor,
//                                   ),
//                                   SizedBox(
//                                     width: 9,
//                                   ),
//                                   Text(
//                                     "팔로우 공개",
//                                     style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 2 ? kPrimaryColor : kTextBodyColor),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               ref.read(feedWriteButtonSelectedProvider.notifier).state = 0;
//                             },
//                             child: Container(
//                               decoration: buttonSelected == 0
//                                   ? BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: kPrimaryLightColor,
//                                     )
//                                   : BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(color: kNeutralColor400),
//                                     ),
//                               height: 44,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Puppycat_social.icon_view_all,
//                                     size: 14,
//                                     color: buttonSelected == 0 ? kPrimaryColor : kTextBodyColor,
//                                   ),
//                                   SizedBox(
//                                     width: 9,
//                                   ),
//                                   Text(
//                                     "비공개",
//                                     style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 0 ? kPrimaryColor : kTextBodyColor),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
//                     child: Text(
//                       "산책결과",
//                       style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//                         child: Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: kNeutralColor400),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 16.0),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         decoration: const BoxDecoration(
//                                           color: kNeutralColor200,
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(8.0),
//                                           ),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
//                                           child: Text(
//                                             "날짜",
//                                             style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 4,
//                                       ),
//                                       Text(
//                                         DateFormat('yyyy-MM-dd (EEE)', 'ko_KR').format(DateTime.parse(resultDetailModel?.startDate ?? '0000-00-00 00:00:00')),
//                                         style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           decoration: const BoxDecoration(
//                                             color: kNeutralColor200,
//                                             borderRadius: BorderRadius.all(
//                                               Radius.circular(8.0),
//                                             ),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
//                                             child: Text(
//                                               "시작",
//                                               style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 4,
//                                         ),
//                                         Text(
//                                           DateFormat('a h:mm', 'ko_KR').format(DateTime.parse(resultDetailModel?.startDate ?? '0000-00-00 00:00:00')),
//                                           style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Container(
//                                           decoration: const BoxDecoration(
//                                             color: kNeutralColor200,
//                                             borderRadius: BorderRadius.all(
//                                               Radius.circular(8.0),
//                                             ),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
//                                             child: Text(
//                                               "종료",
//                                               style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 4,
//                                         ),
//                                         Text(
//                                           DateFormat('a h:mm', 'ko_KR').format(DateTime.parse(resultDetailModel?.endDate ?? '0000-00-00 00:00:00')),
//                                           style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 16.0),
//                                   child: Divider(
//                                     thickness: 1,
//                                     height: 1,
//                                     color: kNeutralColor300,
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 decoration: const BoxDecoration(
//                                                   color: kNeutralColor200,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: const Padding(
//                                                   padding: EdgeInsets.all(2.0),
//                                                   child: Icon(
//                                                     Puppycat_social.icon_comment,
//                                                     size: 16,
//                                                     color: kTextBodyColor,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 4,
//                                               ),
//                                               Text(
//                                                 formatDuration(
//                                                   DateTime.parse(resultDetailModel?.endDate ?? '0000-00-00 00:00:00').difference(
//                                                     DateTime.parse(resultDetailModel?.startDate ?? '0000-00-00 00:00:00'),
//                                                   ),
//                                                 ),
//                                                 style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 decoration: const BoxDecoration(
//                                                   color: kNeutralColor200,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: const Padding(
//                                                   padding: EdgeInsets.all(2.0),
//                                                   child: Icon(
//                                                     Puppycat_social.icon_comment,
//                                                     size: 16,
//                                                     color: kTextBodyColor,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 4,
//                                               ),
//                                               Text(
//                                                 resultDetailModel?.stepText ?? '-',
//                                                 style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       width: 60,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 decoration: const BoxDecoration(
//                                                   color: kNeutralColor200,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: const Padding(
//                                                   padding: EdgeInsets.all(2.0),
//                                                   child: Icon(
//                                                     Puppycat_social.icon_comment,
//                                                     size: 16,
//                                                     color: kTextBodyColor,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 4,
//                                               ),
//                                               Text(
//                                                 resultDetailModel?.distanceText ?? '-',
//                                                 style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 decoration: const BoxDecoration(
//                                                   color: kNeutralColor200,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: const Padding(
//                                                   padding: EdgeInsets.all(2.0),
//                                                   child: Icon(
//                                                     Puppycat_social.icon_comment,
//                                                     size: 16,
//                                                     color: kTextBodyColor,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 4,
//                                               ),
//                                               Text(
//                                                 resultDetailModel?.calorieText ?? '-',
//                                                 style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   WriteWalkLogBowelWidget(petList: petList),
//                 ],
//               );
//             }),
//         // ListView(
//         //   shrinkWrap: true,
//         //   children: [
//         //     AnimatedContainer(
//         //       duration: kThemeChangeDuration,
//         //       curve: Curves.easeInOut,
//         //       height: 250,
//         //       width: 270,
//         //       child: Column(
//         //         children: <Widget>[
//         //           Expanded(
//         //             child: Stack(
//         //               alignment: Alignment.centerLeft,
//         //               children: [
//         //                 CarouselSlider.builder(
//         //                   carouselController: ref.watch(feedWriteCarouselControllerProvider),
//         //                   options: CarouselOptions(
//         //                     initialPage: 0,
//         //                     height: 260.0,
//         //                     enableInfiniteScroll: false,
//         //                     aspectRatio: 1,
//         //                     padEnds: false,
//         //                   ),
//         //                   itemCount: imageWidgets.length,
//         //                   itemBuilder: (BuildContext context, int index, int realIndex) {
//         //                     return imageWidgets[index];
//         //                   },
//         //                 ),
//         //               ],
//         //             ),
//         //           )
//         //         ],
//         //       ),
//         //     ),
//         //     Padding(
//         //       padding: EdgeInsets.symmetric(horizontal: 12.0),
//         //       child: GestureDetector(
//         //         onTap: () {
//         //           final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);
//         //
//         //           InstaAssetPicker.pickAssets(
//         //             context,
//         //             maxAssets: 11,
//         //             pickerTheme: themeData(context).copyWith(
//         //               canvasColor: kNeutralColor100,
//         //               colorScheme: theme.colorScheme.copyWith(
//         //                 background: kNeutralColor100,
//         //               ),
//         //               appBarTheme: theme.appBarTheme.copyWith(
//         //                 backgroundColor: kNeutralColor100,
//         //               ),
//         //             ),
//         //             onCompleted: (cropStream) {
//         //               cropStream.listen((event) {
//         //                 if (event.croppedFiles.isNotEmpty) {
//         //                   setState(() {
//         //                     additionalCroppedFiles = event.croppedFiles;
//         //                   });
//         //                 }
//         //               });
//         //
//         //               context.pop();
//         //             },
//         //           );
//         //         },
//         //         child: Column(
//         //           children: [
//         //             Padding(
//         //               padding: EdgeInsets.only(bottom: 12.0),
//         //               child: Container(
//         //                 width: 150,
//         //                 height: 36,
//         //                 decoration: BoxDecoration(
//         //                   borderRadius: const BorderRadius.all(Radius.circular(100)),
//         //                   color: kNeutralColor100,
//         //                   boxShadow: [
//         //                     BoxShadow(
//         //                       color: Colors.grey.withOpacity(0.5),
//         //                       spreadRadius: -2,
//         //                       blurRadius: 10,
//         //                       offset: const Offset(0, 3),
//         //                     ),
//         //                   ],
//         //                 ),
//         //                 child: Padding(
//         //                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         //                   child: Row(
//         //                     mainAxisAlignment: MainAxisAlignment.center,
//         //                     crossAxisAlignment: CrossAxisAlignment.center,
//         //                     children: [
//         //                       Row(
//         //                         children: [
//         //                           const Icon(
//         //                             Puppycat_social.icon_add_small,
//         //                             size: 20,
//         //                             color: kTextSubTitleColor,
//         //                           ),
//         //                           Text(
//         //                             "사진 업로드",
//         //                             style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//         //                           ),
//         //                           Text(
//         //                             "(",
//         //                             style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
//         //                           ),
//         //                           Text(
//         //                             "${additionalCroppedFiles.length + 1}",
//         //                             style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//         //                           ),
//         //                           Text(
//         //                             "/12)",
//         //                             style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
//         //                           ),
//         //                         ],
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 ),
//         //               ),
//         //             ),
//         //           ],
//         //         ),
//         //       ),
//         //     ),
//         //     SizedBox(
//         //       height: 150,
//         //       child: MultiTriggerAutocomplete(
//         //         optionsAlignment: OptionsAlignment.topStart,
//         //         autocompleteTriggers: [
//         //           AutocompleteTrigger(
//         //             trigger: '@',
//         //             optionsViewBuilder: (context, autocompleteQuery, controller) {
//         //               return MentionAutocompleteOptions(
//         //                 query: autocompleteQuery.query,
//         //                 onMentionUserTap: (user) {
//         //                   final autocomplete = MultiTriggerAutocomplete.of(context);
//         //                   return autocomplete.acceptAutocompleteOption(user.nick!);
//         //                 },
//         //               );
//         //             },
//         //           ),
//         //         ],
//         //         fieldViewBuilder: (context, controller, focusNode) {
//         //           WidgetsBinding.instance.addPostFrameCallback((_) {
//         //             ref.watch(walkLogContentProvider.notifier).state = controller;
//         //           });
//         //
//         //           return Padding(
//         //             padding: const EdgeInsets.all(8.0),
//         //             child: Container(
//         //               child: FormBuilderTextField(
//         //                 focusNode: focusNode,
//         //                 controller: ref.watch(walkLogContentProvider),
//         //                 onChanged: (text) {
//         //                   int cursorPos = ref.watch(walkLogContentProvider).selection.baseOffset;
//         //                   if (cursorPos > 0) {
//         //                     int from = text!.lastIndexOf('@', cursorPos);
//         //                     if (from != -1) {
//         //                       int prevCharPos = from - 1;
//         //                       if (prevCharPos >= 0 && text[prevCharPos] != ' ') {
//         //                         return;
//         //                       }
//         //
//         //                       int nextSpace = text.indexOf(' ', from);
//         //                       if (nextSpace == -1 || nextSpace >= cursorPos) {
//         //                         String toSearch = text.substring(from + 1, cursorPos);
//         //                         toSearch = toSearch.trim();
//         //
//         //                         if (toSearch.isNotEmpty) {
//         //                           if (toSearch.length >= 1) {
//         //                             ref.watch(searchStateProvider.notifier).searchQuery.add(toSearch);
//         //                           }
//         //                         } else {
//         //                           ref.watch(searchStateProvider.notifier).getMentionRecommendList(initPage: 1);
//         //                         }
//         //                       }
//         //                     }
//         //                   }
//         //                 },
//         //                 scrollPhysics: const ClampingScrollPhysics(),
//         //                 maxLength: 500,
//         //                 maxLines: 6,
//         //                 decoration: InputDecoration(
//         //                     counterText: "",
//         //                     hintText: '산책 중 일어난 일을 메모해 보세요 . (최대 500자)\n작성한 메모는 마이페이지 산책일지에서 나만 볼 수 있습니다.',
//         //                     hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
//         //                     contentPadding: const EdgeInsets.all(16)),
//         //                 name: 'content',
//         //                 style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                 keyboardType: TextInputType.multiline,
//         //                 textAlignVertical: TextAlignVertical.center,
//         //               ),
//         //             ),
//         //           );
//         //         },
//         //       ),
//         //     ),
//         //     Padding(
//         //       padding: EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
//         //       child: Text(
//         //         "공개 범위",
//         //         style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//         //       ),
//         //     ),
//         //     Padding(
//         //       padding: EdgeInsets.symmetric(horizontal: 12.0),
//         //       child: Row(
//         //         children: [
//         //           Expanded(
//         //             child: GestureDetector(
//         //               onTap: () {
//         //                 ref.watch(feedWriteButtonSelectedProvider.notifier).state = 1;
//         //               },
//         //               child: Container(
//         //                 decoration: buttonSelected == 1
//         //                     ? BoxDecoration(
//         //                         borderRadius: BorderRadius.circular(10),
//         //                         color: kPrimaryLightColor,
//         //                       )
//         //                     : BoxDecoration(
//         //                         borderRadius: BorderRadius.circular(10),
//         //                         border: Border.all(color: kNeutralColor400),
//         //                       ),
//         //                 height: 44,
//         //                 child: Row(
//         //                   mainAxisAlignment: MainAxisAlignment.center,
//         //                   children: [
//         //                     Icon(
//         //                       Puppycat_social.icon_view_all,
//         //                       size: 14,
//         //                       color: buttonSelected == 1 ? kPrimaryColor : kTextBodyColor,
//         //                     ),
//         //                     SizedBox(
//         //                       width: 9,
//         //                     ),
//         //                     Text(
//         //                       "전체 공개",
//         //                       style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 1 ? kPrimaryColor : kTextBodyColor),
//         //                     ),
//         //                   ],
//         //                 ),
//         //               ),
//         //             ),
//         //           ),
//         //           const SizedBox(
//         //             width: 10,
//         //           ),
//         //           Expanded(
//         //             child: GestureDetector(
//         //               onTap: () {
//         //                 ref.watch(feedWriteButtonSelectedProvider.notifier).state = 2;
//         //               },
//         //               child: Container(
//         //                 decoration: buttonSelected == 2
//         //                     ? BoxDecoration(
//         //                         borderRadius: BorderRadius.circular(10),
//         //                         color: kPrimaryLightColor,
//         //                       )
//         //                     : BoxDecoration(
//         //                         borderRadius: BorderRadius.circular(10),
//         //                         border: Border.all(color: kNeutralColor400),
//         //                       ),
//         //                 height: 44,
//         //                 child: Row(
//         //                   mainAxisAlignment: MainAxisAlignment.center,
//         //                   children: [
//         //                     Icon(
//         //                       Puppycat_social.icon_view_all,
//         //                       size: 14,
//         //                       color: buttonSelected == 2 ? kPrimaryColor : kTextBodyColor,
//         //                     ),
//         //                     SizedBox(
//         //                       width: 9,
//         //                     ),
//         //                     Text(
//         //                       "팔로우 공개",
//         //                       style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 2 ? kPrimaryColor : kTextBodyColor),
//         //                     ),
//         //                   ],
//         //                 ),
//         //               ),
//         //             ),
//         //           ),
//         //           const SizedBox(
//         //             width: 10,
//         //           ),
//         //           Expanded(
//         //             child: GestureDetector(
//         //               onTap: () {
//         //                 ref.watch(feedWriteButtonSelectedProvider.notifier).state = 0;
//         //               },
//         //               child: Container(
//         //                 decoration: buttonSelected == 0
//         //                     ? BoxDecoration(
//         //                         borderRadius: BorderRadius.circular(10),
//         //                         color: kPrimaryLightColor,
//         //                       )
//         //                     : BoxDecoration(
//         //                         borderRadius: BorderRadius.circular(10),
//         //                         border: Border.all(color: kNeutralColor400),
//         //                       ),
//         //                 height: 44,
//         //                 child: Row(
//         //                   mainAxisAlignment: MainAxisAlignment.center,
//         //                   children: [
//         //                     Icon(
//         //                       Puppycat_social.icon_view_all,
//         //                       size: 14,
//         //                       color: buttonSelected == 0 ? kPrimaryColor : kTextBodyColor,
//         //                     ),
//         //                     SizedBox(
//         //                       width: 9,
//         //                     ),
//         //                     Text(
//         //                       "비공개",
//         //                       style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 0 ? kPrimaryColor : kTextBodyColor),
//         //                     ),
//         //                   ],
//         //                 ),
//         //               ),
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //     ),
//         //     Padding(
//         //       padding: EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
//         //       child: Text(
//         //         "산책결과",
//         //         style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//         //       ),
//         //     ),
//         //     Column(
//         //       children: [
//         //         Padding(
//         //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//         //           child: Container(
//         //             width: double.infinity,
//         //             decoration: BoxDecoration(
//         //               borderRadius: BorderRadius.circular(10),
//         //               border: Border.all(color: kNeutralColor400),
//         //             ),
//         //             child: Padding(
//         //               padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
//         //               child: Column(
//         //                 children: [
//         //                   Padding(
//         //                     padding: const EdgeInsets.only(bottom: 16.0),
//         //                     child: Row(
//         //                       children: [
//         //                         Container(
//         //                           decoration: const BoxDecoration(
//         //                             color: kNeutralColor200,
//         //                             borderRadius: BorderRadius.all(
//         //                               Radius.circular(8.0),
//         //                             ),
//         //                           ),
//         //                           child: Padding(
//         //                             padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
//         //                             child: Text(
//         //                               "날짜",
//         //                               style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//         //                             ),
//         //                           ),
//         //                         ),
//         //                         SizedBox(
//         //                           width: 4,
//         //                         ),
//         //                         Text(
//         //                           DateFormat('yyyy-MM-dd (EEE)', 'ko_KR').format(DateTime.parse(resultDetailModel?.startDate ?? '0000-00-00 00:00:00')),
//         //                           style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                         ),
//         //                       ],
//         //                     ),
//         //                   ),
//         //                   Row(
//         //                     children: [
//         //                       Row(
//         //                         children: [
//         //                           Container(
//         //                             decoration: const BoxDecoration(
//         //                               color: kNeutralColor200,
//         //                               borderRadius: BorderRadius.all(
//         //                                 Radius.circular(8.0),
//         //                               ),
//         //                             ),
//         //                             child: Padding(
//         //                               padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
//         //                               child: Text(
//         //                                 "시작",
//         //                                 style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//         //                               ),
//         //                             ),
//         //                           ),
//         //                           SizedBox(
//         //                             width: 4,
//         //                           ),
//         //                           Text(
//         //                             DateFormat('a h:mm', 'ko_KR').format(DateTime.parse(resultDetailModel?.startDate ?? '0000-00-00 00:00:00')),
//         //                             style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                           ),
//         //                         ],
//         //                       ),
//         //                       SizedBox(
//         //                         width: 20,
//         //                       ),
//         //                       Row(
//         //                         children: [
//         //                           Container(
//         //                             decoration: const BoxDecoration(
//         //                               color: kNeutralColor200,
//         //                               borderRadius: BorderRadius.all(
//         //                                 Radius.circular(8.0),
//         //                               ),
//         //                             ),
//         //                             child: Padding(
//         //                               padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
//         //                               child: Text(
//         //                                 "종료",
//         //                                 style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//         //                               ),
//         //                             ),
//         //                           ),
//         //                           const SizedBox(
//         //                             width: 4,
//         //                           ),
//         //                           Text(
//         //                             DateFormat('a h:mm', 'ko_KR').format(DateTime.parse(resultDetailModel?.endDate ?? '0000-00-00 00:00:00')),
//         //                             style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                           ),
//         //                         ],
//         //                       ),
//         //                     ],
//         //                   ),
//         //                   const Padding(
//         //                     padding: EdgeInsets.symmetric(vertical: 16.0),
//         //                     child: Divider(
//         //                       thickness: 1,
//         //                       height: 1,
//         //                       color: kNeutralColor300,
//         //                     ),
//         //                   ),
//         //                   Row(
//         //                     children: [
//         //                       Column(
//         //                         crossAxisAlignment: CrossAxisAlignment.start,
//         //                         children: [
//         //                           Padding(
//         //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//         //                             child: Row(
//         //                               children: [
//         //                                 Container(
//         //                                   decoration: const BoxDecoration(
//         //                                     color: kNeutralColor200,
//         //                                     shape: BoxShape.circle,
//         //                                   ),
//         //                                   child: const Padding(
//         //                                     padding: EdgeInsets.all(2.0),
//         //                                     child: Icon(
//         //                                       Puppycat_social.icon_comment,
//         //                                       size: 16,
//         //                                       color: kTextBodyColor,
//         //                                     ),
//         //                                   ),
//         //                                 ),
//         //                                 const SizedBox(
//         //                                   width: 4,
//         //                                 ),
//         //                                 Text(
//         //                                   formatDuration(
//         //                                     DateTime.parse(resultDetailModel?.endDate ?? '0000-00-00 00:00:00').difference(
//         //                                       DateTime.parse(resultDetailModel?.startDate ?? '0000-00-00 00:00:00'),
//         //                                     ),
//         //                                   ),
//         //                                   style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                 ),
//         //                               ],
//         //                             ),
//         //                           ),
//         //                           Padding(
//         //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//         //                             child: Row(
//         //                               children: [
//         //                                 Container(
//         //                                   decoration: const BoxDecoration(
//         //                                     color: kNeutralColor200,
//         //                                     shape: BoxShape.circle,
//         //                                   ),
//         //                                   child: const Padding(
//         //                                     padding: EdgeInsets.all(2.0),
//         //                                     child: Icon(
//         //                                       Puppycat_social.icon_comment,
//         //                                       size: 16,
//         //                                       color: kTextBodyColor,
//         //                                     ),
//         //                                   ),
//         //                                 ),
//         //                                 const SizedBox(
//         //                                   width: 4,
//         //                                 ),
//         //                                 Text(
//         //                                   resultDetailModel?.stepText ?? '-',
//         //                                   style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                 ),
//         //                               ],
//         //                             ),
//         //                           ),
//         //                         ],
//         //                       ),
//         //                       const SizedBox(
//         //                         width: 60,
//         //                       ),
//         //                       Column(
//         //                         crossAxisAlignment: CrossAxisAlignment.start,
//         //                         children: [
//         //                           Padding(
//         //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//         //                             child: Row(
//         //                               children: [
//         //                                 Container(
//         //                                   decoration: const BoxDecoration(
//         //                                     color: kNeutralColor200,
//         //                                     shape: BoxShape.circle,
//         //                                   ),
//         //                                   child: const Padding(
//         //                                     padding: EdgeInsets.all(2.0),
//         //                                     child: Icon(
//         //                                       Puppycat_social.icon_comment,
//         //                                       size: 16,
//         //                                       color: kTextBodyColor,
//         //                                     ),
//         //                                   ),
//         //                                 ),
//         //                                 const SizedBox(
//         //                                   width: 4,
//         //                                 ),
//         //                                 Text(
//         //                                   resultDetailModel?.distanceText ?? '-',
//         //                                   style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                 ),
//         //                               ],
//         //                             ),
//         //                           ),
//         //                           Padding(
//         //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//         //                             child: Row(
//         //                               children: [
//         //                                 Container(
//         //                                   decoration: const BoxDecoration(
//         //                                     color: kNeutralColor200,
//         //                                     shape: BoxShape.circle,
//         //                                   ),
//         //                                   child: const Padding(
//         //                                     padding: EdgeInsets.all(2.0),
//         //                                     child: Icon(
//         //                                       Puppycat_social.icon_comment,
//         //                                       size: 16,
//         //                                       color: kTextBodyColor,
//         //                                     ),
//         //                                   ),
//         //                                 ),
//         //                                 const SizedBox(
//         //                                   width: 4,
//         //                                 ),
//         //                                 Text(
//         //                                   resultDetailModel?.calorieText ?? '-',
//         //                                   style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                 ),
//         //                               ],
//         //                             ),
//         //                           ),
//         //                         ],
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 ],
//         //               ),
//         //             ),
//         //           ),
//         //         ),
//         //       ],
//         //     ),
//         //     Padding(
//         //       padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
//         //       child: Text(
//         //         "산책 파트너",
//         //         style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//         //       ),
//         //     ),
//         //     TabBar(
//         //       isScrollable: true,
//         //       controller: tabController,
//         //       indicatorWeight: 3,
//         //       labelColor: kPrimaryColor,
//         //       indicatorColor: kPrimaryColor,
//         //       unselectedLabelColor: kNeutralColor500,
//         //       indicatorSize: TabBarIndicatorSize.tab,
//         //       labelPadding: const EdgeInsets.only(
//         //         top: 10,
//         //         bottom: 10,
//         //       ),
//         //       tabs: resultDetailModel?.walkPetList
//         //               ?.map(
//         //                 (tab) => Padding(
//         //                   padding: const EdgeInsets.symmetric(horizontal: 10),
//         //                   child: Text(
//         //                     tab.name!,
//         //                     style: kBody14BoldStyle,
//         //                   ),
//         //                 ),
//         //               )
//         //               .toList() ??
//         //           [],
//         //     ),
//         //     SizedBox(
//         //       height: selectedButton == 0 ? 270 : 310,
//         //       child: TabBarView(
//         //         controller: tabController,
//         //         children: petStates.map((tab) {
//         //           return Column(
//         //             children: [
//         //               Padding(
//         //                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//         //                 child: Container(
//         //                   width: double.infinity,
//         //                   decoration: BoxDecoration(
//         //                     borderRadius: BorderRadius.circular(10),
//         //                     border: Border.all(color: kNeutralColor400),
//         //                   ),
//         //                   child: Column(
//         //                     children: [
//         //                       Padding(
//         //                         padding: const EdgeInsets.only(top: 20.0, bottom: 22.0),
//         //                         child: Row(
//         //                           mainAxisAlignment: MainAxisAlignment.center,
//         //                           children: [
//         //                             InkWell(
//         //                               onTap: () {
//         //                                 setState(() {
//         //                                   selectedButton = 0;
//         //                                 });
//         //                               },
//         //                               child: Container(
//         //                                 decoration: BoxDecoration(
//         //                                   borderRadius: BorderRadius.circular(100),
//         //                                   color: selectedButton == 0 ? kNeutralColor300 : kNeutralColor100,
//         //                                 ),
//         //                                 child: Padding(
//         //                                   padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                                   child: Row(
//         //                                     children: [
//         //                                       Icon(
//         //                                         Puppycat_social.icon_comment,
//         //                                         color: selectedButton == 0 ? kTextTitleColor : kTextBodyColor,
//         //                                       ),
//         //                                       const SizedBox(
//         //                                         width: 8,
//         //                                       ),
//         //                                       Text(
//         //                                         "소변",
//         //                                         style: kBody12SemiBoldStyle.copyWith(color: selectedButton == 0 ? kTextTitleColor : kTextBodyColor),
//         //                                       ),
//         //                                     ],
//         //                                   ),
//         //                                 ),
//         //                               ),
//         //                             ),
//         //                             InkWell(
//         //                               onTap: () {
//         //                                 setState(() {
//         //                                   selectedButton = 1;
//         //                                 });
//         //                               },
//         //                               child: Container(
//         //                                 decoration: BoxDecoration(
//         //                                   borderRadius: BorderRadius.circular(100),
//         //                                   color: selectedButton == 1 ? kNeutralColor300 : kNeutralColor100,
//         //                                 ),
//         //                                 child: Padding(
//         //                                   padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                                   child: Row(
//         //                                     children: [
//         //                                       Icon(
//         //                                         Puppycat_social.icon_comment,
//         //                                         color: selectedButton == 1 ? kTextTitleColor : kTextBodyColor,
//         //                                       ),
//         //                                       const SizedBox(
//         //                                         width: 8,
//         //                                       ),
//         //                                       Text(
//         //                                         "대변",
//         //                                         style: kBody12SemiBoldStyle.copyWith(color: selectedButton == 1 ? kTextTitleColor : kTextBodyColor),
//         //                                       ),
//         //                                     ],
//         //                                   ),
//         //                                 ),
//         //                               ),
//         //                             ),
//         //                           ],
//         //                         ),
//         //                       ),
//         //                       if (selectedButton == 0)
//         //                         Column(
//         //                           children: [
//         //                             Padding(
//         //                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //                               child: Row(
//         //                                 children: [
//         //                                   Text(
//         //                                     "횟수",
//         //                                     style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                   ),
//         //                                   Expanded(
//         //                                     child: Row(
//         //                                       mainAxisAlignment: MainAxisAlignment.center,
//         //                                       children: [
//         //                                         InkWell(
//         //                                           onTap: tab.peeCount > 0
//         //                                               ? () {
//         //                                                   setState(() {
//         //                                                     tab.peeCount -= 1;
//         //                                                   });
//         //                                                 }
//         //                                               : null,
//         //                                           child: Container(
//         //                                             decoration: BoxDecoration(
//         //                                               borderRadius: BorderRadius.circular(5),
//         //                                               border: Border.all(color: kNeutralColor400),
//         //                                             ),
//         //                                             child: Padding(
//         //                                               padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
//         //                                               child: Text(
//         //                                                 "-",
//         //                                                 style: kButton14MediumStyle.copyWith(color: tab.peeCount > 0 ? kTextBodyColor : kNeutralColor500),
//         //                                               ),
//         //                                             ),
//         //                                           ),
//         //                                         ),
//         //                                         Padding(
//         //                                           padding: const EdgeInsets.symmetric(horizontal: 40.0),
//         //                                           child: Row(
//         //                                             children: [
//         //                                               const Icon(
//         //                                                 Puppycat_social.icon_comment,
//         //                                                 color: kTextTitleColor,
//         //                                               ),
//         //                                               const SizedBox(
//         //                                                 width: 8,
//         //                                               ),
//         //                                               Text(
//         //                                                 "${tab.peeCount}",
//         //                                                 style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
//         //                                               ),
//         //                                             ],
//         //                                           ),
//         //                                         ),
//         //                                         InkWell(
//         //                                           onTap: tab.peeCount < 99
//         //                                               ? () {
//         //                                                   setState(() {
//         //                                                     tab.peeCount += 1;
//         //                                                   });
//         //                                                 }
//         //                                               : null,
//         //                                           child: Container(
//         //                                             decoration: BoxDecoration(
//         //                                               borderRadius: BorderRadius.circular(5),
//         //                                               border: Border.all(color: kNeutralColor400),
//         //                                             ),
//         //                                             child: Padding(
//         //                                               padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
//         //                                               child: Text(
//         //                                                 "+",
//         //                                                 style: kButton14MediumStyle.copyWith(color: tab.peeCount < 99 ? kTextBodyColor : kNeutralColor500),
//         //                                               ),
//         //                                             ),
//         //                                           ),
//         //                                         ),
//         //                                       ],
//         //                                     ),
//         //                                   )
//         //                                 ],
//         //                               ),
//         //                             ),
//         //                             const Padding(
//         //                               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                               child: Divider(
//         //                                 thickness: 1,
//         //                                 height: 1,
//         //                                 color: kNeutralColor300,
//         //                               ),
//         //                             ),
//         //                             Padding(
//         //                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //                               child: Row(
//         //                                 children: [
//         //                                   Padding(
//         //                                     padding: const EdgeInsets.only(right: 20.0),
//         //                                     child: Text(
//         //                                       "양",
//         //                                       style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                     ),
//         //                                   ),
//         //                                   Expanded(
//         //                                     child: Row(
//         //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                                       children: [
//         //                                         for (var i = 0; i < peeAmountList.length; i++)
//         //                                           GestureDetector(
//         //                                             onTap: () {
//         //                                               setState(() {
//         //                                                 tab.peeAmount = i;
//         //                                               });
//         //                                             },
//         //                                             child: Container(
//         //                                               decoration: tab.peeAmount == i
//         //                                                   ? BoxDecoration(
//         //                                                       borderRadius: BorderRadius.circular(100),
//         //                                                       color: kPrimaryLightColor,
//         //                                                     )
//         //                                                   : null,
//         //                                               child: Padding(
//         //                                                 padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         //                                                 child: Text(
//         //                                                   peeAmountList[i],
//         //                                                   style: kBody13RegularStyle.copyWith(
//         //                                                     color: tab.peeAmount == i ? kPrimaryColor : kTextBodyColor,
//         //                                                   ),
//         //                                                 ),
//         //                                               ),
//         //                                             ),
//         //                                           )
//         //                                       ],
//         //                                     ),
//         //                                   )
//         //                                 ],
//         //                               ),
//         //                             ),
//         //                             const Padding(
//         //                               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                               child: Divider(
//         //                                 thickness: 1,
//         //                                 height: 1,
//         //                                 color: kNeutralColor300,
//         //                               ),
//         //                             ),
//         //                             Padding(
//         //                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //                               child: Row(
//         //                                 children: [
//         //                                   Padding(
//         //                                     padding: const EdgeInsets.only(right: 20.0),
//         //                                     child: Text(
//         //                                       "색",
//         //                                       style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                     ),
//         //                                   ),
//         //                                   Expanded(
//         //                                     child: Row(
//         //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                                       children: [
//         //                                         for (var i = 0; i < peeColorList.length; i++)
//         //                                           GestureDetector(
//         //                                             onTap: () {
//         //                                               setState(() {
//         //                                                 tab.peeColor = i;
//         //                                               });
//         //                                             },
//         //                                             child: Container(
//         //                                               decoration: tab.peeColor == i
//         //                                                   ? BoxDecoration(
//         //                                                       borderRadius: BorderRadius.circular(100),
//         //                                                       color: kPrimaryLightColor,
//         //                                                     )
//         //                                                   : null,
//         //                                               child: Padding(
//         //                                                 padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         //                                                 child: Text(
//         //                                                   peeColorList[i],
//         //                                                   style: kBody13RegularStyle.copyWith(
//         //                                                     color: tab.peeColor == i ? kPrimaryColor : kTextBodyColor,
//         //                                                   ),
//         //                                                 ),
//         //                                               ),
//         //                                             ),
//         //                                           )
//         //                                       ],
//         //                                     ),
//         //                                   )
//         //                                 ],
//         //                               ),
//         //                             ),
//         //                             const Padding(
//         //                               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                             ),
//         //                           ],
//         //                         ),
//         //                       if (selectedButton == 1)
//         //                         Column(
//         //                           children: [
//         //                             Padding(
//         //                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //                               child: Row(
//         //                                 children: [
//         //                                   Text(
//         //                                     "횟수",
//         //                                     style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                   ),
//         //                                   Expanded(
//         //                                     child: Row(
//         //                                       mainAxisAlignment: MainAxisAlignment.center,
//         //                                       children: [
//         //                                         InkWell(
//         //                                           onTap: tab.poopCount > 0
//         //                                               ? () {
//         //                                                   setState(() {
//         //                                                     tab.poopCount -= 1;
//         //                                                   });
//         //                                                 }
//         //                                               : null,
//         //                                           child: Container(
//         //                                             decoration: BoxDecoration(
//         //                                               borderRadius: BorderRadius.circular(5),
//         //                                               border: Border.all(color: kNeutralColor400),
//         //                                             ),
//         //                                             child: Padding(
//         //                                               padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
//         //                                               child: Text(
//         //                                                 "-",
//         //                                                 style: kButton14MediumStyle.copyWith(color: tab.poopCount > 0 ? kTextBodyColor : kNeutralColor500),
//         //                                               ),
//         //                                             ),
//         //                                           ),
//         //                                         ),
//         //                                         Padding(
//         //                                           padding: const EdgeInsets.symmetric(horizontal: 40.0),
//         //                                           child: Row(
//         //                                             children: [
//         //                                               const Icon(
//         //                                                 Puppycat_social.icon_comment,
//         //                                                 color: kTextTitleColor,
//         //                                               ),
//         //                                               const SizedBox(
//         //                                                 width: 8,
//         //                                               ),
//         //                                               Text(
//         //                                                 "${tab.poopCount}",
//         //                                                 style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
//         //                                               ),
//         //                                             ],
//         //                                           ),
//         //                                         ),
//         //                                         InkWell(
//         //                                           onTap: tab.poopCount < 99
//         //                                               ? () {
//         //                                                   setState(() {
//         //                                                     tab.poopCount += 1;
//         //                                                   });
//         //                                                 }
//         //                                               : null,
//         //                                           child: Container(
//         //                                             decoration: BoxDecoration(
//         //                                               borderRadius: BorderRadius.circular(5),
//         //                                               border: Border.all(color: kNeutralColor400),
//         //                                             ),
//         //                                             child: Padding(
//         //                                               padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
//         //                                               child: Text(
//         //                                                 "+",
//         //                                                 style: kButton14MediumStyle.copyWith(color: tab.poopCount < 99 ? kTextBodyColor : kNeutralColor500),
//         //                                               ),
//         //                                             ),
//         //                                           ),
//         //                                         ),
//         //                                       ],
//         //                                     ),
//         //                                   )
//         //                                 ],
//         //                               ),
//         //                             ),
//         //                             const Padding(
//         //                               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                               child: Divider(
//         //                                 thickness: 1,
//         //                                 height: 1,
//         //                                 color: kNeutralColor300,
//         //                               ),
//         //                             ),
//         //                             Padding(
//         //                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //                               child: Row(
//         //                                 children: [
//         //                                   Padding(
//         //                                     padding: const EdgeInsets.only(right: 20.0),
//         //                                     child: Text(
//         //                                       "양",
//         //                                       style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                     ),
//         //                                   ),
//         //                                   Expanded(
//         //                                     child: Row(
//         //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                                       children: [
//         //                                         for (var i = 0; i < poopAmountList.length; i++)
//         //                                           GestureDetector(
//         //                                             onTap: () {
//         //                                               setState(() {
//         //                                                 tab.poopAmount = i;
//         //                                               });
//         //                                             },
//         //                                             child: Container(
//         //                                               decoration: tab.poopAmount == i
//         //                                                   ? BoxDecoration(
//         //                                                       borderRadius: BorderRadius.circular(100),
//         //                                                       color: kPrimaryLightColor,
//         //                                                     )
//         //                                                   : null,
//         //                                               child: Padding(
//         //                                                 padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         //                                                 child: Text(
//         //                                                   poopAmountList[i],
//         //                                                   style: kBody13RegularStyle.copyWith(
//         //                                                     color: tab.poopAmount == i ? kPrimaryColor : kTextBodyColor,
//         //                                                   ),
//         //                                                 ),
//         //                                               ),
//         //                                             ),
//         //                                           )
//         //                                       ],
//         //                                     ),
//         //                                   )
//         //                                 ],
//         //                               ),
//         //                             ),
//         //                             const Padding(
//         //                               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                               child: Divider(
//         //                                 thickness: 1,
//         //                                 height: 1,
//         //                                 color: kNeutralColor300,
//         //                               ),
//         //                             ),
//         //                             Padding(
//         //                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //                               child: Row(
//         //                                 children: [
//         //                                   Padding(
//         //                                     padding: const EdgeInsets.only(right: 20.0),
//         //                                     child: Text(
//         //                                       "색",
//         //                                       style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                     ),
//         //                                   ),
//         //                                   Expanded(
//         //                                     child: Row(
//         //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                                       children: [
//         //                                         for (var i = 0; i < poopColorList.length; i++)
//         //                                           GestureDetector(
//         //                                             onTap: () {
//         //                                               setState(() {
//         //                                                 tab.poopColor = i;
//         //                                               });
//         //                                             },
//         //                                             child: Container(
//         //                                               decoration: tab.poopColor == i
//         //                                                   ? BoxDecoration(
//         //                                                       borderRadius: BorderRadius.circular(100),
//         //                                                       color: kPrimaryLightColor,
//         //                                                     )
//         //                                                   : null,
//         //                                               child: Padding(
//         //                                                 padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         //                                                 child: Text(
//         //                                                   poopColorList[i],
//         //                                                   style: kBody13RegularStyle.copyWith(
//         //                                                     color: tab.poopColor == i ? kPrimaryColor : kTextBodyColor,
//         //                                                   ),
//         //                                                 ),
//         //                                               ),
//         //                                             ),
//         //                                           )
//         //                                       ],
//         //                                     ),
//         //                                   )
//         //                                 ],
//         //                               ),
//         //                             ),
//         //                             const Padding(
//         //                               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                               child: Divider(
//         //                                 thickness: 1,
//         //                                 height: 1,
//         //                                 color: kNeutralColor300,
//         //                               ),
//         //                             ),
//         //                             Padding(
//         //                               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //                               child: Row(
//         //                                 children: [
//         //                                   Padding(
//         //                                     padding: const EdgeInsets.only(right: 10.0),
//         //                                     child: Text(
//         //                                       "형태",
//         //                                       style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//         //                                     ),
//         //                                   ),
//         //                                   Expanded(
//         //                                     child: Row(
//         //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                                       children: [
//         //                                         for (var i = 0; i < poopFormList.length; i++)
//         //                                           GestureDetector(
//         //                                             onTap: () {
//         //                                               setState(() {
//         //                                                 tab.poopForm = i;
//         //                                               });
//         //                                             },
//         //                                             child: Container(
//         //                                               decoration: tab.poopForm == i
//         //                                                   ? BoxDecoration(
//         //                                                       borderRadius: BorderRadius.circular(100),
//         //                                                       color: kPrimaryLightColor,
//         //                                                     )
//         //                                                   : null,
//         //                                               child: Padding(
//         //                                                 padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         //                                                 child: Text(
//         //                                                   poopFormList[i],
//         //                                                   style: kBody13RegularStyle.copyWith(
//         //                                                     color: tab.poopForm == i ? kPrimaryColor : kTextBodyColor,
//         //                                                   ),
//         //                                                 ),
//         //                                               ),
//         //                                             ),
//         //                                           )
//         //                                       ],
//         //                                     ),
//         //                                   )
//         //                                 ],
//         //                               ),
//         //                             ),
//         //                             const Padding(
//         //                               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         //                             ),
//         //                           ],
//         //                         ),
//         //                     ],
//         //                   ),
//         //                 ),
//         //               ),
//         //             ],
//         //           );
//         //         }).toList(),
//         //       ),
//         //     ),
//         //   ],
//         // )),
//       ),
//     );
//   }
// }
