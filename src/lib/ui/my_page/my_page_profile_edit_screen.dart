import 'dart:io';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/models/sign_up/sign_up_auth_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/edit_my_information/edit_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_information/my_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

final _formKey = GlobalKey<FormState>();

class MyPageProfileEditScreen extends ConsumerStatefulWidget {
  const MyPageProfileEditScreen({super.key});

  @override
  MyPageProfileEditScreenState createState() => MyPageProfileEditScreenState();
}

class MyPageProfileEditScreenState extends ConsumerState<MyPageProfileEditScreen> {
  TextEditingController nickController = TextEditingController();
  TextEditingController introController = TextEditingController();

  final RegExp _letterRegExp = RegExp(r'[가-힣a-zA-Z0-9_]');
  final FocusNode _nickFocusNode = FocusNode();
  bool isCheckableNickName = false;
  bool isValidNickName = false;

  @override
  void initState() {
    Future(() {
      ref.watch(editStateProvider.notifier).resetState();
      introController.text = ref.read(userInfoProvider).userModel!.introText ?? "";
    });

    super.initState();
  }

  @override
  void dispose() {
    nickController.dispose();
    introController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

  bool isProfileEdit = false;
  bool isPhoneNumberEdit = false;
  bool isNextStep = false;
  bool isProfileImageDelete = false;

  Future openGallery() async {
    selectedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    setState(() {
      isNextStep = true;
      isProfileImageDelete = false;
    });
  }

  bool isTotalNextStep = false;

  void checkNextStep() {
    if (ref.watch(nickNameProvider) == NickNameStatus.valid || nickController.text == ref.watch(editStateProvider).userInfoModel!.userModel!.nick) {
      // 닉네임 상태가 valid이거나 닉네임이 기존과 같을 때
      setState(() {
        isTotalNextStep = true;
      });
    } else if (ref.watch(nickNameProvider) == NickNameStatus.none) {
      // 닉네임 상태가 valid가 아니고 none 상태일 때

      if (ref.watch(editStateProvider).authModel != null || isNextStep) {
        setState(() {
          isTotalNextStep = true;
        });
      } else {
        setState(() {
          isTotalNextStep = false;
        });
      }
    } else {
      setState(() {
        isTotalNextStep = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(passUrlProvider, (previous, next) {
      final url = Uri.encodeComponent(next);
      context.pushNamed('webview', pathParameters: {"url": url, "authType": 'pass'});
    });

    final nickProvider = ref.watch(nickNameProvider);

    checkNextStep();
    // FocusDetector와 ConditionalWillPopScope 모두 IOS 왼쪽으로 swipe할때 뒤로가기 동작하는 이유때문에 넣음
    // FocusDetector를 사용하면 완료하고 나서도 이벤트가 발생하는 문제 발생해서, showDialog를 사용하는곳에서 사용하지 못하기 떄문에 ConditionalWillPopScope 넣음
    // ConditionalWillPopScope 패키지를 사용하면 navigator error가 발생해서 showDialog 뜨는 페이지만 넣는 방향으로 결정
    return ConditionalWillPopScope(
      shouldAddCallback: true,
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
                        style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "지금 돌아가시면 수정사항은\n저장되지 않습니다.",
                        style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                confirmTap: () {
                  context.pop();
                  context.pop();
                  ref.watch(editStateProvider.notifier).resetState();
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
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "내 정보 수정",
            ),
            leading: IconButton(
              onPressed: () {
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
                                style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                "지금 돌아가시면 수정사항은\n저장되지 않습니다.",
                                style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        confirmTap: () {
                          context.pop();
                          context.pop();
                          ref.watch(editStateProvider.notifier).resetState();
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
              },
              icon: const Icon(
                Puppycat_social.icon_back,
                size: 40,
              ),
            ),
            actions: [
              TextButton(
                onPressed: isTotalNextStep
                    ? () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'assets/lottie/icon_loading.json',
                                      fit: BoxFit.fill,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        UserModel userModel = ref.watch(editStateProvider).userInfoModel!.userModel!;

                        UserModel editUserModel = userModel.copyWith(
                          profileImgUrl: selectedImage == null ? null : selectedImage!.path,
                          idx: ref.watch(editStateProvider).userInfoModel!.userModel!.idx,
                          nick: nickController.text == "" ? ref.watch(editStateProvider).userInfoModel!.userModel!.nick : nickController.text,
                          introText: introController.text,
                          phone: ref.watch(editStateProvider).authModel == null ? ref.watch(editStateProvider).userInfoModel!.userModel!.phone : ref.watch(editStateProvider).authModel?.phone,
                          ci: ref.watch(editStateProvider).authModel == null ? ref.watch(editStateProvider).userInfoModel!.userModel!.ci : ref.watch(editStateProvider).authModel?.ci,
                          di: ref.watch(editStateProvider).authModel == null ? ref.watch(editStateProvider).userInfoModel!.userModel!.di : ref.watch(editStateProvider).authModel?.di,
                        );

                        final result = await ref.watch(editStateProvider.notifier).putMyInfo(
                              userInfoModel: editUserModel,
                              file: selectedImage,
                              beforeNick: ref.read(userInfoProvider).userModel!.nick,
                              isProfileImageDelete: isProfileImageDelete,
                              isPhoneNumberEdit: isPhoneNumberEdit,
                            );

                        context.pop();

                        if (result.result) {
                          await ref.read(myInformationStateProvider.notifier).getInitUserInformation(ref.read(userInfoProvider).userModel!.idx);
                          final userInformationState = ref.watch(myInformationStateProvider);
                          final lists = userInformationState.list;

                          ref.read(userInfoProvider.notifier).state = ref.read(userInfoProvider.notifier).state.copyWith(
                                userModel: editUserModel.copyWith(
                                  nick: editUserModel.nick,
                                  introText: editUserModel.introText,
                                  phone: editUserModel.phone,
                                  ci: editUserModel.ci,
                                  di: editUserModel.di,
                                  profileImgUrl: lists[0].profileImgUrl,
                                ),
                              );

                          ///NOTE
                          ///2023.11.17.
                          ///채팅 교체 예정으로 일단 주석 처리
                          //         var chatController = ref.read(chatControllerProvider(ChatControllerInfo(provider: 'matrix', clientName: 'puppycat_${ref.read(userInfoProvider).userModel!.idx}'))).controller;
                          //
                          //         if (selectedImage != null) {
                          //           chatController.setAvatarUrl(lists[0].profileImgUrl!);
                          //         }
                          //         chatController.setDisplayName(null, editUserModel.nick);

                          ///여기까지 채팅 교체 주석
                          context.pop();
                        }
                      }
                    : null,
                child: Text(
                  '완료',
                  style: kButton12BoldStyle.copyWith(
                    color: isTotalNextStep ? kPrimaryColor : kTextBodyColor,
                  ),
                ),
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
                              child: "${ref.watch(editStateProvider).userInfoModel!.userModel!.profileImgUrl}" == ""
                                  ? selectedImage == null
                                      ? const Icon(
                                          Puppycat_social.icon_profile_large,
                                          size: 92,
                                          color: kNeutralColor500,
                                        )
                                      : Image.file(
                                          File(selectedImage!.path),
                                          width: 135,
                                          height: 135,
                                          fit: BoxFit.cover,
                                        )
                                  : selectedImage == null
                                      ? isProfileImageDelete
                                          ? const Icon(
                                              Puppycat_social.icon_profile_large,
                                              size: 92,
                                              color: kNeutralColor500,
                                            )
                                          : Image.network(
                                              Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${ref.read(userInfoProvider).userModel!.profileImgUrl}").toUrl(),
                                              width: 135,
                                              height: 135,
                                              fit: BoxFit.cover,
                                            )
                                      : Image.file(
                                          File(selectedImage!.path),
                                          width: 135,
                                          height: 135,
                                          fit: BoxFit.cover,
                                        )),
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
                                    icon: const Icon(
                                      Puppycat_social.icon_photo,
                                    ),
                                    title: '앨범에서 선택',
                                    titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                    onTap: () async {
                                      context.pop();

                                      if (await Permissions.getPhotosPermissionState()) {
                                        openGallery();
                                      } else {
                                        if (mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialog(
                                                  content: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 24.0.h),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "퍼피캣 접근 권한 허용",
                                                          style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                                                        ),
                                                        SizedBox(
                                                          height: 4.h,
                                                        ),
                                                        Text(
                                                          "프로필 사진 등록을 위해\n사진 접근을 허용해 주세요.",
                                                          style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  confirmTap: () {
                                                    context.pop();
                                                    openAppSettings();
                                                  },
                                                  cancelTap: () {
                                                    context.pop();
                                                  },
                                                  confirmWidget: Text(
                                                    "허용",
                                                    style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
                                                  ),
                                                  cancelWidget: Text(
                                                    "허용 안 함",
                                                    style: kButton14MediumStyle.copyWith(color: kTextSubTitleColor),
                                                  ));
                                            },
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  BottomSheetButtonItem(
                                    icon: const Icon(
                                      Puppycat_social.icon_delete_small,
                                      color: kBadgeColor,
                                    ),
                                    title: '프로필 사진 삭제',
                                    titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
                                    onTap: () {
                                      setState(() {
                                        selectedImage = null;
                                        isNextStep = true;
                                        isProfileImageDelete = true;
                                      });
                                      context.pop();
                                    },
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
                            child: Icon(
                              Puppycat_social.icon_modify_medium,
                              color: kTextBodyColor,
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
                      padding: EdgeInsets.only(top: 32.h, left: 12.0.w, bottom: 8.h),
                      child: Text(
                        "프로필 정보",
                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0.w, bottom: 8.h),
                      child: Text(
                        "닉네임",
                        style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isProfileEdit
                              ? Expanded(
                                  child: SizedBox(
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        controller: nickController,
                                        focusNode: _nickFocusNode,
                                        decoration: nickProvider != NickNameStatus.valid
                                            ? InputDecoration(
                                                hintText: '회원가입.닉네임을 입력해주세요'.tr(),
                                                hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                                                errorStyle: kBody11RegularStyle.copyWith(color: kBadgeColor, fontWeight: FontWeight.w400, height: 1.2),
                                                errorText: getNickDescription(nickProvider),
                                                errorBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: kBadgeColor,
                                                  ),
                                                ),
                                                errorMaxLines: 2,
                                                counterText: '',
                                                isDense: true,
                                                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                              )
                                            : InputDecoration(
                                                hintText: '회원가입.닉네임을 입력해주세요'.tr(),
                                                hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                                                errorText: '회원가입.사용 가능한 닉네임입니다'.tr(),
                                                errorStyle: kBody11RegularStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w400, height: 1.2),
                                                errorBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                                focusedErrorBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                                errorMaxLines: 2,
                                                counterText: '',
                                                isDense: true,
                                                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                              ),
                                        style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                        maxLength: 20,
                                        autovalidateMode: AutovalidateMode.always,
                                        onChanged: (value) {
                                          print("DSA");
                                          checkNextStep();
                                          if (value.isNotEmpty) {
                                            if (value.length > 1) {
                                              setState(() {
                                                ref.read(checkButtonProvider.notifier).state = true;
                                                isNextStep = true;
                                              });
                                            }
                                            if (value == ref.watch(editStateProvider).userInfoModel!.userModel!.nick) {
                                              setState(() {
                                                ref.read(checkButtonProvider.notifier).state = false;
                                              });
                                            }
                                            String lastChar = value[value.length - 1];
                                            if (lastChar.contains(RegExp(r'[a-zA-Z]'))) {
                                              nickController.value = TextEditingValue(text: toLowercase(value), selection: nickController.selection);
                                              return;
                                            }
                                          } else {
                                            setState(() {
                                              ref.read(checkButtonProvider.notifier).state = false;
                                              isNextStep = false;
                                            });
                                          }
                                          ref.read(nickNameProvider.notifier).state = NickNameStatus.nonValid;
                                        },
                                        validator: (value) {
                                          if (value != null) {
                                            if (value.isNotEmpty) {
                                              if (_letterRegExp.allMatches(value).length != value.length) {
                                                Future(() {
                                                  ref.watch(nickNameProvider.notifier).state = NickNameStatus.invalidLetter;
                                                });
                                                return getNickDescription(NickNameStatus.invalidLetter);
                                              } else if (value.isNotEmpty && value.length < 2) {
                                                Future(() {
                                                  ref.watch(nickNameProvider.notifier).state = NickNameStatus.minLength;
                                                });
                                                return getNickDescription(NickNameStatus.minLength);
                                              } else {
                                                isCheckableNickName = true;
                                                return null;
                                              }
                                            }
                                          }
                                        },
                                        onSaved: (val) {
                                          if (isCheckableNickName) {
                                            ref.read(signUpStateProvider.notifier).checkNickName(val!);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: SizedBox(
                                    height: 32.h,
                                    child: Container(
                                      decoration: BoxDecoration(color: kNeutralColor300, borderRadius: BorderRadius.circular(10)),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            ref.watch(editStateProvider).userInfoModel!.userModel!.nick,
                                            style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(width: 8.w),
                          isProfileEdit
                              ? Consumer(builder: (context, ref, widget) {
                                  return GestureDetector(
                                    onTap: ref.watch(checkButtonProvider)
                                        ? () {
                                            if (_formKey.currentState!.validate()) {
                                              _nickFocusNode.unfocus();
                                              _formKey.currentState!.save();
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      width: 56.w,
                                      height: 32.h,
                                      decoration: BoxDecoration(
                                        color: ref.watch(checkButtonProvider) ? kPrimaryLightColor : kNeutralColor300,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "중복확인",
                                          style: kButton12BoldStyle.copyWith(
                                            color: ref.watch(checkButtonProvider) ? kPrimaryColor : kTextBodyColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isProfileEdit = true;
                                      ref.read(nickNameProvider.notifier).state = NickNameStatus.nonValid;
                                    });
                                  },
                                  child: Container(
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
                                        style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0.w, bottom: 8.h, top: 8.h),
                      child: Text(
                        "한 줄 소개",
                        style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: TextField(
                        controller: introController,
                        maxLength: 30,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "${ref.watch(editStateProvider).userInfoModel!.userModel!.introText == "" ? '소개 글을 입력해 주세요.' : ref.watch(editStateProvider).userInfoModel!.userModel!.introText}",
                          hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isNextStep = true;
                          });
                        },
                        style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h, left: 12.0.w, bottom: 8.h),
                      child: Text(
                        "로그인 정보",
                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0.w, bottom: 8.h),
                      child: Text(
                        "이메일",
                        style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: SizedBox(
                        height: 32.h,
                        child: FormBuilderTextField(
                          initialValue: "${ref.watch(editStateProvider).userInfoModel!.userModel!.id}",
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: ref.watch(editStateProvider).userInfoModel!.userModel!.simpleType == "kakao"
                                ? Image.asset(
                                    'assets/image/loginScreen/kakao_icon.png',
                                    width: 16,
                                    height: 16,
                                  )
                                : ref.watch(editStateProvider).userInfoModel!.userModel!.simpleType == "naver"
                                    ? Image.asset(
                                        'assets/image/loginScreen/naver_icon.png',
                                        width: 16,
                                        height: 16,
                                      )
                                    : ref.watch(editStateProvider).userInfoModel!.userModel!.simpleType == "google"
                                        ? Image.asset(
                                            'assets/image/loginScreen/google_icon.png',
                                            width: 16,
                                            height: 16,
                                          )
                                        : ref.watch(editStateProvider).userInfoModel!.userModel!.simpleType == "apple"
                                            ? Image.asset(
                                                'assets/image/loginScreen/apple_icon.png',
                                                width: 16,
                                                height: 16,
                                              )
                                            : SizedBox.shrink(),
                            filled: true,
                            fillColor: kNeutralColor300,
                            counterText: "",
                            hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          name: 'content',
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0.w, bottom: 8.h, top: 8.h),
                      child: Text(
                        "이름",
                        style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: SizedBox(
                        height: 32.h,
                        child: FormBuilderTextField(
                          enabled: false,
                          initialValue: "${ref.watch(editStateProvider).userInfoModel!.userModel!.name}",
                          decoration: InputDecoration(
                              counterText: "", hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500), filled: true, fillColor: kNeutralColor300, contentPadding: const EdgeInsets.all(16)),
                          name: 'content',
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0.w, bottom: 8.h, top: 8.h),
                      child: Text(
                        "휴대폰 번호",
                        style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer(builder: (ctx, ref, child) {
                            return ref.watch(editStateProvider).authModel == null
                                ? Expanded(
                                    child: SizedBox(
                                      height: 32.h,
                                      child: Container(
                                        decoration: BoxDecoration(color: kNeutralColor300, borderRadius: BorderRadius.circular(10)),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16.0),
                                            child: Text(
                                              "${ref.watch(editStateProvider).userInfoModel!.userModel!.phone}",
                                              style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: SizedBox(
                                      height: 32.h,
                                      child: Container(
                                        decoration: BoxDecoration(color: kNeutralColor300, borderRadius: BorderRadius.circular(10)),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16.0),
                                            child: Text(
                                              "${ref.watch(editStateProvider).authModel!.phone}",
                                              style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                          SizedBox(width: 8.w),
                          ref.watch(editStateProvider).authModel == null
                              ? isPhoneNumberEdit
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPhoneNumberEdit = false;
                                        });
                                      },
                                      child: Container(
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
                                            "취소",
                                            style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPhoneNumberEdit = true;
                                        });
                                      },
                                      child: Container(
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
                                            style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
                                          ),
                                        ),
                                      ),
                                    )
                              : Container(
                                  width: 56.w,
                                  height: 32.h,
                                  decoration: const BoxDecoration(
                                    color: kNeutralColor300,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "인증완료",
                                      style: kButton12BoldStyle.copyWith(color: kTextBodyColor),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isPhoneNumberEdit && ref.watch(editStateProvider).authModel == null,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100.w,
                              height: 40.h,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(kKakaoLoginColor),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 5.w, right: 5.w)),
                                ),
                                onPressed: () {},
                                label: Text(
                                  '회원가입.카카오 인증'.tr(),
                                  style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                                icon: Image.asset('assets/image/signUpScreen/kakao_icon.png'),
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                              height: 40.h,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(kNaverLoginColor),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 5.w, right: 5.w)),
                                ),
                                onPressed: () {},
                                label: Text(
                                  '회원가입.네이버 인증'.tr(),
                                  style: kBody12SemiBoldStyle.copyWith(color: kNeutralColor100),
                                ),
                                icon: Image.asset('assets/image/signUpScreen/naver_icon.png'),
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                              height: 40.h,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(kSignUpPassColor),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 5.w, right: 5.w)),
                                ),
                                onPressed: () {
                                  ref.read(authStateProvider.notifier).getPassAuthUrl();
                                },
                                label: Text(
                                  '회원가입.휴대폰 인증'.tr(),
                                  style: kBody12SemiBoldStyle.copyWith(color: kNeutralColor100),
                                ),
                                icon: Image.asset('assets/image/signUpScreen/pass_icon.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0.h),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            context.go("/home/myPage/profileEdit/withdrawalSelect");
                          },
                          child: Text(
                            "회원 탈퇴",
                            style: kButton12BoldStyle.copyWith(color: kTextBodyColor),
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
    );
  }
}
