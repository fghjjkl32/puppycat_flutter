import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/my_pet_common_provider.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

final _formKey = GlobalKey<FormState>();

class UserPetDetailScreen extends ConsumerStatefulWidget {
  const UserPetDetailScreen({
    super.key,
    required this.itemModel,
  });

  final MyPetItemModel itemModel;

  @override
  UserPetDetailScreenState createState() => UserPetDetailScreenState();
}

class UserPetDetailScreenState extends ConsumerState<UserPetDetailScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "우리 아이 등록",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0.h, bottom: 30.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: Center(
                          child: widget.itemModel.url == "" || widget.itemModel.url == null
                              ? const Icon(
                                  Puppycat_social.icon_profile_large,
                                  size: 92,
                                  color: kNeutralColor500,
                                )
                              : Image.network(
                                  Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${widget.itemModel.url}").toUrl(),
                                  width: 135,
                                  height: 135,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: SvgPicture.asset(
                          'assets/image/feed/image/squircle.svg',
                          height: 84.h,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 32.h,
                          child: FormBuilderTextField(
                            enabled: false,
                            initialValue: "${widget.itemModel.name}",
                            decoration: InputDecoration(
                                counterText: "", hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500), filled: true, fillColor: kNeutralColor300, contentPadding: const EdgeInsets.all(16)),
                            name: 'content',
                            style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    Text("품종"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: SizedBox(
                        height: 32.h,
                        child: FormBuilderTextField(
                          enabled: false,
                          initialValue: "${widget.itemModel.breedIdx == 1 || widget.itemModel.breedIdx == 2 ? widget.itemModel.breedNameEtc : widget.itemModel.breedName}",
                          decoration: InputDecoration(
                              counterText: "", hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500), filled: true, fillColor: kNeutralColor300, contentPadding: const EdgeInsets.all(16)),
                          name: 'content',
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                          textAlignVertical: TextAlignVertical.center,
                        ),
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
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: widget.itemModel.genderText == item.name
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
                                    style: kButton14BoldStyle.copyWith(color: widget.itemModel.genderText == item.name ? kPrimaryColor : kTextBodyColor),
                                    textAlign: TextAlign.center,
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
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: widget.itemModel.sizeText == item.name
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
                                    style: kButton14BoldStyle.copyWith(color: widget.itemModel.sizeText == item.name ? kPrimaryColor : kTextBodyColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Text(
                      "무게 ${widget.itemModel.weight} kg",
                    ),
                    buildSliderTopLabel(),
                    Row(
                      children: [
                        Text("연령이 어떻게 되나요?"),
                        JustTheTooltip(
                          child: Material(
                            color: Colors.grey.shade800,
                            shape: const CircleBorder(),
                            elevation: 4.0,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.question_mark,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          preferredDirection: AxisDirection.up,
                          content: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '생후 1세 이하\n강아지 : 퍼피 ㅣ 고양이 : 키튼\n7세 미만\n강아지&고양이 공통 : 어덜트\n7세 이상\n강아지&고양이 공통 : 시니어',
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: PetAge.values.map((item) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: widget.itemModel.ageText == item.name
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
                                    style: kButton14BoldStyle.copyWith(color: widget.itemModel.ageText == item.name ? kPrimaryColor : kTextBodyColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Text("생년월일"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: SizedBox(
                        height: 32.h,
                        child: FormBuilderTextField(
                          enabled: false,
                          initialValue: DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.itemModel.birth!)),
                          decoration: InputDecoration(
                              counterText: "", hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500), filled: true, fillColor: kNeutralColor300, contentPadding: const EdgeInsets.all(16)),
                          name: 'content',
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    Text("성격 및 특징"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                      child: SizedBox(
                        height: 32.h,
                        child: FormBuilderTextField(
                          enabled: false,
                          initialValue: "${widget.itemModel.personalityIdx == 7 ? widget.itemModel.personalityEtc : widget.itemModel.personality}",
                          decoration: InputDecoration(
                              counterText: "", hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500), filled: true, fillColor: kNeutralColor300, contentPadding: const EdgeInsets.all(16)),
                          name: 'content',
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSliderTopLabel() {
    final labels = ['1kg', '25kg', '50kg'];
    final double min = 1;
    final double max = 50;
    final divisions = 49;

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
                final isSelected = index <= widget.itemModel.weight!.toDouble();
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
            value: widget.itemModel.weight!.toDouble(),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: (value) => {},
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
