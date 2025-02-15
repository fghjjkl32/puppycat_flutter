import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/sign_up/sign_up_auth_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/policy_checkbox_widget.dart';

final checkButtonProvider = StateProvider((ref) => false);

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nickController = TextEditingController();
  final RegExp _letterRegExp = RegExp(r'[가-힣a-zA-Z0-9_]');
  final FocusNode _nickFocusNode = FocusNode();
  bool isCheckableNickName = false;
  bool isValidNickName = false;

  late Future _getPolicyListFuture;

  @override
  void initState() {
    super.initState();

    // ref.read(policyStateProvider.notifier).getPolicies();
    _getPolicyListFuture = _getPolicyList();

    Future(() {
      ref.read(authStateProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    nickController.dispose();
    super.dispose();
  }

  Future _getPolicyList() async {
    await ref.read(policyStateProvider.notifier).getPolicies();
  }

  Widget _buildTop() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '회원가입.환영문구'.tr(),
                style: kTitle18BoldStyle.copyWith(color: kPreviousTextTitleColor),
              ),
            ],
          ),
          Image.asset(
            'assets/image/character/character_00_agree.png',
            width: 88,
            height: 88,
          ),
        ],
      ),
    );
  }

  Widget _buildAuthBody() {
    bool isAuth = ref.watch(authStateProvider);
    return Column(
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '회원가입.본인 인증'.tr(),
              style: kTitle14BoldStyle.copyWith(color: kPreviousTextTitleColor, height: 1.4, letterSpacing: 0.2),
            ),
            Text(
              ' *',
              style: kTitle14BoldStyle.copyWith(color: kPreviousErrorColor, height: 1.4, letterSpacing: 0.2),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Visibility(
              visible: !isAuth,
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
                  //     onPressed: () async {
                  //       final url = await ref.read(authStateProvider.notifier).getTossAuthUrl("2ecf4e89-e1bc-48e0-93c6-d2de8fe4a2d0");
                  //       //
                  //       final appScheme = ConvertUrl(url); // Intent URL을 앱 스킴 URL로 변환
                  //       //
                  //       print(appScheme);
                  //
                  //       print(appScheme.appScheme);
                  //       print(appScheme.url);
                  //
                  //       if (appScheme.isAppLink()) {
                  //         print(appScheme.appLink);
                  //
                  //         await appScheme.launchApp();
                  //       }
                  //     },
                  //     label: Text(
                  //       '회원가입.네이버 인증'.tr(),
                  //       style: kBody12SemiBoldStyle.copyWith(color: kNeutralColor100),
                  //     ),
                  //     icon: Image.asset('assets/image/signUpScreen/naver_icon.png'),
                  //   ),
                  // ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor: MaterialStateProperty.all<Color>(kSignUpPassColor),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.only(left: 5, right: 5)),
                        ),
                        onPressed: () {
                          ref.read(authStateProvider.notifier).getPassAuthUrl(isEditProfile: false);
                        },
                        label: Text(
                          '회원가입.휴대폰 인증'.tr(),
                          style: kButton14MediumStyle.copyWith(color: kPreviousNeutralColor100, fontWeight: FontWeight.w500, height: 1.4, letterSpacing: 0.2),
                        ),
                        icon: Image.asset('assets/image/signUpScreen/pass_icon.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isAuth,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      // width: 320,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPreviousPrimaryColor,
                          disabledBackgroundColor: kPreviousNeutralColor400,
                          disabledForegroundColor: kPreviousTextBodyColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '회원가입.인증 완료'.tr(),
                          style: kButton14MediumStyle.copyWith(color: kNeutralColor500, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
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
          children: [
            Text(
              '회원가입.닉네임'.tr(),
              style: kTitle14BoldStyle.copyWith(color: kPreviousTextTitleColor, height: 1.4, letterSpacing: 0.2),
            ),
            Text(
              ' *',
              style: kTitle14BoldStyle.copyWith(color: kPreviousErrorColor, height: 1.4, letterSpacing: 0.2),
            ),
          ],
        ),
        SizedBox(height: 8),
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
                          hintText: '회원가입.2~20자로 입력해 주세요'.tr(),
                          hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
                          errorStyle: kBody13RegularStyle.copyWith(color: kPreviousErrorColor, fontWeight: FontWeight.w400, height: 1.2),
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                          prefix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          //Vertical 이 13인 이유는 정확하진 않은데 border까지 고려해야할듯
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )
                      : InputDecoration(
                          hintText: '회원가입.닉네임을 입력해 주세요'.tr(),
                          errorText: '회원가입.사용 가능한 닉네임입니다'.tr(),
                          errorStyle: kBody13RegularStyle.copyWith(color: kPreviousPrimaryColor, fontWeight: FontWeight.w400, height: 1.2),
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                          prefix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                  maxLength: 20,
                  autovalidateMode: AutovalidateMode.always,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  onChanged: (value) {
                    if (_formKey.currentState!.validate()) {
                      ref.read(checkButtonProvider.notifier).state = true;
                    } else {
                      ref.read(checkButtonProvider.notifier).state = false;
                    }

                    if (isValidNickName) {
                      isValidNickName = false;
                    }

                    ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
                  },
                  validator: (value) {
                    if (value != null) {
                      if (value.isNotEmpty) {
                        if (_letterRegExp.allMatches(value).length != value.length) {
                          return getNickDescription(NickNameStatus.invalidLetter);
                        } else if (value.isNotEmpty && value.length < 2) {
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
            SizedBox(width: 8),
            // Spacer(),
            SizedBox(
              width: 66,
              height: 44,
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
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  backgroundColor: kPreviousPrimaryLightColor,
                  disabledBackgroundColor: kPreviousNeutralColor300,
                  disabledForegroundColor: kPreviousTextBodyColor,
                  foregroundColor: kPreviousPrimaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '회원가입.중복확인'.tr(),
                  style: kBody13MediumStyle.copyWith(height: 1.4, letterSpacing: -0.5), //.copyWith(color: kPrimaryColor),
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

  Widget _buildPolicyBody() {
    return Expanded(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                activeColor: kPreviousPrimaryLightColor,
                visualDensity: VisualDensity.standard,
                checkColor: kPreviousPrimaryColor,
                value: ref.watch(policyAllAgreeStateProvider),
                onChanged: (value) {
                  _nickFocusNode.unfocus();
                  ref.read(policyStateProvider.notifier).toggleAll(value!);
                },
              ),
              Text(
                '회원가입.전체 동의하기'.tr(),
                style: kBody14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
              ),
            ],
          ),
          Expanded(
              child: FutureBuilder(
            future: _getPolicyListFuture, //ref.read(policyStateProvider.notifier).getPolicies(),
            builder: (context, snapshot) {
              final policyProvider = ref.watch(policyStateProvider);
              print('policyProvider $policyProvider');
              return ListView.builder(
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
                    menuIdx: policyProvider[idx].menuIdx ?? 0,
                    menuName: policyProvider[idx].menuName ?? 'unknown detail.',
                    onChanged: (value) {
                      _nickFocusNode.unfocus();
                      ref.read(policyStateProvider.notifier).toggle(policyProvider[idx].idx);
                    },
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // final essentialAgreeProvider = ref.watch(policyAgreeStateProvider);

    return SizedBox(
      width: double.infinity,
      child: Container(
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              children: [
                _buildAuthBody(),
                SizedBox(height: 8),
                _buildNickBody(),
                SizedBox(height: 24),
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
    final SignUpAuthModel? signUpAuthModel = ref.watch(authModelProvider);

    ref.listen(nickNameProvider, (previous, next) {
      if (next == NickNameStatus.valid) {
        isValidNickName = true;
      }
    });
    ref.listen(signUpStateProvider, (previous, next) {
      if (next == SignUpStatus.failedAuth) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialog(
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    "회원가입.본인 인증에 실패하였습니다".tr(),
                    style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                  ),
                ),
                confirmTap: () {
                  // context.go('/loginScreen');
                  ref.read(loginStateProvider.notifier).state = LoginStatus.none;
                  // ref.read(loginRouteStateProvider.notifier).state = LoginRouteEnum.none;
                  ref.read(signUpStateProvider.notifier).state = SignUpStatus.none;
                  context.pop();
                },
                confirmWidget: Text(
                  '회원가입.확인'.tr(),
                  style: kButton14MediumStyle.copyWith(color: kPreviousErrorColor),
                ));
          },
        );
      } else if (next == SignUpStatus.duplication) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialog(
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    "회원가입.이미 퍼피캣에 가입된 계정이 있습니다".tr(),
                    style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                  ),
                ),
                confirmTap: () {
                  ref.read(loginStateProvider.notifier).state = LoginStatus.none;
                  // ref.read(loginRouteStateProvider.notifier).state = LoginRouteEnum.none;
                  ref.read(signUpStateProvider.notifier).state = SignUpStatus.none;
                  context.pop();
                },
                confirmWidget: Text(
                  "회원가입.확인".tr(),
                  style: kButton14MediumStyle.copyWith(color: kPreviousErrorColor),
                ));
          },
        );
      }
    });

    return DefaultOnWillPopScope(
      onWillPop: () async {
        ///NOTE
        ///여기 고치면 아래 주석 검색해서 거기도 고쳐야하는지 봐야함
        ///로그인 페이지 이동 초기화
        // ref.read(loginRouteStateProvider.notifier).state = LoginRouteEnum.none;
        // ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.none;
        ref.read(signUpUserInfoProvider.notifier).state = null;
        ref.read(authStateProvider.notifier).state = false;
        ref.read(checkButtonProvider.notifier).state = false;
        ref.read(policyStateProvider.notifier).policyStateReset();
        ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
        return true;
      },
      child: GestureDetector(
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
                Expanded(child: _buildBody()),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          // width: 320,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: essentialAgreeProvider && isValidNickName && ref.watch(authStateProvider)
                                ? () {
                                    UserModel? userModel = ref.read(signUpUserInfoProvider);
                                    if (userModel == null) {
                                      throw 'userModel is null';
                                    }
                                    userModel = userModel.copyWith(
                                      nick: nickController.text,
                                      ci: signUpAuthModel?.ci ?? '',
                                      di: signUpAuthModel?.di ?? '',
                                      name: signUpAuthModel?.name ?? '',
                                      phone: signUpAuthModel?.phone ?? '',
                                      gender: signUpAuthModel?.gender ?? '',
                                      birth: signUpAuthModel?.birth ?? '',
                                    );
                                    ref.read(signUpStateProvider.notifier).socialSignUp(userModel); // ㅇㅇㅇ
                                    // chatClientController.changeDisplayName(userModel.id, userModel.nick);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPreviousPrimaryColor,
                              disabledBackgroundColor: kPreviousNeutralColor400,
                              disabledForegroundColor: kPreviousTextBodyColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              '회원가입.확인'.tr(),
                              style: kBody16MediumStyle.copyWith(height: 1.4, letterSpacing: -0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
