import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/policy_checkbox_widget.dart';
import 'package:easy_localization/easy_localization.dart';

final _formKey = GlobalKey<FormState>();

final checkButtonProvider = StateProvider((ref) => false);

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  TextEditingController nickController = TextEditingController();
  final RegExp _letterRegExp = RegExp(r'[가-힣a-zA-Z0-9._]');
  final FocusNode _nickFocusNode = FocusNode();
  bool isCheckableNickName = false;
  bool isValidNickName = false;

  @override
  void initState() {
    super.initState();

    ref.read(policyStateProvider.notifier).getPolicies();
  }

  @override
  void dispose() {
    nickController.dispose();
    super.dispose();
  }

  Widget _buildTop() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '회원가입.퍼피캣에 오신 걸 환영합니다'.tr(),
                style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor, height: 1.2),
              ),
              SizedBox(height: 8.h),
              Text(
                '회원가입.환영문구부제'.tr(),
                style: kBody12RegularStyle400.copyWith(color: kTextBodyColor, height: 1.3),
              ),
            ],
          ),
          Image.asset('assets/image/signUpScreen/right_top.png'),
        ],
      ),
    );
  }

  Widget _buildAUthBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '회원가입.본인 인증'.tr(),
              style: kBody13BoldStyle.copyWith(color: kTextTitleColor, height: 1.4),
            ),
            Text(
              '회원가입.필수'.tr(),
              style: kBadge10MediumStyle.copyWith(color: kPrimaryColor),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
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
                onPressed: () {},
                label: Text(
                  '회원가입.휴대폰 인증'.tr(),
                  style: kBody12SemiBoldStyle.copyWith(color: kNeutralColor100),
                ),
                icon: Image.asset('assets/image/signUpScreen/pass_icon.png'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNickBody() {
    final nickProvider = ref.watch(nickNameProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '회원가입.닉네임'.tr(),
              style: kBody13BoldStyle.copyWith(color: kTextTitleColor, height: 1.4),
            ),
            Text(
              '회원가입.필수'.tr(),
              style: kBadge10MediumStyle.copyWith(color: kPrimaryColor),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: nickController,
                  focusNode: _nickFocusNode,
                  // inputFormatters: [FilteringTextInputFormatter.allow(_emojiRegExp)],
                  decoration: nickProvider != NickNameStatus.valid
                      ? InputDecoration(
                          hintText: '회원가입.닉네임을 입력해주세요'.tr(),
                          errorStyle: kBody11RegularStyle.copyWith(color: kBadgeColor, fontWeight: FontWeight.w400, height: 1.2),
                          errorText: _getNickDescription(nickProvider),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kBadgeColor,
                            ),
                          ),
                          errorMaxLines: 2,
                          counterText: '',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 13.0.h, horizontal: 16.0.w), //Vertical 이 13인 이유는 정확하진 않은데 border까지 고려해야할듯
                        )
                      : InputDecoration(
                          hintText: '회원가입.닉네임을 입력해주세요'.tr(),
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
                          contentPadding: EdgeInsets.symmetric(vertical: 13.0.h, horizontal: 16.0.w),
                        ),
                  maxLength: 20,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      ref.read(checkButtonProvider.notifier).state = true;
                      String lastChar = value[value.length - 1];
                      if (lastChar.contains(RegExp(r'[a-zA-Z]'))) {
                        nickController.value = TextEditingValue(text: toLowercase(value), selection: nickController.selection);
                        return;
                      }
                    } else {
                      ref.read(checkButtonProvider.notifier).state = false;
                    }
                    ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
                  },
                  validator: (value) {
                    if (value != null) {
                      if (value.isNotEmpty) {
                        if (_letterRegExp.allMatches(value).length != value.length) {
                          return _getNickDescription(NickNameStatus.invalidLetter);
                        } else if (value.isNotEmpty && value.length < 2) {
                          return _getNickDescription(NickNameStatus.minLength);
                        } else {
                          isCheckableNickName = true;
                          return null;
                        }
                      }
                    }
                  },
                  onSaved: (val) {
                    if(isCheckableNickName) {
                      ref.read(signUpStateProvider.notifier).checkNickName(val!);
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Spacer(),
            SizedBox(
              width: 66.w,
              height: 44.h,
              child: ElevatedButton(
                onPressed: ref.watch(checkButtonProvider)
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          _nickFocusNode.unfocus();
                          _formKey.currentState!.save();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  backgroundColor: kPrimaryLightColor,
                  disabledBackgroundColor: kNeutralColor300,
                  disabledForegroundColor: kTextBodyColor,
                  foregroundColor: kPrimaryColor,
                  elevation: 0,
                ),
                child: Text(
                  '회원가입.중복확인'.tr(),
                  style: kBody12SemiBoldStyle, //.copyWith(color: kPrimaryColor),
                ),
              ),
            ),
          ],
        ),
        // Visibility(
        //   visible: nickProvider != NickNameStatus.none,
        //   child: _getNickDescription(nickProvider),
        // ),
      ],
    );
  }

  String toLowercase(String input) {
    return input.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return match.group(0)!.toLowerCase();
    });
  }

  String? _getNickDescription(NickNameStatus nickNameStatus) {
    switch (nickNameStatus) {
      case NickNameStatus.duplication:
        return '회원가입.이미 존재하는 닉네임입니다'.tr();
      case NickNameStatus.maxLength:
        return '회원가입.닉네임은 20자를 초과할 수 없습니다'.tr();
      case NickNameStatus.minLength:
        return '회원가입.닉네임은 최소 2자 이상 설정 가능합니다'.tr();
      case NickNameStatus.invalidLetter:
        return '회원가입.닉네임 입력 예외 메시지'.tr();
      case NickNameStatus.valid:
        return '회원가입.사용 가능한 닉네임입니다'.tr();
      case NickNameStatus.invalidWord:
        return '회원가입.사용할 수 없는 닉네임입니다'.tr();
      default:
        return null;
    }
  }

  Widget _buildPolicyBody() {
    final policyProvider = ref.watch(policyStateProvider);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: ref.watch(policyAllAgreeStateProvider),
              onChanged: (value) {
                _nickFocusNode.unfocus();
                ref.read(policyStateProvider.notifier).toggleAll(value!);
              },
            ),
            Text(
              '회원가입.전체 동의하기'.tr(),
              style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: policyProvider.length,
          itemBuilder: (context, idx) {
            return PolicyCheckBoxWidget(
              idx: policyProvider[idx].idx,
              isAgreed: policyProvider[idx].isAgreed,
              isEssential: policyProvider[idx].required == 'Y' ? true : false,
              title: policyProvider[idx].title ?? 'unknown title.',
              detail: policyProvider[idx].detail ?? 'unknown detail.',
              onChanged: (value) {
                _nickFocusNode.unfocus();
                ref.read(policyStateProvider.notifier).toggle(policyProvider[idx].idx);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    // final essentialAgreeProvider = ref.watch(policyAgreeStateProvider);

    return SizedBox(
      width: double.infinity,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: -5,
                blurRadius: 7,
                offset: const Offset(0, -6), // 그림자의 위치 조정 (x, y)
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 0),
            child: Column(
              children: [
                _buildAUthBody(),
                SizedBox(height: 8.h),
                _buildNickBody(),
                SizedBox(height: 24.h),
                const Divider(),
                // SizedBox(height: 24.h),
                _buildPolicyBody(),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final essentialAgreeProvider = ref.watch(policyAgreeStateProvider);
    ref.listen(nickNameProvider, (previous, next) {
      if (next == NickNameStatus.valid) {
        isValidNickName = true;
      }
    });

    return GestureDetector(
      onTap: () {
        _nickFocusNode.unfocus();
        // FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // bottomSheet: const Text('aaa'),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTop(),
              _buildBody(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 320.w,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: essentialAgreeProvider && isValidNickName
                            ? () {
                                var userModel = ref.read(userModelProvider.notifier).state;
                                if (userModel == null) {
                                  throw 'usermodel is null';
                                }
                                userModel = userModel.copyWith(
                                  nick: nickController.text,
                                );
                                // ref.read(userModelProvider.notifier).state = userModel;
                                ref.read(signUpStateProvider.notifier).socialSignUp(userModel);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          disabledBackgroundColor: kNeutralColor400,
                          disabledForegroundColor: kTextBodyColor,
                          elevation: 0,
                        ),
                        child: Text(
                          '확인'.tr(),
                          style: kButton14BoldStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
