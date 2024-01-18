import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

class ErrorToast extends StatefulWidget {
  @override
  State<ErrorToast> createState() => _ErrorToastState();
}

class _ErrorToastState extends State<ErrorToast> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toast(context: context, text: '피드를 찾을 수 없어요.', type: ToastType.purple);
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      ignoring: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
