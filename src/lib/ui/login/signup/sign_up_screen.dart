import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/policy_checkbox_widget.dart';

//
// class SignUpScreen extends ConsumerStatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends ConsumerState<SignUpScreen> {
//   TextEditingController nickController = TextEditingController();
//   late final List<PolicyItemModel> policies;
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   Widget _buildTop() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Column(
//           children: [
//             Text('퍼피캣에 오신 걸 환영합니다!'),
//             Text('원활한 퍼피캣 서비스를 이용하시려면\n닉네임 생성 및 동의가 필요해요!'),
//           ],
//         ),
//         Image.asset('assets/image/signUpScreen/right_top.png'),
//       ],
//     );
//   }
//
//   Widget _buildAUthBody() {
//     return Column(
//       children: [
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('본인 인증'),
//             Text('필수'),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('kakao auth'),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('naver auth'),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('pass auth'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNickBody() {
//     return Column(
//       children: [
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('닉네임'),
//             Text('필수'),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: nickController,
//                 decoration: const InputDecoration(hintText: '닉네임을 입력해주세요.'),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text('중복확인'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPolicyBody() {
//     // final policiesProvider = ref.watch(policyListProvider);
//
//     // return Column(
//     //   children: [
//     //     policiesProvider.when(
//     //       data: (policies) {
//     //         if (policies.isEmpty) {
//     //           return const Text('Policy Empty');
//     //         }
//     //         PolicyItemModel model = policies.first;
//     //         return Column(
//     //           children: [
//     //             PolicyCheckBoxWidget(
//     //               idx: model.idx,
//     //               onChanged: (value) {
//     //                   // policyCheckedMap[model.idx] = value;
//     //               },
//     //               isEssential: model.required == 'Y' ? true : false,
//     //               title: model.title ?? 'unknown title.',
//     //               detail: model.detail ?? 'unknown detail.',
//     //             ),
//     //             PolicyCheckBoxWidget(
//     //               idx: model.idx,
//     //               onChanged: (value) {
//     //                 // policyCheckedMap[model.idx] = value;
//     //               },
//     //               isEssential: model.required == 'Y' ? true : false,
//     //               title: model.title ?? 'unknown title.',
//     //               detail: model.detail ?? 'unknown detail.',
//     //             ),
//     //           ],
//     //         );
//     //         // return CheckboxListTile(value: value, onChanged: onChanged)
//     //       },
//     //       error: (error, stack) => Text('policy error $error'),
//     //       loading: () => const CircularProgressIndicator(),
//     //     )
//     //   ],
//     // );
//   }
//
//   Widget _buildBody() {
//     return SizedBox(
//       width: double.infinity,
//       child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20.0),
//               topRight: Radius.circular(20.0),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: -5,
//                 blurRadius: 7,
//                 offset: const Offset(0, -6), // 그림자의 위치 조정 (x, y)
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
//             child: Column(
//               children: [
//                 _buildAUthBody(),
//                 _buildNickBody(ref),
//                 const Divider(),
//                 _buildPolicyBody(ref),
//               ],
//             ),
//           )),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // bottomSheet: const Text('aaa'),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildTop(),
//             _buildBody(),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //
//
class SignUpScreen extends ConsumerWidget {
  SignUpScreen({Key? key}) : super(key: key);

  TextEditingController nickController = TextEditingController();

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
              child: TextField(
                controller: nickController,
                decoration: const InputDecoration(hintText: '닉네임을 입력해주세요.'),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('중복확인'),
            ),
          ],
        ),
      ],
    );
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
