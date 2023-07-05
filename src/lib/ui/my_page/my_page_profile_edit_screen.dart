import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class MyPageProfileEditScreen extends ConsumerStatefulWidget {
  const MyPageProfileEditScreen({super.key});

  @override
  MyPageProfileEditScreenState createState() => MyPageProfileEditScreenState();
}

class MyPageProfileEditScreenState
    extends ConsumerState<MyPageProfileEditScreen> {
  String? imageFile;
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

  Future openGallery() async {
    selectedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    setState(() {
      imageFile = selectedImage!.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0.h),
                  child: Column(
                    children: [
                      Text(
                        "이전으로 돌아가시겠어요?",
                        style:
                            kBody16BoldStyle.copyWith(color: kTextTitleColor),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "지금 돌아가시면 수정사항은\n저장되지 않습니다.",
                        style:
                            kBody12RegularStyle.copyWith(color: kTextBodyColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                confirmTap: () {
                  context.pop();
                  context.pop();
                },
                cancelTap: () {
                  context.pop();
                },
                confirmWidget: Text(
                  "확인",
                  style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
                ));
          },
        );
        return false;
      },
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    content: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0.h),
                      child: Column(
                        children: [
                          Text(
                            "이전으로 돌아가시겠어요?",
                            style: kBody16BoldStyle.copyWith(
                                color: kTextTitleColor),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "지금 돌아가시면 수정사항은\n저장되지 않습니다.",
                            style: kBody12RegularStyle.copyWith(
                                color: kTextBodyColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    confirmTap: () {
                      context.pop();
                      context.pop();
                    },
                    cancelTap: () {
                      context.pop();
                    },
                    confirmWidget: Text(
                      "확인",
                      style:
                          kButton14MediumStyle.copyWith(color: kPrimaryColor),
                    ));
              },
            );
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text(
                "내 정보 수정",
              ),
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                TextButton(
                  child: Text(
                    '완료',
                    style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0.h, bottom: 30.h),
                  child: Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: WidgetMask(
                            blendMode: BlendMode.srcATop,
                            childSaveLayer: true,
                            mask: Center(
                              child: selectedImage == null
                                  ? Image.asset(
                                      'assets/image/feed/image/sample_image3.png',
                                      height: 84.h,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.file(
                                      File(selectedImage!.path),
                                      width: 135,
                                      height: 135,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            child: SvgPicture.asset(
                              'assets/image/feed/image/squircle.svg',
                              height: 84.h,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              showCustomModalBottomSheet(
                                context: context,
                                widget: Column(
                                  children: [
                                    BottomSheetButtonItem(
                                      iconImage:
                                          'assets/image/feed/icon/small_size/icon_user_de.png',
                                      title: '앨범에서 선택',
                                      titleStyle: kButton14BoldStyle.copyWith(
                                          color: kTextSubTitleColor),
                                      onTap: () {
                                        context.pop();

                                        openGallery();
                                      },
                                    ),
                                    BottomSheetButtonItem(
                                      iconImage:
                                          'assets/image/feed/icon/small_size/icon_report.png',
                                      title: '프로필 사진 삭제',
                                      titleStyle: kButton14BoldStyle.copyWith(
                                          color: kBadgeColor),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: kNeutralColor100,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: -2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: -5,
                        blurRadius: 7,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 32.h, left: 12.0.w, bottom: 8.h),
                        child: Text(
                          "프로필 정보",
                          style: kTitle16ExtraBoldStyle.copyWith(
                              color: kTextTitleColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24.0.w, bottom: 8.h),
                        child: Text(
                          "닉네임",
                          style: kBody13BoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 32.h,
                                child: FormBuilderTextField(
                                  initialValue: "왕티즈왕왕",
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: kNeutralColor300,
                                    counterText: "",
                                    hintText: '닉네임을 입력해 주세요',
                                    hintStyle: kBody12RegularStyle.copyWith(
                                        color: kNeutralColor500),
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                  name: 'content',
                                  style: kBody13RegularStyle.copyWith(
                                      color: kTextBodyColor),
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 56.w,
                              height: 32.h,
                              decoration: const BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "변경",
                                  style: kButton12BoldStyle.copyWith(
                                      color: kPrimaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24.0.w, bottom: 8.h, top: 8.h),
                        child: Text(
                          "한 줄 소개",
                          style: kBody13BoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                        child: SizedBox(
                            height: 32.h,
                            child: FormBuilderTextField(
                              decoration: InputDecoration(
                                  counterText: "",
                                  hintText: '소개 글을 입력해 주세요.',
                                  hintStyle: kBody12RegularStyle.copyWith(
                                      color: kNeutralColor500),
                                  contentPadding: const EdgeInsets.all(16)),
                              name: 'content',
                              style: kBody13RegularStyle.copyWith(
                                  color: kTextSubTitleColor),
                              textAlignVertical: TextAlignVertical.center,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 16.h, left: 12.0.w, bottom: 8.h),
                        child: Text(
                          "로그인 정보",
                          style: kTitle16ExtraBoldStyle.copyWith(
                              color: kTextTitleColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24.0.w, bottom: 8.h),
                        child: Text(
                          "이메일",
                          style: kBody13BoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                        child: SizedBox(
                          height: 32.h,
                          child: FormBuilderTextField(
                            initialValue: "abcde@gmail.com",
                            enabled: false,
                            decoration: InputDecoration(
                              prefixIcon: Image.asset(
                                'assets/image/signUpScreen/kakao_icon.png',
                                width: 16,
                                height: 16,
                              ),
                              filled: true,
                              fillColor: kNeutralColor300,
                              counterText: "",
                              hintStyle: kBody12RegularStyle.copyWith(
                                  color: kNeutralColor500),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            name: 'content',
                            style: kBody13RegularStyle.copyWith(
                                color: kTextBodyColor),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24.0.w, bottom: 8.h, top: 8.h),
                        child: Text(
                          "이름",
                          style: kBody13BoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                        child: SizedBox(
                            height: 32.h,
                            child: FormBuilderTextField(
                              enabled: false,
                              initialValue: "김댕댕",
                              decoration: InputDecoration(
                                  counterText: "",
                                  hintStyle: kBody12RegularStyle.copyWith(
                                      color: kNeutralColor500),
                                  filled: true,
                                  fillColor: kNeutralColor300,
                                  contentPadding: const EdgeInsets.all(16)),
                              name: 'content',
                              style: kBody13RegularStyle.copyWith(
                                  color: kTextSubTitleColor),
                              textAlignVertical: TextAlignVertical.center,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24.0.w, bottom: 8.h, top: 8.h),
                        child: Text(
                          "휴대폰 번호",
                          style: kBody13BoldStyle.copyWith(
                              color: kTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 32.h,
                                child: FormBuilderTextField(
                                  initialValue: "010-1234-1234",
                                  enabled: false,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: kNeutralColor300,
                                    counterText: "",
                                    hintStyle: kBody12RegularStyle.copyWith(
                                        color: kNeutralColor500),
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                  name: 'content',
                                  style: kBody13RegularStyle.copyWith(
                                      color: kTextBodyColor),
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 56.w,
                              height: 32.h,
                              decoration: const BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "변경",
                                  style: kButton12BoldStyle.copyWith(
                                      color: kPrimaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.0.h),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              context.go(
                                  "/home/myPage/profileEdit/withdrawalSelect");
                            },
                            child: Text(
                              "회원 탈퇴",
                              style: kButton12BoldStyle.copyWith(
                                  color: kTextBodyColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
