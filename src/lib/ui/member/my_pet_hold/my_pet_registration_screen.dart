///NOTE
///2023.11.14.
///산책하기 보류로 전체 주석 처리
// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:just_the_tooltip/just_the_tooltip.dart';
// import 'package:lottie/lottie.dart';
// import 'package:numberpicker/numberpicker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_time_spinner.dart';
// import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/i18n_model.dart';
// import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
// import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
// import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
// import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';
// import 'package:pet_mobile_social_flutter/config/constants.dart';
// import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
// import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
// import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
// import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/pet_detail/pet_detail_item_model.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/edit_my_information/edit_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/create_my_pet/allergy_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/create_my_pet/create_my_pet_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/create_my_pet/health_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/my_pet_common_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/my_pet_list/my_pet_list_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/my_post/my_post_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
// import 'package:pet_mobile_social_flutter/ui/feed/feed_write/feed_write_location_search_screen.dart';
// import 'package:pet_mobile_social_flutter/ui/my_page/my_pet/my_pet_breed_search_screen.dart';
// import 'package:thumbor/thumbor.dart';
// import 'package:widget_mask/widget_mask.dart';
// import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
//
// final _formKey = GlobalKey<FormState>();
//
// class MyPetRegistrationScreen extends ConsumerStatefulWidget {
//   const MyPetRegistrationScreen({super.key});
//
//   @override
//   MyPetRegistrationScreenState createState() => MyPetRegistrationScreenState();
// }
//
// class MyPetRegistrationScreenState extends ConsumerState<MyPetRegistrationScreen> with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController breedController = TextEditingController();
//   TextEditingController ageEditingController = TextEditingController();
//   TextEditingController personalityController = TextEditingController();
//
//   FocusNode breedFocusNode = FocusNode();
//   bool isReadOnly = true;
//   double weightValue = 1.0;
//
//   final ImagePicker _picker = ImagePicker();
//   XFile? selectedImage;
//   bool isProfileImageDelete = false;
//
//   final RegExp _letterRegExp = RegExp(r'[가-힣a-zA-Z0-9_]');
//
//   Future openGallery() async {
//     selectedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
//
//     setState(() {
//       isProfileImageDelete = false;
//     });
//   }
//
//   String? personalityValue;
//   int? breedValue;
//
//   final List<int> _healthItems = [];
//   final List<int> _allergyItems = [];
//
//   @override
//   void initState() {
//     ref.read(healthStateProvider.notifier).getHealthList();
//     ref.read(allergyStateProvider.notifier).getAllergyList();
//
//     tabController = TabController(
//       initialIndex: 0,
//       length: 2,
//       vsync: this,
//     );
//
//     breedFocusNode.addListener(() {
//       if (!breedFocusNode.hasFocus) {
//         setState(() {
//           isReadOnly = true;
//         });
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final nameProvider = ref.watch(nickNameProvider);
//     final genderSelected = ref.watch(myPetGenderProvider);
//     final sizeSelected = ref.watch(myPetSizeProvider);
//     final ageSelected = ref.watch(myPetAgeProvider);
//
//     void showConfirmDialog(String message, bool isHealthTab) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CustomDialog(
//             content: Padding(
//               padding: EdgeInsets.symmetric(vertical: 24.0.h),
//               child: Column(
//                 children: [
//                   Text(
//                     message,
//                     style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
//                   ),
//                 ],
//               ),
//             ),
//             confirmTap: () {
//               context.pop();
//               if (isHealthTab) tabController.animateTo(1);
//             },
//             confirmWidget: Text(
//               "확인",
//               style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
//             ),
//           );
//         },
//       );
//     }
//
//     return ConditionalWillPopScope(
//       shouldAddCallback: true,
//       onWillPop: () async {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return CustomDialog(
//                 content: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 24.0.h),
//                   child: Column(
//                     children: [
//                       Text(
//                         "이전으로 돌아가시겠어요?",
//                         style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
//                       ),
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       Text(
//                         "지금 돌아가시면 수정사항은\n저장되지 않습니다.",
//                         style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 confirmTap: () {
//                   context.pop();
//                   context.pop();
//                   ref.watch(editStateProvider.notifier).resetState();
//                 },
//                 cancelTap: () {
//                   context.pop();
//                 },
//                 confirmWidget: Text(
//                   "확인",
//                   style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
//                 ));
//           },
//         );
//         return false;
//       },
//       child: Material(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//             title: const Text(
//               "우리 아이 등록",
//             ),
//             leading: IconButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return CustomDialog(
//                         content: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 24.0.h),
//                           child: Column(
//                             children: [
//                               Text(
//                                 "이전으로 돌아가시겠어요?",
//                                 style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
//                               ),
//                               SizedBox(
//                                 height: 4.h,
//                               ),
//                               Text(
//                                 "지금 돌아가시면 수정사항은\n저장되지 않습니다.",
//                                 style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                         confirmTap: () {
//                           context.pop();
//                           context.pop();
//                           ref.watch(editStateProvider.notifier).resetState();
//                         },
//                         cancelTap: () {
//                           context.pop();
//                         },
//                         confirmWidget: Text(
//                           "확인",
//                           style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
//                         ));
//                   },
//                 );
//               },
//               icon: const Icon(
//                 Puppycat_social.icon_back,
//                 size: 40,
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () async {
//                   final BuildContext currentContext = context;
//
//                   if (nameController.text.isEmpty) {
//                     showConfirmDialog('이름을 입력해주세요.', false);
//                     return;
//                   } else if (breedController.text.isEmpty) {
//                     showConfirmDialog('품종을 입력해주세요.', false);
//                     return;
//                   } else if (weightValue == null) {
//                     showConfirmDialog('무게를 입력해주세요.', false);
//                     return;
//                   } else if (ageEditingController.text.isEmpty) {
//                     showConfirmDialog('생년월일을 입력해주세요.', false);
//                     return;
//                   } else if (_healthItems.isEmpty) {
//                     showConfirmDialog('건강질환 정보를 입력해주세요.', true);
//                     return;
//                   } else if (_allergyItems.isEmpty) {
//                     showConfirmDialog('알러지 정보를 입력해주세요.', true);
//                     return;
//                   }
//
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return CustomDialog(
//                           content: Padding(
//                             padding: EdgeInsets.symmetric(vertical: 24.0.h),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   "반려동물을 등록 하시겠습니까?",
//                                   style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           confirmTap: () async {
//                             context.pop();
//                             showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return WillPopScope(
//                                   onWillPop: () async => false,
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       color: Colors.black.withOpacity(0.6),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Lottie.asset(
//                                           'assets/lottie/icon_loading.json',
//                                           fit: BoxFit.fill,
//                                           width: 80,
//                                           height: 80,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//
//                             PetDetailItemModel petDetailItemModel = PetDetailItemModel(
//                               memberIdx: ref.read(userInfoProvider).userModel!.idx,
//                               name: nameController.text,
//                               gender: ref.watch(myPetGenderProvider.notifier).state,
//                               breedIdx: breedValue,
//                               breedNameEtc: breedController.text,
//                               size: ref.watch(myPetSizeProvider.notifier).state,
//                               weight: weightValue.toDouble(),
//                               age: ref.watch(myPetAgeProvider.notifier).state,
//                               birth: ageEditingController.text,
//                               personalityCode: personalityValue == null ? null : int.parse(personalityValue!),
//                               personalityEtc: personalityController.text,
//                               resetState: 0,
//                               healthIdxList: _healthItems,
//                               allergyIdxList: _allergyItems,
//                             );
//                             final result = await ref.watch(createMyPetStateProvider.notifier).postMyPet(
//                                   petDetailItemModel: petDetailItemModel,
//                                   file: selectedImage,
//                                 );
//
//                             if (mounted) {
//                               Navigator.of(currentContext).pop();
//                             }
//
//                             if (result.result) {
//                               if (mounted) {
//                                 ref.read(myPetListStateProvider).refresh();
//                                 Navigator.of(currentContext).pop();
//                               }
//                             }
//                           },
//                           cancelTap: () {
//                             context.pop();
//                           },
//                           confirmWidget: Text(
//                             "확인",
//                             style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
//                           ));
//                     },
//                   );
//                 },
//                 child: Text(
//                   '완료',
//                   style: kButton12BoldStyle.copyWith(
//                     color: kPrimaryColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(top: 20.0.h, bottom: 30.h),
//                   child: Center(
//                     child: Stack(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//                           child: WidgetMask(
//                             blendMode: BlendMode.srcATop,
//                             childSaveLayer: true,
//                             mask: Center(
//                               child: selectedImage == null
//                                   ? const Icon(
//                                       Puppycat_social.icon_profile_large,
//                                       size: 92,
//                                       color: kNeutralColor500,
//                                     )
//                                   : Image.file(
//                                       File(selectedImage!.path),
//                                       width: 135,
//                                       height: 135,
//                                       fit: BoxFit.cover,
//                                     ),
//                             ),
//                             child: SvgPicture.asset(
//                               'assets/image/feed/image/squircle.svg',
//                               height: 84.h,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: GestureDetector(
//                             onTap: () {
//                               showCustomModalBottomSheet(
//                                 context: context,
//                                 widget: Column(
//                                   children: [
//                                     BottomSheetButtonItem(
//                                       icon: const Icon(
//                                         Puppycat_social.icon_photo,
//                                       ),
//                                       title: '앨범에서 선택',
//                                       titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
//                                       onTap: () async {
//                                         context.pop();
//
//                                         if (await Permissions.getPhotosPermissionState()) {
//                                           openGallery();
//                                         } else {
//                                           if (mounted) {
//                                             showDialog(
//                                               context: context,
//                                               builder: (BuildContext context) {
//                                                 return CustomDialog(
//                                                     content: Padding(
//                                                       padding: EdgeInsets.symmetric(vertical: 24.0.h),
//                                                       child: Column(
//                                                         children: [
//                                                           Text(
//                                                             "퍼피캣 접근 권한 허용",
//                                                             style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 4.h,
//                                                           ),
//                                                           Text(
//                                                             "반려동물 사진 등록을 위해\n사진 접근을 허용해 주세요.",
//                                                             style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
//                                                             textAlign: TextAlign.center,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     confirmTap: () {
//                                                       context.pop();
//                                                       openAppSettings();
//                                                     },
//                                                     cancelTap: () {
//                                                       context.pop();
//                                                     },
//                                                     confirmWidget: Text(
//                                                       "허용",
//                                                       style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
//                                                     ),
//                                                     cancelWidget: Text(
//                                                       "허용 안 함",
//                                                       style: kButton14MediumStyle.copyWith(color: kTextSubTitleColor),
//                                                     ));
//                                               },
//                                             );
//                                           }
//                                         }
//                                       },
//                                     ),
//                                     BottomSheetButtonItem(
//                                       icon: const Icon(
//                                         Puppycat_social.icon_delete_small,
//                                         color: kBadgeColor,
//                                       ),
//                                       title: '프로필 사진 삭제',
//                                       titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
//                                       onTap: () {
//                                         setState(() {
//                                           selectedImage = null;
//                                           isProfileImageDelete = false;
//                                         });
//                                         context.pop();
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               width: 32.w,
//                               height: 32.h,
//                               decoration: BoxDecoration(
//                                 color: kNeutralColor100,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: -2,
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Icon(
//                                 Puppycat_social.icon_modify_medium,
//                                 color: kTextBodyColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(20.0),
//                       topRight: Radius.circular(20.0),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.4),
//                         spreadRadius: -5,
//                         blurRadius: 7,
//                         offset: const Offset(0, -6),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 24.0, top: 32),
//                         child: Row(
//                           children: [
//                             Text(
//                               "이름",
//                               style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
//                             ),
//                             Text(
//                               "*",
//                               style: kBody12SemiBoldStyle.copyWith(color: kPrimaryColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 24.0, top: 8),
//                         child: TextFormField(
//                           controller: nameController,
//                           decoration: InputDecoration(
//                             hintText: '이름을 입력해주세요',
//                             hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),dy12RegularStyle.copyWith(color: kNeutralColor500),
//                             errorStyle: kBody11RegularStyle.copyWith(color: kBadgeColor, fontWeight: FontWeight.w400, height: 1.2),
//                             errorText: getNickDescription(nameProvider),
//                             errorBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 1,
//                                 color: kBadgeColor,
//                               ),
//                             ),
//                             errorMaxLines: 2,
//                             counterText: '',
//                             isDense: true,
//                             contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                           ),
//                           style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//                           maxLength: 20,
//                           autovalidateMode: AutovalidateMode.always,
//                           onChanged: (value) {
//                             if (value.isNotEmpty) {
//                               if (value.length > 1) {
//                                 setState(() {
//                                   // ref.read(checkButtonProvider.notifier).state = true;
//                                 });
//                               }
//                               if (value == ref.watch(editStateProvider).userInfoModel!.userModel!.nick) {
//                                 setState(() {
//                                   // ref.read(checkButtonProvider.notifier).state = false;
//                                 });
//                               }
//                               String lastChar = value[value.length - 1];
//                               if (lastChar.contains(RegExp(r'[a-zA-Z]'))) {
//                                 nameController.value = TextEditingValue(text: toLowercase(value), selection: nameController.selection);
//                                 return;
//                               }
//                             } else {
//                               setState(() {
//                                 // ref.read(checkButtonProvider.notifier).state = false;
//                               });
//                             }
//                             ref.read(nickNameProvider.notifier).state = NickNameStatus.nonValid;
//                           },
//                           validator: (value) {
//                             if (value != null) {
//                               if (value.isNotEmpty) {
//                                 if (_letterRegExp.allMatches(value).length != value.length) {
//                                   Future(() {
//                                     ref.watch(nickNameProvider.notifier).state = NickNameStatus.invalidLetter;
//                                   });
//                                   return getNickDescription(NickNameStatus.invalidLetter);
//                                 } else if (value.isNotEmpty && value.length < 2) {
//                                   Future(() {
//                                     ref.watch(nickNameProvider.notifier).state = NickNameStatus.minLength;
//                                   });
//                                   return getNickDescription(NickNameStatus.minLength);
//                                 } else {
//                                   // isCheckableNickName = true;
//                                   return null;
//                                 }
//                               }
//                             }
//                           },
//                           onSaved: (val) {},
//                         ),
//                       ),
//                       Text("품종"),
//                       TextFormField(
//                         controller: breedController,
//                         readOnly: isReadOnly,
//                         focusNode: breedFocusNode,
//                         onFieldSubmitted: (value) {
//                           setState(() {
//                             isReadOnly = true;
//                           });
//                         },
//                         onTap: () async {
//                           if (isReadOnly) {
//                             final result = await Navigator.of(context).push(
//                               PageRouteBuilder(
//                                 opaque: false, // set to false
//                                 pageBuilder: (_, __, ___) => const MyPetBreedSearchScreen(),
//                               ),
//                             );
//
//                             breedController.text = result['name'];
//                             breedValue = result['idx'];
//
//                             if (breedController.text == "") {
//                               isReadOnly = !isReadOnly;
//                               if (!isReadOnly) {
//                                 FocusScope.of(context).requestFocus(breedFocusNode);
//                               }
//                             }
//                           }
//                         },
//                         decoration: InputDecoration(
//                           hintText: '품종 검색',
//                           hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),dy12RegularStyle.copyWith(color: kNeutralColor500),
//                           errorMaxLines: 2,
//                           counterText: '',
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                         ),
//                         style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//                         maxLength: 20,
//                       ),
//                       Text("성별"),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12.0.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: PetGender.values.map((item) {
//                             return Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       ref.watch(myPetGenderProvider.notifier).state = item.value;
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(8.0),
//                                     decoration: genderSelected == item.value
//                                         ? BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             color: kPrimaryLightColor,
//                                           )
//                                         : BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             border: Border.all(color: kNeutralColor400),
//                                           ),
//                                     child: Center(
//                                       child: Text(
//                                         item.name,
//                                         style: kButton14BoldStyle.copyWith(color: genderSelected == item.value ? kPrimaryColor : kTextBodyColor),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       Text("크기"),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12.0.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: PetSize.values.map((item) {
//                             return Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       ref.watch(myPetSizeProvider.notifier).state = item.value; // state에 code 값을 설정
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(8.0),
//                                     decoration: sizeSelected == item.value
//                                         ? BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             color: kPrimaryLightColor,
//                                           )
//                                         : BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             border: Border.all(color: kNeutralColor400),
//                                           ),
//                                     child: Center(
//                                       child: Text(
//                                         item.name,
//                                         style: kButton14BoldStyle.copyWith(color: sizeSelected == item.value ? kPrimaryColor : kTextBodyColor),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       Text(
//                         "무게 ${weightValue} kg",
//                       ),
//                       DecimalNumberPicker(
//                         minValue: 1,
//                         maxValue: 50,
//                         value: weightValue,
//                         onChanged: (value) => setState(() => weightValue = value),
//                         decimalPlaces: 1,
//                       ),
//                       Row(
//                         children: [
//                           Text("연령이 어떻게 되나요?"),
//                           JustTheTooltip(
//                             child: Material(
//                               color: Colors.grey.shade800,
//                               shape: const CircleBorder(),
//                               elevation: 4.0,
//                               child: const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Icon(
//                                   Icons.question_mark,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             preferredDirection: AxisDirection.up,
//                             content: const Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 '생후 1세 이하\n강아지 : 퍼피 ㅣ 고양이 : 키튼\n7세 미만\n강아지&고양이 공통 : 어덜트\n7세 이상\n강아지&고양이 공통 : 시니어',
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12.0.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: PetAge.values.map((item) {
//                             return Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       ref.watch(myPetAgeProvider.notifier).state = item.value;
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(8.0),
//                                     decoration: ageSelected == item.value
//                                         ? BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             color: kPrimaryLightColor,
//                                           )
//                                         : BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             border: Border.all(color: kNeutralColor400),
//                                           ),
//                                     child: Center(
//                                       child: Text(
//                                         item.name,
//                                         style: kButton14BoldStyle.copyWith(color: ageSelected == item.value ? kPrimaryColor : kTextBodyColor),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       Text("생년월일"),
//                       TextFormField(
//                         readOnly: true,
//                         controller: ageEditingController,
//                         onTap: () async {
//                           DatePicker.showDatePicker(
//                             context,
//                             showTitleActions: true,
//                             minTime: DateTime(1930, 1, 1),
//                             maxTime: DateTime.now(),
//                             onConfirm: (date) {
//                               setState(() {
//                                 ageEditingController.text = DateFormat('yyyy-MM-dd').format(date);
//                               });
//                             },
//                             currentTime: ageEditingController.text == "" ? DateTime(2020, 01, 01) : DateTime.parse(ageEditingController.text),
//                             locale: LocaleType.ko,
//                             theme: picker_theme.DatePickerTheme(
//                               itemStyle: kButton14MediumStyle.copyWith(color: kNeutralColor600),
//                               backgroundColor: kNeutralColor100,
//                               title: "나이 입력하기",
//                             ),
//                           );
//                         },
//                         decoration: InputDecoration(
//                           hintText: '생년월일',
//                           hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),dy12RegularStyle.copyWith(color: kNeutralColor500),
//                           errorMaxLines: 2,
//                           counterText: '',
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                         ),
//                         style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//                         maxLength: 20,
//                       ),
//                       Text("성격 및 특징"),
//                       DropdownButtonHideUnderline(
//                         child: DropdownButton2<String>(
//                           isExpanded: true,
//                           hint: Text(
//                             '우리 아이 성격은 어떤가요',
//                           ),
//                           items: PetCharacter.values
//                               .map(
//                                 (PetCharacter item) => DropdownMenuItem<String>(
//                                   value: item.value.toString(),
//                                   child: Text(
//                                     item.name,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                           value: personalityValue,
//                           onChanged: (String? value) {
//                             setState(() {
//                               personalityValue = value;
//                             });
//                           },
//                           buttonStyleData: const ButtonStyleData(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             height: 40,
//                             width: 140,
//                           ),
//                           menuItemStyleData: const MenuItemStyleData(
//                             height: 40,
//                           ),
//                         ),
//                       ),
//                       if (personalityValue == '7')
//                         TextFormField(
//                           controller: personalityController,
//                           decoration: InputDecoration(
//                             hintText: '우리 아이 성격은 어떤가요?',
//                             hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),dy12RegularStyle.copyWith(color: kNeutralColor500),
//                             errorMaxLines: 2,
//                             counterText: '',
//                             isDense: true,
//                             contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                           ),
//                           style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
//                           maxLength: 40,
//                         ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _secondTabBody() {
//     return ListView(
//       children: [
//         Text("걱정되는 건강질환이 있나요?"),
//         Consumer(builder: (context, ref, child) {
//           final healthState = ref.watch(healthStateProvider);
//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               mainAxisSpacing: 2,
//               crossAxisCount: 4,
//               crossAxisSpacing: 2,
//             ),
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: healthState.list.length,
//             itemBuilder: (BuildContext context, int i) {
//               final item = healthState.list[i];
//               final isSelected = _healthItems.contains(item.idx);
//               return InkWell(
//                 onTap: () {
//                   if (item.name == "없어요") {
//                     if (isSelected) {
//                       _healthItems.remove(item.idx);
//                     } else {
//                       _healthItems.clear();
//                       _healthItems.add(item.idx!);
//                     }
//                   } else {
//                     if (_healthItems.contains(healthState.list.firstWhere((element) => element.name == "없어요").idx)) {
//                       _healthItems.clear();
//                     }
//
//                     if (isSelected) {
//                       _healthItems.remove(item.idx);
//                     } else {
//                       _healthItems.add(item.idx!);
//                     }
//                   }
//
//                   // Force widget to rebuild and reflect changes
//                   (context as Element).markNeedsBuild();
//                 },
//                 child: Container(
//                   decoration: isSelected
//                       ? BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: kPrimaryLightColor,
//                         )
//                       : BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: kNeutralColor400),
//                         ),
//                   child: Text(
//                     healthState.list[i].name!,
//                     style: kButton14BoldStyle.copyWith(color: kPrimaryColor),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               );
//             },
//           );
//         }),
//         Text("알러지가 있나요?"),
//         Consumer(builder: (context, ref, child) {
//           final allergyState = ref.watch(allergyStateProvider);
//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               mainAxisSpacing: 2,
//               crossAxisCount: 4,
//               crossAxisSpacing: 2,
//             ),
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: allergyState.list.length,
//             itemBuilder: (BuildContext context, int i) {
//               final item = allergyState.list[i];
//               final isSelected = _allergyItems.contains(item.idx);
//               return InkWell(
//                 onTap: () {
//                   if (item.name == "없어요") {
//                     if (isSelected) {
//                       _allergyItems.remove(item.idx);
//                     } else {
//                       _allergyItems.clear();
//                       _allergyItems.add(item.idx!);
//                     }
//                   } else {
//                     if (_allergyItems.contains(allergyState.list.firstWhere((element) => element.name == "없어요").idx)) {
//                       _allergyItems.clear();
//                     }
//
//                     if (isSelected) {
//                       _allergyItems.remove(item.idx);
//                     } else {
//                       _allergyItems.add(item.idx!);
//                     }
//                   }
//                   // Force widget to rebuild and reflect changes
//                   (context as Element).markNeedsBuild();
//                 },
//                 child: Container(
//                   decoration: isSelected
//                       ? BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: kPrimaryLightColor,
//                         )
//                       : BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: kNeutralColor400),
//                         ),
//                   child: Text(
//                     allergyState.list[i].name!,
//                     style: kButton14BoldStyle.copyWith(color: kPrimaryColor),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               );
//             },
//           );
//         }),
//       ],
//     );
//   }
// }
