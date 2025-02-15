import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/edit_my_information/edit_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_information/my_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';
import 'package:widget_mask/widget_mask.dart';

class MyPageProfileEditScreen extends ConsumerStatefulWidget {
  const MyPageProfileEditScreen({super.key});

  @override
  MyPageProfileEditScreenState createState() => MyPageProfileEditScreenState();
}

class MyPageProfileEditScreenState extends ConsumerState<MyPageProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nickController = TextEditingController();
  TextEditingController introController = TextEditingController();

  final RegExp _letterRegExp = RegExp(r'[가-힣a-zA-Z0-9_]');
  final FocusNode _nickFocusNode = FocusNode();
  bool isCheckableNickName = false;
  bool isValidNickName = false;
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

  Uint8List? uint8List;

  XFile? cropImage;

  bool isProfileEdit = false;
  bool isPhoneNumberEdit = false;
  bool isNextStep = false;
  bool isProfileImageDelete = false;
  bool isTotalNextStep = false;

  @override
  void initState() {
    print('ref.read(myInfoStateProvider) ${ref.read(myInfoStateProvider)}');
    Future(() {
      ref.read(editStateProvider.notifier).resetState();
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

  Future<XFile> uint8ListToXFile(Uint8List data, {String filename = 'temp_image'}) async {
    // 임시 디렉토리를 찾습니다.
    final Directory tempDir = await getTemporaryDirectory();
    // 파일 경로를 생성합니다. (여기서는 임시 파일 이름을 사용합니다)
    final String filePath = '${tempDir.path}/$filename.jpg';

    // Uint8List 데이터를 파일에 씁니다.
    final File file = File(filePath);
    await file.writeAsBytes(data);

    // 파일 경로로 XFile 객체를 생성합니다.
    final XFile xFile = XFile(filePath);

    return xFile;
  }

  void getXFileData(XFile file) async {
    Uint8List fileData = await file.readAsBytes();
    uint8List = await context.push("/cropImage", extra: {"uint8List": fileData});
    if (uint8List != null) {
      cropImage = await uint8ListToXFile(uint8List!);

      setState(() {
        isNextStep = true;
        isProfileImageDelete = false;
      });
    }
  }

  Future openGallery() async {
    selectedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (selectedImage != null) {
      getXFileData(selectedImage!);
    }
  }

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

  Widget _getLoginLogo(String simpleType) {
    Widget resultWidget;

    switch (simpleType) {
      case 'kakao':
        resultWidget = Image.asset('assets/image/loginScreen/kakao_icon.png');
        break;
      case 'naver':
        resultWidget = Image.asset(
          'assets/image/loginScreen/naver_icon.png',
          color: kNaverLoginColor,
        );
        break;
      case 'google':
        resultWidget = Image.asset('assets/image/loginScreen/google_icon.png');
        break;
      case 'apple':
        resultWidget = Image.asset('assets/image/loginScreen/apple_icon.png');
        break;
      default:
        resultWidget = const SizedBox.shrink();
    }

    return resultWidget;
  }

  @override
  Widget build(BuildContext context) {
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
                      "회원.정보 수정 나가기 경고".tr(),
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
                "회원.이어서 하기".tr(),
                style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
              ),
              cancelWidget: Text(
                "회원.닫기".tr(),
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
            title: Text(
              "회원.내 정보 수정".tr(),
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
                              "회원.정보 수정 나가기 경고".tr(),
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
                        "회원.이어서 하기".tr(),
                        style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
                      ),
                      cancelWidget: Text(
                        "회원.닫기".tr(),
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
                          profileImgUrl: cropImage == null ? null : cropImage!.path,
                          nick: nickController.text == "" ? editMyInfoModel.nick : nickController.text,
                          intro: introController.text,
                          phone: authModel == null ? editMyInfoModel.phone : authModel.phone,
                          ci: authModel == null ? editMyInfoModel.ci : authModel.ci,
                          di: authModel == null ? editMyInfoModel.di : authModel.di,
                        );

                        final result = await ref.read(editStateProvider.notifier).putMyInfo(
                              myInfoModel: editUserModel,
                              file: cropImage,
                              beforeNick: myInfo.nick ?? 'unknown',
                              isProfileImageDelete: isProfileImageDelete,
                              isPhoneNumberEdit: isPhoneNumberEdit,
                            );

                        context.pop();

                        if (result.result) {
                          // await ref.read(myInformationStateProvider.notifier).getInitUserInformation(memberUuid: myInfo.uuid?? '');
                          ref.read(myInfoStateProvider.notifier).getMyInfo();
                          //NOTE
                          //마이페이지 정보 업데이트하기 위한 api호출
                          ref.read(myInformationStateProvider.notifier).getInitUserInformation(memberUuid: ref.read(myInfoStateProvider).uuid ?? '');

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
                  '회원.완료'.tr(),
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
                                    ? uint8List == null
                                        ? const Icon(
                                            Puppycat_social.icon_profile_large,
                                            size: 92,
                                            color: kPreviousNeutralColor500,
                                          )
                                        : Image.memory(
                                            uint8List!,
                                            width: 135,
                                            height: 135,
                                            fit: BoxFit.cover,
                                          )
                                    : uint8List == null
                                        ? isProfileImageDelete
                                            ? const Icon(
                                                Puppycat_social.icon_profile_large,
                                                size: 92,
                                                color: kPreviousNeutralColor500,
                                              )
                                            : Image.network(
                                                thumborUrl(myInfo.profileImgUrl ?? ''),
                                                width: 135,
                                                height: 135,
                                                fit: BoxFit.cover,
                                              )
                                        : Image.memory(
                                            uint8List!,
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
                                      title: '회원.앨범에서 선택하기'.tr(),
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
                                                            "회원.사진권한".tr(),
                                                            style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "회원.언제든지 설정을 바꿀 수 있어요".tr(),
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
                                                      "회원.설정 열기".tr(),
                                                      style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
                                                    ),
                                                    cancelWidget: Text(
                                                      "회원.닫기".tr(),
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
                                      title: '회원.프로필 사진 삭제하기'.tr(),
                                      titleStyle: kButton14BoldStyle.copyWith(color: kPreviousErrorColor),
                                      onTap: () {
                                        setState(() {
                                          uint8List == null;
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
                          "회원.프로필 정보".tr(),
                          style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8),
                        child: Text(
                          "회원.닉네임".tr(),
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
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        controller: nickController,
                                        focusNode: _nickFocusNode,
                                        decoration: nickProvider != NickNameStatus.valid
                                            ? InputDecoration(
                                                hintText: '회원가입.닉네임을 입력해 주세요'.tr(),
                                                hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
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
                                                hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
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
                                  )
                                : Expanded(
                                    child: SizedBox(
                                      height: 44,
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
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: ref.watch(checkButtonProvider) ? kPreviousPrimaryLightColor : kPreviousNeutralColor300,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "회원.중복확인".tr(),
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
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        color: kPreviousPrimaryLightColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "회원.변경".tr(),
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
                          "회원.한 줄 소개".tr(),
                          style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            controller: introController,
                            maxLength: 30,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "${editMyInfoModel.intro == "" ? '회원.나를 간단하게 소개해 주세요'.tr() : editMyInfoModel.intro}",
                              hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 12.0, bottom: 8),
                        child: Text(
                          "회원.로그인 정보".tr(),
                          style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8),
                        child: Text(
                          "회원.이메일".tr(),
                          style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            // textAlign: TextAlign.center,
                            // initialValue: "${editMyInfoModel.email}",
                            controller: TextEditingController(text: editMyInfoModel.email),
                            enabled: false,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: _getLoginLogo(editMyInfoModel.simpleType ?? ''),
                                ),
                              ),
                              filled: true,
                              fillColor: kPreviousNeutralColor300,
                              counterText: "",
                              hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
                              // contentPadding: const EdgeInsets.all(16),
                              contentPadding: const EdgeInsets.only(
                                bottom: 22,
                              ),
                            ),
                            style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8, top: 8),
                        child: Text(
                          "회원.이름".tr(),
                          style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            enabled: false,
                            // initialValue: "${editMyInfoModel.name}",
                            controller: TextEditingController(text: editMyInfoModel.name),
                            decoration: InputDecoration(
                                counterText: "",
                                hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
                                filled: true,
                                fillColor: kPreviousNeutralColor300,
                                contentPadding: const EdgeInsets.all(16)),
                            // name: 'content',
                            style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, bottom: 8, top: 8),
                        child: Text(
                          "회원.휴대폰 번호".tr(),
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
                                        height: 44,
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
                                        height: 44,
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
                            // Text("${ref.watch(editStateProvider).authModel!}"),
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
                                          height: 44,
                                          decoration: const BoxDecoration(
                                            color: kPreviousPrimaryLightColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "회원.취소".tr(),
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
                                          height: 44,
                                          decoration: const BoxDecoration(
                                            color: kPreviousPrimaryLightColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "회원.변경".tr(),
                                              style: kButton12BoldStyle.copyWith(color: kPreviousPrimaryColor),
                                            ),
                                          ),
                                        ),
                                      )
                                : Container(
                                    width: 56,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      color: kPreviousNeutralColor300,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "회원.인증완료".tr(),
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
                                      ref.read(authStateProvider.notifier).getPassAuthUrl(isEditProfile: true);
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
                              context.push("/member/myPage/profileEdit/withdrawalSelect");
                            },
                            child: Text(
                              "회원.회원 탈퇴".tr(),
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
