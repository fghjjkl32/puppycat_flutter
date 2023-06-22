import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/policy_checkbox_widget.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({Key? key}) : super(key: key);

  TextEditingController nickController = TextEditingController();
  final RegExp _emojiRegExp = RegExp(r'[\uac00-\ud7af]', unicode: true);
  final RegExp _letterRegExp = RegExp(r'[ㄱ-ㅎ가-힣a-zA-Z0-9._]');
  final _formKey = GlobalKey<FormState>();

  Widget _buildTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Column(
          children: [
            Text('퍼피캣에 오신 걸 환영합니다!'),
            Text('원활한 퍼피캣 서비스를 이용하시려면\n닉네임 생성 및 동의가 필요해요!'),
          ],
        ),
        Image.asset('assets/image/signUpScreen/right_top.png'),
      ],
    );
  }

  Widget _buildAUthBody() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('본인 인증'),
            Text('필수'),
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('닉네임'),
            Text('필수'),
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
                  // inputFormatters: [FilteringTextInputFormatter.allow(_emojiRegExp)],
                  decoration: const InputDecoration(
                    hintText: '닉네임을 입력해주세요.',
                    // errorStyle:
                    errorMaxLines: 2,
                    counterText: '',
                  ),
                  maxLength: 20,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: (value) {
                    print(value);
                    nickController.value = TextEditingValue(
                        text: value.toLowerCase(),
                        selection: nickController.selection
                    );
                  },
                  validator: (value) {
                    if (value != null) {
                      // if (_emojiRegExp.allMatches(value).length != value.length) {
                      if (_letterRegExp.allMatches(value).length != value.length) { // || _emojiRegExp.allMatches(value).length != value.length) {
                        // ref.read(nickNameProvider)
                        return '닉네임은 숫자/한글/영어/언더바(_)/온점(.)만 입력 가능합니다.';
                      } else if (value.length > 0 && value.length < 2) {
                        return '닉네임은 최소 2자 이상 설정 가능합니다.';
                      } else {
                        return null;
                      }
                    }
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
              child: const Text('중복확인'),
            ),
          ],
        ),
        Visibility(
          visible: nickProvider != NickNameStatus.none,
          child: _getNickDescription(nickProvider),
        ),
      ],
    );
  }

  Widget _getNickDescription(NickNameStatus nickNameStatus) {
    switch (nickNameStatus) {
      case NickNameStatus.duplication:
        return const Text('이미 존재하는 닉네임입니다.');
      case NickNameStatus.maxLength:
        return const Text('닉네임은 20자를 초과할 수 없습니다.');
      case NickNameStatus.minLength:
        return const Text('닉네임은 최소 2자 이상 설정 가능합니다.');
      case NickNameStatus.invalidLetter:
        return const Text('닉네임은 숫자/한글/영어/언더바(_)/온점(.)만 입력 가능합니다.');
      case NickNameStatus.valid:
        return const Text('사용 가능한 닉네임입니다.');
      default:
        return const Text('');
    }
  }

  Widget _buildPolicyBody(WidgetRef ref) {
    final policyProvider = ref.watch(policyStateProvider);

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
            const Text('전체 동의하기'),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
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
    final essentialAgreeProvider = ref.watch(policyAgreeStateProvider);

    return Scaffold(
      // bottomSheet: const Text('aaa'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTop(),
              _buildBody(ref),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: essentialAgreeProvider ? () {} : null,
                    child: const Text('확인'),
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
