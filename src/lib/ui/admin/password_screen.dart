import 'package:flutter/material.dart';
import 'dart:math';

import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/ui/admin/admin_screen.dart';

//ignore: must_be_immutable
class PasswordScreen extends StatefulWidget {
  const PasswordScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  String? passwordKeyward;
  String passwordText = '현재 비밀번호를 입력하세요.';

  List<int> passwordKeySet = [];

  @override
  void initState() {
    super.initState();

    passwordKeySet.clear();
    // 번호생성
    while (true) {
      var rnd = Random().nextInt(10);
      if (!passwordKeySet.contains(rnd)) {
        passwordKeySet.add(rnd);
      }
      if (passwordKeySet.length == 10) break;
    }

    passwordKeyward = '';
  }

  checkPassword() async {
    passwordKeyward == "123789" ? successPassword() : checkAgainPassword();
  }

  successPassword() async {
    // Navigator.pushNamed(context, '/admin');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const SafeArea(
                child: AdminScreen(),
              )),
    );
  }

  checkAgainPassword() {
    passwordText = '비밀번호를 다시 확인해주세요.';
    passwordKeyward = '';
  }

  // postPasswordCheck
  onNumberPress(val) {
    setState(() {
      passwordKeyward = passwordKeyward! + val;

      if (passwordKeyward!.length == 6) {
        debugPrint(passwordKeyward);
        checkPassword();
      }
    });
  }

  onBackspacePress(val) {
    setState(() {
      if (passwordKeyward!.isNotEmpty) {
        passwordKeyward =
            passwordKeyward!.substring(0, passwordKeyward!.length - 1);
      }
    });
  }

  renderKeyboard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[0].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[0].toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[1].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[1].toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[2].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[2].toString(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[3].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[3].toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[4].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[4].toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[5].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[5].toString(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[6].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[6].toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[7].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[7].toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[8].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[8].toString(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: Center(
                      child: Text(
                        "",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: passwordKeySet[9].toString(),
                    onTap: onNumberPress,
                    value: passwordKeySet[9].toString(),
                  ),
                ),
                Expanded(
                  child: KeyboardKey(
                    label: const Icon(Icons.keyboard_backspace),
                    onTap: onBackspacePress,
                    value: const Icon(Icons.keyboard_backspace),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  renderText() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      passwordKeyward!.isEmpty ? "" : "*",
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.005,
                      width: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      passwordKeyward!.length > 1 ? "*" : "",
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.005,
                      width: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      passwordKeyward!.length > 2 ? "*" : "",
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.005,
                      width: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      passwordKeyward!.length > 3 ? "*" : "",
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.005,
                      width: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      passwordKeyward!.length > 4 ? "*" : "",
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.005,
                      width: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      passwordKeyward!.length > 5 ? "*" : "",
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.005,
                      width: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            passwordText,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text(
          "비밀번호 확인",
        ),
        elevation: 0,
        backgroundColor: kPrimaryLightColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          renderText(),
          renderKeyboard(),
        ],
      ),
    );
  }
}

class KeyboardKey extends StatefulWidget {
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  const KeyboardKey({
    super.key,
    required this.label,
    required this.onTap,
    required this.value,
  });

  @override
  // ignore: library_private_types_in_public_api
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  renderLabel() {
    if (widget.label is String) {
      return Text(
        widget.label,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return widget.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: kNeutralColor400,
      splashColor: kNeutralColor400,
      onTap: () {
        widget.onTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: Center(
          child: renderLabel(),
        ),
      ),
    );
  }
}
