import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_time_spinner.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/i18n_model.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/bottom_sheet_button_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/edit_my_information/edit_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/my_pet_common_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_post/my_post_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_picker_theme.dart' as picker_theme;

final _formKey = GlobalKey<FormState>();

class MyPetRegistrationScreen extends ConsumerStatefulWidget {
  const MyPetRegistrationScreen({super.key});

  @override
  MyPetRegistrationScreenState createState() => MyPetRegistrationScreenState();
}

class MyPetRegistrationScreenState extends ConsumerState<MyPetRegistrationScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController nameController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController ageEditingController = TextEditingController();

  FocusNode breedFocusNode = FocusNode();
  int weightValue = 1;
  bool isReadOnly = true;

  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;
  bool isProfileImageDelete = false;

  final RegExp _letterRegExp = RegExp(r'[가-힣a-zA-Z0-9_]');

  Future openGallery() async {
    selectedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    setState(() {
      isProfileImageDelete = false;
    });
  }

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    breedFocusNode.addListener(() {
      if (!breedFocusNode.hasFocus) {
        setState(() {
          isReadOnly = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameProvider = ref.watch(nickNameProvider);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "우리 아이 등록",
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                '완료',
                style: kButton12BoldStyle.copyWith(
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0.h, bottom: 30.h),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: WidgetMask(
                            blendMode: BlendMode.srcATop,
                            childSaveLayer: true,
                            mask: Center(
                                child: "${ref.watch(editStateProvider).userInfoModel!.userModel!.profileImgUrl}" == ""
                                    ? selectedImage == null
                                        ? const Icon(
                                            Puppycat_social.icon_profile_large,
                                            size: 92,
                                            color: kNeutralColor500,
                                          )
                                        : Image.file(
                                            File(selectedImage!.path),
                                            width: 135,
                                            height: 135,
                                            fit: BoxFit.cover,
                                          )
                                    : selectedImage == null
                                        ? isProfileImageDelete
                                            ? const Icon(
                                                Puppycat_social.icon_profile_large,
                                                size: 92,
                                                color: kNeutralColor500,
                                              )
                                            : Image.network(
                                                Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${ref.read(userInfoProvider).userModel!.profileImgUrl}").toUrl(),
                                                width: 135,
                                                height: 135,
                                                fit: BoxFit.cover,
                                              )
                                        : Image.file(
                                            File(selectedImage!.path),
                                            width: 135,
                                            height: 135,
                                            fit: BoxFit.cover,
                                          )),
                            child: SvgPicture.asset(
                              'assets/image/feed/image/squircle.svg',
                              height: 84.h,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              showCustomModalBottomSheet(
                                context: context,
                                widget: Column(
                                  children: [
                                    BottomSheetButtonItem(
                                      icon: const Icon(
                                        Puppycat_social.icon_photo,
                                      ),
                                      title: '앨범에서 선택',
                                      titleStyle: kButton14BoldStyle.copyWith(color: kTextSubTitleColor),
                                      onTap: () {
                                        context.pop();

                                        openGallery();
                                      },
                                    ),
                                    BottomSheetButtonItem(
                                      icon: const Icon(
                                        Puppycat_social.icon_delete_small,
                                        color: kBadgeColor,
                                      ),
                                      title: '프로필 사진 삭제',
                                      titleStyle: kButton14BoldStyle.copyWith(color: kBadgeColor),
                                      onTap: () {
                                        setState(() {
                                          selectedImage = null;
                                          isProfileImageDelete = false;
                                        });
                                        context.pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: kNeutralColor100,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: -2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Puppycat_social.icon_modify_medium,
                                color: kTextBodyColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: '이름을 입력해주세요',
                            hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                            errorStyle: kBody11RegularStyle.copyWith(color: kBadgeColor, fontWeight: FontWeight.w400, height: 1.2),
                            errorText: getNickDescription(nameProvider),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: kBadgeColor,
                              ),
                            ),
                            errorMaxLines: 2,
                            counterText: '',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                          maxLength: 20,
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (value.length > 1) {
                                setState(() {
                                  // ref.read(checkButtonProvider.notifier).state = true;
                                });
                              }
                              if (value == ref.watch(editStateProvider).userInfoModel!.userModel!.nick) {
                                setState(() {
                                  // ref.read(checkButtonProvider.notifier).state = false;
                                });
                              }
                              String lastChar = value[value.length - 1];
                              if (lastChar.contains(RegExp(r'[a-zA-Z]'))) {
                                nameController.value = TextEditingValue(text: toLowercase(value), selection: nameController.selection);
                                return;
                              }
                            } else {
                              setState(() {
                                // ref.read(checkButtonProvider.notifier).state = false;
                              });
                            }
                            ref.read(nickNameProvider.notifier).state = NickNameStatus.nonValid;
                          },
                          validator: (value) {
                            if (value != null) {
                              if (value.isNotEmpty) {
                                if (_letterRegExp.allMatches(value).length != value.length) {
                                  Future(() {
                                    ref.watch(nickNameProvider.notifier).state = NickNameStatus.invalidLetter;
                                  });
                                  return getNickDescription(NickNameStatus.invalidLetter);
                                } else if (value.isNotEmpty && value.length < 2) {
                                  Future(() {
                                    ref.watch(nickNameProvider.notifier).state = NickNameStatus.minLength;
                                  });
                                  return getNickDescription(NickNameStatus.minLength);
                                } else {
                                  // isCheckableNickName = true;
                                  return null;
                                }
                              }
                            }
                          },
                          onSaved: (val) {},
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: '동물등록 번호 입력해주세요',
                            hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                            errorMaxLines: 2,
                            counterText: '',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                          maxLength: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              TabBar(
                  controller: tabController,
                  indicatorWeight: 3,
                  labelColor: kPrimaryColor,
                  indicatorColor: kPrimaryColor,
                  unselectedLabelColor: kNeutralColor500,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.only(
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  tabs: [
                    Text(
                      "기본정보",
                      style: kBody14BoldStyle,
                    ),
                    Text(
                      "건강정보",
                      style: kBody14BoldStyle,
                    ),
                  ]),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _firstTabBody(),
                    _secondTabBody(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstTabBody() {
    final genderSelected = ref.watch(myPetGenderProvider);
    final sizeSelected = ref.watch(myPetSizeProvider);
    final ageSelected = ref.watch(myPetAgeProvider);

    return ListView(
      children: [
        Text("품종"),
        TextFormField(
          controller: breedController,
          readOnly: isReadOnly,
          focusNode: breedFocusNode,
          onFieldSubmitted: (value) {
            setState(() {
              isReadOnly = true;
            });
          },
          onTap: () async {
            if (isReadOnly) {
              var breed = await context.push("/home/myPage/myPetList/myPetRegistration/myPetBreedSearch");
              print(breed);
              // Update the text field with the result.
              breedController.text = breed != null ? breed.toString() : "";
            }

            // breedController.text = "${breed!['formatAddress']}";
          },
          decoration: InputDecoration(
            hintText: '품종 검색',
            hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
            errorMaxLines: 2,
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
          maxLength: 20,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              setState(() {
                isReadOnly = !isReadOnly; // Toggle the readOnly state
                if (!isReadOnly) {
                  // If it's not read-only, request focus to bring up the keyboard
                  FocusScope.of(context).requestFocus(breedFocusNode);
                }
              });
            },
            child: Text("직접입력"),
          ),
        ),
        Text("성별"),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: PetGender.values.map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        ref.watch(myPetGenderProvider.notifier).state = item.value; // state에 code 값을 설정
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: genderSelected == item.value
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryLightColor,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kNeutralColor400),
                            ),
                      child: Center(
                        child: Text(
                          item.name,
                          style: kButton14BoldStyle.copyWith(color: genderSelected == item.value ? kPrimaryColor : kTextBodyColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Text("크기"),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: PetSize.values.map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        ref.watch(myPetSizeProvider.notifier).state = item.value; // state에 code 값을 설정
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: sizeSelected == item.value
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryLightColor,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kNeutralColor400),
                            ),
                      child: Center(
                        child: Text(
                          item.name,
                          style: kButton14BoldStyle.copyWith(color: sizeSelected == item.value ? kPrimaryColor : kTextBodyColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Text(
          "무게 ${weightValue} kg",
        ),
        buildSliderTopLabel(),
        Text("연령이 어떻게 되나요?"),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: PetAge.values.map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        ref.watch(myPetAgeProvider.notifier).state = item.value;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: ageSelected == item.value
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryLightColor,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kNeutralColor400),
                            ),
                      child: Center(
                        child: Text(
                          item.name,
                          style: kButton14BoldStyle.copyWith(color: ageSelected == item.value ? kPrimaryColor : kTextBodyColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Text("생년월일"),
        TextFormField(
          readOnly: true,
          controller: ageEditingController,
          onTap: () async {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1930, 1, 1),
              maxTime: DateTime(2022, 12, 31),
              onConfirm: (date) {
                setState(() {
                  ageEditingController.text = DateFormat('yyyy-MM-dd').format(date);
                });
              },
              currentTime: ageEditingController.text == "" ? DateTime(2020, 01, 01) : DateTime.parse(ageEditingController.text),
              locale: LocaleType.ko,
              theme: picker_theme.DatePickerTheme(
                itemStyle: kButton14MediumStyle.copyWith(color: kNeutralColor600),
                backgroundColor: kNeutralColor100,
                title: "나이 입력하기",
              ),
            );
          },
          decoration: InputDecoration(
            hintText: '품종 검색',
            hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
            errorMaxLines: 2,
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
          maxLength: 20,
        ),
      ],
    );
  }

  Widget _secondTabBody() {
    return Container();
  }

  Widget buildSliderTopLabel() {
    final labels = ['0kg', '25kg', '50kg', '75kg', '100kg'];
    final double min = 0;
    final double max = 100;
    final divisions = 99;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Utils.modelBuilder(
              labels,
              (index, label) {
                const selectedColor = Colors.black;
                final unselectedColor = Colors.black.withOpacity(0.3);
                final isSelected = index <= weightValue;
                final color = isSelected ? selectedColor : unselectedColor;
                return buildLabel(label: label.toString(), color: color, width: 55);
              },
            ),
          ),
        ),
        SliderTheme(
          data: const SliderThemeData(
            trackHeight: 16,
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            inactiveTrackColor: kNeutralColor400,
            thumbColor: kPrimaryColor,
            activeTrackColor: kPrimaryColor,
          ),
          child: Slider(
            value: weightValue!.toDouble(),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: (value) => setState(() => weightValue = value.toInt()),
          ),
        ),
      ],
    );
  }

  Widget buildLabel({
    required String label,
    required double width,
    required Color color,
  }) =>
      Container(
        width: width,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: kBody12RegularStyle.copyWith(color: kNeutralColor600),
        ),
      );
}

class Utils {
  static List<Widget> modelBuilder<M>(List<M> models, Widget Function(int index, M model) builder) => models
      .asMap()
      .map<int, Widget>(
        (index, model) => MapEntry(
          index,
          builder(index, model),
        ),
      )
      .values
      .toList();
}
