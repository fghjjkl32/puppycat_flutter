import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_mobile_social_flutter/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/edit_my_information/edit_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
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
      introController.text = ref.read(myInfoStateProvider).intro ?? "";
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
    if (ref.read(nickNameProvider) == NickNameStatus.valid || nickController.text == ref.read(editStateProvider).myInfoModel!.nick) {
      // 닉네임 상태가 valid이거나 닉네임이 기존과 같을 때
      setState(() {
        isTotalNextStep = true;
      });
    } else if (ref.read(nickNameProvider) == NickNameStatus.none) {
      // 닉네임 상태가 valid가 아니고 none 상태일 때

      if (ref.read(editStateProvider).authModel != null || isNextStep) {
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
    final myInfo = ref.watch(myInfoStateProvider);
    final UserInformationItemModel editMyInfoModel = ref.watch(editStateProvider).myInfoModel!;
    final authModel = ref.watch(editStateProvider).authModel;

    checkNextStep();
    // FocusDetector와 ConditionalWillPopScope 모두 IOS 왼쪽으로 swipe할때 뒤로가기 동작하는 이유때문에 넣음
    // FocusDetector를 사용하면 완료하고 나서도 이벤트가 발생하는 문제 발생해서, showDialog를 사용하는곳에서 사용하지 못하기 떄문에 ConditionalWillPopScope 넣음
    // ConditionalWillPopScope 패키지를 사용하면 navigator error가 발생해서 showDialog 뜨는 페이지만 넣는 방향으로 결정
    return DefaultOnWillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              content: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    Text(
                      "잠깐! 지금 나가면\n수정한 내용이 저장되지 않아요.",
                      textAlign: TextAlign.center,
                      style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                    ),
                  ],
                ),
              ),
              confirmTap: () {
                context.pop();
              },
              cancelTap: () {
                context.pop();
                context.pop();
                ref.watch(editStateProvider.notifier).resetState();
              },
              confirmWidget: Text(
                "이어서 하기",
                style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
              ),
              cancelWidget: Text(
                "닫기",
                style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
              ),
            );
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
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            Text(
                              "잠깐! 지금 나가면\n수정한 내용이 저장되지 않아요.",
                              textAlign: TextAlign.center,
                              style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                            ),
                          ],
                        ),
                      ),
                      confirmTap: () {
                        context.pop();
                      },
                      cancelTap: () {
                        context.pop();
                        context.pop();
                        ref.watch(editStateProvider.notifier).resetState();
                      },
                      confirmWidget: Text(
                        "이어서 하기",
                        style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
                      ),
                      cancelWidget: Text(
                        "닫기",
                        style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                    );
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

                        UserInformationItemModel editUserModel = editMyInfoModel.copyWith(
                          profileImgUrl: selectedImage == null ? null : selectedImage!.path,
                          nick: nickController.text == "" ? editMyInfoModel.nick : nickController.text,
                          intro: introController.text,
                          phone: authModel == null ? editMyInfoModel.phone : authModel.phone,
                          ci: authModel == null ? editMyInfoModel.ci : authModel.ci,
                          di: authModel == null ? editMyInfoModel.di : authModel.di,
                        );

                        final result = await ref.watch(editStateProvider.notifier).putMyInfo(
                              myInfoModel: editUserModel,
                              file: selectedImage,
                              beforeNick: myInfo.nick ?? 'unknown',
                              isProfileImageDelete: isProfileImageDelete,
                              isPhoneNumberEdit: isPhoneNumberEdit,
                            );

                        context.pop();

                        if (result.result) {
                          // await ref.read(myInformationStateProvider.notifier).getInitUserInformation(memberUuid: myInfo.uuid?? '');
                          ref.read(myInfoStateProvider.notifier).getMyInfo();
                          // final userInformationState = ref.watch(myInformationStateProvider);
                          // final lists = userInformationState.list;
                          //
                          // // ref.read(userInfoProvider.notifier).state = ref.read(userInfoProvider.notifier).state.copyWith(
                          // //       userModel: editUserModel.copyWith(
                          // //         nick: editUserModel.nick,
                          // //         introText: editUserModel.introText,
                          // //         phone: editUserModel.phone,
                          // //         ci: editUserModel.ci,
                          // //         di: editUserModel.di,
                          // //         profileImgUrl: lists[0].profileImgUrl,
                          // //       ),
                          // //     );
                          //
                          // ref.read(myInfoStateProvider.notifier).state = editUserModel.copyWith(
                          //   profileImgUrl: lists[0].profileImgUrl,
                          // );

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
                    color: isTotalNextStep ? kPreviousPrimaryColor : kPreviousTextBodyColor,
                  ),
                ),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                  child: Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: WidgetMask(
                            blendMode: BlendMode.srcATop,
                            childSaveLayer: true,
                            mask: Center(
                                child: "${editMyInfoModel.profileImgUrl}" == ""
                                    ? selectedImage == null
                                        ? const Icon(
                                            Puppycat_social.icon_profile_large,
                                            size: 92,
                                            color: kPreviousNeutralColor500,
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
                                                color: kPreviousNeutralColor500,
                                              )
                                            : Image.network(
                                                Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${myInfo.profileImgUrl}").toUrl(),
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
                              height: 84,
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
                                      title: '앨범에서 선택하기',
                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
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
                                                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "피드를 올리거나 프로필을 설정하려면\n사진 권한이 필요해요.",
                                                            style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "언제든지 설정을 바꿀 수 있어요.",
                                                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
                                                      "설정 열기",
                                                      style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
                                                    ),
                                                    cancelWidget: Text(
                                                      "닫기",
                                                      style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
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
                                        color: kPreviousErrorColor,
                                      ),
                                      title: '프로필 사진 삭제하기',
                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousErrorColor),
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
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: kPreviousNeutralColor100,
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
                                Puppycat_social.icon_modify_medium,
                                color: kPreviousTextBodyColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000),
                        offset: Offset(0, -6),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 32, left: 12.0, bottom: 8),
                        child: Text(
                          "프로필 정보",
                          style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8),
                        child: Text(
                          "닉네임",
                          style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                                  hintText: '회원가입.닉네임을 입력해 주세요'.tr(),
                                                  hintStyle: kBody12RegularStyle.copyWith(color: kPreviousNeutralColor500),
                                                  errorStyle: kBody11RegularStyle.copyWith(color: kPreviousErrorColor, fontWeight: FontWeight.w400, height: 1.2),
                                                  errorText: getNickDescription(nickProvider),
                                                  errorBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: kPreviousErrorColor,
                                                    ),
                                                  ),
                                                  errorMaxLines: 2,
                                                  counterText: '',
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                )
                                              : InputDecoration(
                                                  hintText: '회원가입.닉네임을 입력해 주세요'.tr(),
                                                  hintStyle: kBody12RegularStyle.copyWith(color: kPreviousNeutralColor500),
                                                  errorText: '회원가입.사용 가능한 닉네임입니다'.tr(),
                                                  errorStyle: kBody11RegularStyle.copyWith(color: kPreviousPrimaryColor, fontWeight: FontWeight.w400, height: 1.2),
                                                  errorBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: kPreviousPrimaryColor,
                                                    ),
                                                  ),
                                                  focusedErrorBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: kPreviousPrimaryColor,
                                                    ),
                                                  ),
                                                  errorMaxLines: 2,
                                                  counterText: '',
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                ),
                                          style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                                          maxLength: 20,
                                          autovalidateMode: AutovalidateMode.always,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                          ],
                                          onChanged: (value) {
                                            checkNextStep();
                                            if (value.isNotEmpty) {
                                              if (value.length > 1) {
                                                setState(() {
                                                  ref.read(checkButtonProvider.notifier).state = true;
                                                  isNextStep = true;
                                                });
                                              }
                                              if (value == editMyInfoModel.nick) {
                                                setState(() {
                                                  ref.read(checkButtonProvider.notifier).state = false;
                                                });
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
                                            return null;
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
                                      height: 32,
                                      child: Container(
                                        decoration: BoxDecoration(color: kPreviousNeutralColor300, borderRadius: BorderRadius.circular(10)),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16.0),
                                            child: Text(
                                              editMyInfoModel.nick ?? 'unknown',
                                              style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 8),
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
                                        width: 56,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: ref.watch(checkButtonProvider) ? kPreviousPrimaryLightColor : kPreviousNeutralColor300,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "중복확인",
                                            style: kButton12BoldStyle.copyWith(
                                              color: ref.watch(checkButtonProvider) ? kPreviousPrimaryColor : kPreviousTextBodyColor,
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
                                      width: 56,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: kPreviousPrimaryLightColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "변경",
                                          style: kButton12BoldStyle.copyWith(color: kPreviousPrimaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8, top: 8),
                        child: Text(
                          "한 줄 소개",
                          style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: TextField(
                          controller: introController,
                          maxLength: 30,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "${editMyInfoModel.intro == "" ? '나를 간단하게 소개해 주세요.' : editMyInfoModel.intro}",
                            hintStyle: kBody12RegularStyle.copyWith(color: kPreviousNeutralColor500),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isNextStep = true;
                            });
                          },
                          style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 12.0, bottom: 8),
                        child: Text(
                          "로그인 정보",
                          style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8),
                        child: Text(
                          "이메일",
                          style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          height: 32,
                          child: FormBuilderTextField(
                            initialValue: "${editMyInfoModel.email}",
                            enabled: false,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: editMyInfoModel.simpleType == "kakao"
                                    ? Image.asset(
                                        'assets/image/loginScreen/kakao_icon.png',
                                        height: 16,
                                        width: 16,
                                      )
                                    : editMyInfoModel.simpleType == "naver"
                                        ? Image.asset(
                                            'assets/image/loginScreen/naver_icon.png',
                                            height: 16,
                                            width: 16,
                                            color: Color(0xff03CF5D),
                                          )
                                        : editMyInfoModel.simpleType == "google"
                                            ? Image.asset(
                                                'assets/image/loginScreen/google_icon.png',
                                                height: 16,
                                                width: 16,
                                              )
                                            : editMyInfoModel.simpleType == "apple"
                                                ? Image.asset(
                                                    'assets/image/loginScreen/apple_icon.png',
                                                    height: 16,
                                                    width: 16,
                                                  )
                                                : const SizedBox.shrink(),
                              ),
                              filled: true,
                              fillColor: kPreviousNeutralColor300,
                              counterText: "",
                              hintStyle: kBody12RegularStyle.copyWith(color: kPreviousNeutralColor500),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            name: 'content',
                            style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8, top: 8),
                        child: Text(
                          "이름",
                          style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          height: 32,
                          child: FormBuilderTextField(
                            enabled: false,
                            initialValue: "${editMyInfoModel.name}",
                            decoration: InputDecoration(
                                counterText: "",
                                hintStyle: kBody12RegularStyle.copyWith(color: kPreviousNeutralColor500),
                                filled: true,
                                fillColor: kPreviousNeutralColor300,
                                contentPadding: const EdgeInsets.all(16)),
                            name: 'content',
                            style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8, top: 8),
                        child: Text(
                          "휴대폰 번호",
                          style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer(builder: (ctx, ref, child) {
                              return ref.watch(editStateProvider).authModel == null
                                  ? Expanded(
                                      child: SizedBox(
                                        height: 32,
                                        child: Container(
                                          decoration: BoxDecoration(color: kPreviousNeutralColor300, borderRadius: BorderRadius.circular(10)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                "${editMyInfoModel.phone}",
                                                style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: SizedBox(
                                        height: 32,
                                        child: Container(
                                          decoration: BoxDecoration(color: kPreviousNeutralColor300, borderRadius: BorderRadius.circular(10)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                "${ref.watch(editStateProvider).authModel!.phone}",
                                                style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                            }),
                            const SizedBox(width: 8),
                            ref.watch(editStateProvider).authModel == null
                                ? isPhoneNumberEdit
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPhoneNumberEdit = false;
                                          });
                                        },
                                        child: Container(
                                          width: 56,
                                          height: 32,
                                          decoration: const BoxDecoration(
                                            color: kPreviousPrimaryLightColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "취소",
                                              style: kButton12BoldStyle.copyWith(color: kPreviousPrimaryColor),
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
                                          width: 56,
                                          height: 32,
                                          decoration: const BoxDecoration(
                                            color: kPreviousPrimaryLightColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "변경",
                                              style: kButton12BoldStyle.copyWith(color: kPreviousPrimaryColor),
                                            ),
                                          ),
                                        ),
                                      )
                                : Container(
                                    width: 56,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: kPreviousNeutralColor300,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "인증완료",
                                        style: kButton12BoldStyle.copyWith(color: kPreviousTextBodyColor),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isPhoneNumberEdit && ref.watch(editStateProvider).authModel == null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SizedBox(
                              //   width: 100.w,
                              //   height: 40.h,
                              //   child: ElevatedButton.icon(
                              //     style: ButtonStyle(
                              //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              //       ),
                              //       backgroundColor: MaterialStateProperty.all<Color>(kKakaoLoginColor),
                              //       padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 5.w, right: 5.w)),
                              //     ),
                              //     onPressed: () {},
                              //     label: Text(
                              //       '회원가입.카카오 인증'.tr(),
                              //       style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              //     ),
                              //     icon: Image.asset('assets/image/signUpScreen/kakao_icon.png'),
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 100.w,
                              //   height: 40.h,
                              //   child: ElevatedButton.icon(
                              //     style: ButtonStyle(
                              //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              //       ),
                              //       backgroundColor: MaterialStateProperty.all<Color>(kNaverLoginColor),
                              //       padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(left: 5.w, right: 5.w)),
                              //     ),
                              //     onPressed: () {},
                              //     label: Text(
                              //       '회원가입.네이버 인증'.tr(),
                              //       style: kBody12SemiBoldStyle.copyWith(color: kNeutralColor100),
                              //     ),
                              //     icon: Image.asset('assets/image/signUpScreen/naver_icon.png'),
                              //   ),
                              // ),
                              Expanded(
                                child: SizedBox(
                                  // width: 100.w,
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      ),
                                      backgroundColor: MaterialStateProperty.all<Color>(kSignUpPassColor),
                                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.only(left: 5, right: 5)),
                                    ),
                                    onPressed: () {
                                      ref.read(authStateProvider.notifier).getPassAuthUrl();
                                    },
                                    label: Text(
                                      '회원가입.휴대폰 인증'.tr(),
                                      style: kBody12SemiBoldStyle.copyWith(color: kPreviousNeutralColor100),
                                    ),
                                    icon: Image.asset('assets/image/signUpScreen/pass_icon.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              context.go("/home/myPage/profileEdit/withdrawalSelect");
                            },
                            child: Text(
                              "회원 탈퇴",
                              style: kButton12BoldStyle.copyWith(color: kPreviousTextBodyColor),
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
