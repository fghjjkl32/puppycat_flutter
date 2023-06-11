import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

ThemeData themeData(context) => ThemeData(
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        side: MaterialStateBorderSide.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const BorderSide(width: 1.0, color: kPrimaryLightColor);
          } else {
            return const BorderSide(width: 1.0, color: kNeutralColor400);
          }
        }),
      ),
      scaffoldBackgroundColor: kNeutralColor100,
      primaryColor: kPrimaryColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        titleTextStyle: kTitle18BoldStyle.copyWith(color: kNeutralColor600),
        iconTheme: const IconThemeData(
          color: kTextSubTitleColor,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: kNeutralColor200,
        thickness: 2,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          gapPadding: 10,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: kNeutralColor400),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 10,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          gapPadding: 10,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: kBadgeColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          gapPadding: 10,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: kBadgeColor),
        ),
      ),
    );
