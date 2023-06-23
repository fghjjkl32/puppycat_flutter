import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/policy_checkbox_widget.dart';
import 'package:easy_localization/easy_localization.dart';

final _formKey = GlobalKey<FormState>();

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({Key? key}) : super(key: key);

  TextEditingController nickController = TextEditingController();
  final RegExp _letterRegExp = RegExp(r'[가-힣a-zA-Z0-9._]');
  final FocusNode _nickFocusNode = FocusNode();

  // @override
  // void unmount() {
  //   _nickFocusNode.dispose();
  //   super.unmount();
  // }


  Widget _buildTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('회원가입.퍼피캣에 오신 걸 환영합니다'.tr()),
            Text('회원가입.환영문구부제'.tr()),
          ],
        ),
        Image.asset('assets/image/signUpScreen/right_top.png'),
      ],
    );
  }

  Widget _buildAUthBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('회원가입.본인 인증'.tr()),
            Text('회원가입.필수'.tr()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('kakao auth'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('naver auth'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('pass auth'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNickBody(WidgetRef ref) {
    final nickProvider = ref.watch(nickNameProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('회원가입.닉네임'.tr()),
            Text('회원가입.필수'.tr()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          // errorStyle:
                          errorText: _getNickDescription(nickProvider),
                          errorMaxLines: 2,
                          counterText: '',
                        )
                      : InputDecoration(
                          hintText: '회원가입.닉네임을 입력해주세요'.tr(),
                          errorText: '회원가입.사용 가능한 닉네임입니다'.tr(),
                          errorStyle: const TextStyle(
                            color: kSignUpNickValidColor,
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: kNeutralColor400,
                            ),
                          ),
                          errorMaxLines: 2,
                          counterText: '',
                        ),
                  maxLength: 20,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (value) {
                    print('aa');
                    if (value.isNotEmpty) {
                      String lastChar = value[value.length - 1];
                      if (lastChar.contains(RegExp(r'[a-zA-Z]'))) {
                        nickController.value = TextEditingValue(text: toLowercase(value), selection: nickController.selection);
                        return;
                      }
                    }
                    ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
                  },
                  validator: (value) {
                    if (value != null) {
                      if (_letterRegExp.allMatches(value).length != value.length) {
                        // || _emojiRegExp.allMatches(value).length != value.length) {
                        // ref.read(nickNameProvider)
                        // return _getNickDescription(NickNameStatus.invalidLetter); //'닉네임은 숫자/한글/영어/언더바(_)/온점(.)만 입력 가능합니다.';
                        return '회원가입.닉네임은 숫자/한글/영어/언더바(_)/온점(.)만 입력 가능합니다'.tr();
                      } else if (value.isNotEmpty && value.length < 2) {
                        // return _getNickDescription(NickNameStatus.minLength); //'닉네임은 최소 2자 이상 설정 가능합니다.';
                        return '회원가입.닉네임은 최소 2자 이상 설정 가능합니다'.tr();
                      }
                      // else if (_koreanRegExp.allMatches(value).length != value.length) {
                      //   return '닉네임은 숫자/한글/영어/언더바(_)/온점(.)만 입력 가능합니다.';
                      // }
                      else {
                        return null;
                      }
                    }
                  },
                  onSaved: (val) {
                    ref.read(signUpStateProvider.notifier).checkNickName(val!);
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
              child: Text('회원가입.중복확인'.tr()),
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
        return '회원가입.닉네임은 숫자/한글/영어/언더바(_)/온점(.)만 입력 가능합니다'.tr();
      case NickNameStatus.valid:
        return '회원가입.사용 가능한 닉네임입니다'.tr();
      case NickNameStatus.invalidWord:
        return '회원가입.사용할 수 없는 닉네임입니다'.tr();
      default:
        return null;
    }
  }

  Widget _buildPolicyBody(WidgetRef ref) {
    final policyProvider = ref.watch(policyStateProvider);
    print('policyProvider $policyProvider');
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: ref.watch(policyAllAgreeStateProvider),
              onChanged: (value) {
                ref.read(policyStateProvider.notifier).toggleAll(value!);
              },
            ),
            Text('회원가입.전체 동의하기'.tr()),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: policyProvider.length,
          itemBuilder: (context, idx) {
            return PolicyCheckBoxWidget(
              idx: policyProvider[idx].idx,
              isAgreed: policyProvider[idx].isAgreed,
              isEssential: policyProvider[idx].required == 'Y' ? true : false,
              title: policyProvider[idx].title ?? 'unknown title.',
              detail: policyProvider[idx].detail ?? 'unknown detail.',
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(WidgetRef ref) {
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
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              children: [
                _buildAUthBody(),
                _buildNickBody(ref),
                const Divider(),
                _buildPolicyBody(ref),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final essentialAgreeProvider = ref.watch(policyAgreeStateProvider);
    print('why???????????????');
    return Scaffold(
      body: Column(
        children: [
          TextFormField(),
        ],
      ),
    );
    
    return GestureDetector(
      onTap: () {
        // _nickFocusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // bottomSheet: const Text('aaa'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTop(),
                  // _buildBody(ref),
                  TextFormField(),
                  /// TODO
                  /// 나중에 하단에 붙여야함 버튼
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: ElevatedButton(
                  //     onPressed: essentialAgreeProvider ? () {} : null,
                  //     child: Text('확인'.tr()),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
