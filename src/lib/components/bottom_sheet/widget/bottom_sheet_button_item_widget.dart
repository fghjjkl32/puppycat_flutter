import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetButtonItem extends StatelessWidget {
  const BottomSheetButtonItem({
    required this.iconImage,
    required this.title,
    required this.titleStyle,
    Key? key,
  }) : super(key: key);

  final String iconImage;
  final String title;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
          child: Row(
            children: [
              Image.asset(
                iconImage,
                height: 20.w,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0.w),
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
