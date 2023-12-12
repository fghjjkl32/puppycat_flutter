import 'package:flutter/material.dart';

//NeutralColor
const kPreviousNeutralColor100 = Color(0xffffffff);
const kPreviousNeutralColor200 = Color(0xfff6f7fa);
const kPreviousNeutralColor300 = Color(0xffedeff4);
const kPreviousNeutralColor400 = Color(0xffdbdde2);
const kPreviousNeutralColor500 = Color(0xffbec0c5);
const kPreviousNeutralColor600 = Color(0xff000000);

const kNeutralColor900 = Color(0xff222222);
const kNeutralColor800 = Color(0xff444444);
const kNeutralColor700 = Color(0xff666666);
const kNeutralColor600 = Color(0xff777777);
const kNeutralColor500 = Color(0xff999999);
const kNeutralColor400 = Color(0xffbbbbbb);
const kNeutralColor300 = Color(0xffe0e0e0);
const kNeutralColor200 = Color(0xffeeeeee);
const kNeutralColor100 = Color(0xfff7f7f7);

//Primary Color
const kPreviousPrimaryColor = Color(0xff6d5de1);
const kPreviousPrimaryLightColor = Color(0xffe7e5f4);

const kPrimaryColor600 = Color(0xff6D5DE1);
const kPrimaryColor500 = Color(0xff8A7DE7);
const kPrimaryColor400 = Color(0xffC5BEF3);
const kPrimaryColor300 = Color(0xffE0DCF9);
const kPrimaryColor200 = Color(0xffE9E7FB);
const kPrimaryColor100 = Color(0xffF3F2FF);

//Secondary Color
const kPreviousSecondaryColor = Color(0xff5de1e1);

const kSecondaryColor600 = Color(0xff3CC6C6);
const kSecondaryColor500 = Color(0xff5DE1E1);
const kSecondaryColor400 = Color(0xff9EFAFA);
const kSecondaryColor300 = Color(0xffC8F9F9);
const kSecondaryColor200 = Color(0xffE8FAFA);
const kSecondaryColor100 = Color(0xffF1FDFD);

const kPreviousSecondaryLightColor = Color(0xffeef3ff);

//Black & White COlor
const kBlackColor = Color(0xff000000);
const kWhiteColor = Color(0xffFFFFFF);

//Success Color
const kSuccessColor400 = Color(0xff2E72D8);
const kSuccessColor300 = Color(0xff4D8DEC);
const kSuccessColor200 = Color(0xff87B7FE);
const kSuccessColor100 = Color(0xffC0D9FE);

//Warning Color
const kWarningColor400 = Color(0xffF56D21);
const kWarningColor300 = Color(0xffF1884D);
const kWarningColor200 = Color(0xffF3A478);
const kWarningColor100 = Color(0xffFBD7C3);

//Error Color
const kPreviousErrorColor = Color(0xffe14952);

const kErrorColor400 = Color(0xffE14952);
const kErrorColor300 = Color(0xffF7646D);
const kErrorColor200 = Color(0xffFD858C);
const kErrorColor100 = Color(0xffFFBCC0);

//Text Color
const kPreviousTextTitleColor = Color(0xff292a2a);
const kPreviousTextSubTitleColor = Color(0xff414348);
const kPreviousTextBodyColor = Color(0xff98a0b0);

//OpacityColor
Color kOpacityPrimaryColor600 = kPrimaryColor600.withOpacity(80);
Color kOpacityBlackColor900 = kBlackColor.withOpacity(75);
Color kOpacityBlackColor500 = kBlackColor.withOpacity(30);
Color kOpacityBlackColor50 = kBlackColor.withOpacity(3);
Color kOpacityNeutralColor800 = kNeutralColor800.withOpacity(80);
Color kOpacityNeutralColor500 = kNeutralColor500.withOpacity(80);
Color kOpacityErrorColor = kErrorColor400.withOpacity(80);

//Login Button Color
const kKakaoLoginColor = Color(0xffffd84f);
const kNaverLoginColor = Color(0xff03cf5d);
const kGoogleLoginColor = kPreviousNeutralColor100;
const kAppleLoginColor = Color(0xff000000);

//SignUp Color
// const kSignUpPrimaryColor = Color(0xff6D5DE1);
const kSignUpNickInvalidColor = Color(0xffE14952);
const kSignUpPassColor = Color(0xffff3a4a);

const kTextPrimary = kNeutralColor900;
const kTextSecondary = kNeutralColor800;
const kTextTertiary = kNeutralColor500;
const kTextWhite = kWhiteColor;
const kTextActionPrimary = kPrimaryColor600;
const kTextActionDisable = kNeutralColor200;
const kTextActionSuccess = kSuccessColor400;
const kTextActionWarning = kWarningColor400;
const kTextActionError = kErrorColor400;
const kTextTagSecondary = kSecondaryColor500;

const kBackgroundPrimary = kWhiteColor;
const kBackgroundSecondary = kNeutralColor200;
const kBackgroundTertiary = kNeutralColor100;
const kBackgroundActionPrimary = kPrimaryColor600;
const kBackgroundActionSecondary = kPrimaryColor200;
const kBackgroundActionSuccess = kErrorColor400;
const kBackgroundDisable = kNeutralColor300;

const kBorderPrimary = kNeutralColor300;
const kBorderSecondary = kNeutralColor200;
const kBorderTertiary = kNeutralColor100;
const kBorderFocus = kNeutralColor600;
const kBorderError = kErrorColor400;
Color kBorderOpacity = kOpacityBlackColor900;

const kIconActionPrimary = kPrimaryColor600;
const kIconActionSecondary = kPrimaryColor200;
const kIconPrimary = kNeutralColor800;
const kIconSecondary = kNeutralColor500;
const kIconTertiary = kWhiteColor;
const kIconDisable = kNeutralColor300;
const kIconDistructive = kErrorColor400;

Color kOpacityPrimary = kOpacityPrimaryColor600;
Color kOpacityNeutralPrimary = kOpacityNeutralColor500;
Color kOpacityNeutralSecondary = kOpacityNeutralColor800;
Color kOpacityError = kOpacityError;
Color kOpacityBlack = kOpacityBlackColor500;

Color kDimPrimary = kOpacityBlackColor900;

Color getSimpleTypeColor(String simpleType) {
  switch (simpleType) {
    case 'kakao':
      return kKakaoLoginColor;
    case 'naver':
      return kNaverLoginColor;
    case 'google':
      return const Color(0xFF3E82F1); //흰색 계열로 할 수 없어서 디자인 파트에 문의, 구글 로고의 파란색 코드
    case 'apple':
      return kAppleLoginColor;
    default:
      return kNeutralColor900;
  }
}
