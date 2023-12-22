import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetButtonItem extends StatelessWidget {
  const BottomSheetButtonItem({
    required this.icon,
    required this.title,
    required this.titleStyle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final TextStyle titleStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          child: Row(
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  title,
                  style: titleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
