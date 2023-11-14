import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/base_picker_model.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_time_spinner.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/i18n_model.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/walk_result/walk_result_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/walk_log_result_edit_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

class YearMonthModel extends DatePickerModel {
  YearMonthModel({required DateTime currentTime, required DateTime maxTime, required DateTime minTime, required LocaleType locale})
      : super(currentTime: currentTime, maxTime: maxTime, minTime: minTime, locale: locale);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}

class Event {
  final String title;
  final DateTime date;

  const Event(this.title, this.date);

  @override
  String toString() => title;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event && other.title == title && other.date == date;
  }

  @override
  int get hashCode => title.hashCode ^ date.hashCode;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(2023, 08, 01);
final kLastDay = DateTime.now();

class WalkLogCalendarScreen extends ConsumerStatefulWidget {
  const WalkLogCalendarScreen({Key? key}) : super(key: key);

  @override
  WalkLogCalendarScreenState createState() => WalkLogCalendarScreenState();
}

class WalkLogCalendarScreenState extends ConsumerState<WalkLogCalendarScreen> {
  ValueNotifier<List<WalkResultItemModel>> _selectedEvents = ValueNotifier<List<WalkResultItemModel>>([]);

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  LinkedHashMap<DateTime, List<WalkResultItemModel>> kEvents = LinkedHashMap<DateTime, List<WalkResultItemModel>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  @override
  void initState() {
    super.initState();

    init(
      DateFormat('yyyy-MM-dd').format(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          1,
        ),
      ),
      DateFormat('yyyy-MM-dd').format(
        DateTime(
          DateTime.now().year,
          DateTime.now().month + 1,
          0,
        ),
      ),
    );
  }

  init(String searchStartDate, String searchEndDate) async {
    await ref.read(walkResultStateProvider.notifier).getWalkResult(
          searchStartDate: searchStartDate,
          searchEndDate: searchEndDate,
        );

    _populateEvents(ref.read(walkResultStateProvider).list);
  }

  void _populateEvents(List<WalkResultItemModel> results) {
    setState(() {
      kEvents = LinkedHashMap<DateTime, List<WalkResultItemModel>>(
        equals: isSameDay,
        hashCode: getHashCode,
      );

      for (var result in results) {
        final date = DateTime.parse(result.startDate!);

        if (kEvents[date] != null) {
          kEvents[date]?.add(result);
        } else {
          kEvents[date] = [result];
        }
      }

      getAllEvents();

      _selectedDay = _focusedDay;
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<WalkResultItemModel> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<WalkResultItemModel> getAllEvents() {
    List<WalkResultItemModel> allEvents = [];
    kEvents.forEach((date, events) {
      events.forEach((event) {
        allEvents.add(event);
      });
    });
    return allEvents;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    if (DateFormat('yyyy-MM-dd').format(now) == DateFormat('yyyy-MM-dd').format(date)) {
      return true;
    }
    return false;
  }

  DateTime addOneMonth(DateTime dt) {
    int newMonth = dt.month + 1;
    int newYear = dt.year;

    if (newMonth == 13) {
      newMonth = 1;
      newYear += 1;
    }

    // 월의 마지막 날짜보다 큰 날짜가 주어지면 월의 마지막 날짜로 변경
    int lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day;
    int newDay = dt.day <= lastDayOfMonth ? dt.day : lastDayOfMonth;

    return DateTime(newYear, newMonth, newDay);
  }

  DateTime subtractOneMonth(DateTime dt) {
    int newMonth = dt.month - 1;
    int newYear = dt.year;

    if (newMonth == 0) {
      newMonth = 12;
      newYear -= 1;
    }

    // 월의 마지막 날짜보다 큰 날짜가 주어지면 월의 마지막 날짜로 변경
    int lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day;
    int newDay = dt.day <= lastDayOfMonth ? dt.day : lastDayOfMonth;

    return DateTime(newYear, newMonth, newDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "산책 일지",
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
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _focusedDay.year > kFirstDay.year || (_focusedDay.year == kFirstDay.year && _focusedDay.month > kFirstDay.month)
                          ? InkWell(
                              onTap: () {
                                if (_focusedDay.year > kFirstDay.year || (_focusedDay.year == kFirstDay.year && _focusedDay.month > kFirstDay.month)) {
                                  setState(() {
                                    _focusedDay = subtractOneMonth(_focusedDay);
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kNeutralColor200,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: kTextBodyColor,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: kNeutralColor100,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.chevron_left,
                                  color: kNeutralColor100,
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () {
                            DatePicker.showPicker(
                              context,
                              pickerModel: YearMonthModel(
                                currentTime: _focusedDay,
                                maxTime: kLastDay,
                                minTime: kFirstDay,
                                locale: LocaleType.ko,
                              ),
                              showTitleActions: true,
                              onConfirm: (date) {
                                setState(() {
                                  _focusedDay = date;
                                });
                              },
                              locale: LocaleType.ko,
                              theme: picker_theme.DatePickerTheme(
                                containerHeight: 100,
                                itemStyle: kButton14MediumStyle.copyWith(color: kNeutralColor600),
                                backgroundColor: kNeutralColor100,
                                title: "",
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat('yyyy. M').format(_focusedDay),
                              style: kTitle18BoldStyle.copyWith(color: kTextTitleColor),
                            ),
                          ),
                        ),
                      ),
                      _focusedDay.year < kToday.year || (_focusedDay.year == kToday.year && _focusedDay.month < kToday.month)
                          ? InkWell(
                              onTap: () {
                                if (_focusedDay.year < kToday.year || (_focusedDay.year == kToday.year && _focusedDay.month < kToday.month)) {
                                  setState(() {
                                    _focusedDay = addOneMonth(_focusedDay);
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kNeutralColor200,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: kTextBodyColor,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: kNeutralColor100,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.chevron_right,
                                  color: kNeutralColor100,
                                ),
                              ),
                            ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Center(
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            _focusedDay = DateTime.now();
                          });
                        },
                        child: Text(
                          '오늘',
                          style: kBody12SemiBoldStyle.copyWith(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: kNeutralColor100,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: [
                              Text(
                                "총 거리",
                                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                              Text(
                                "${ref.read(walkResultStateProvider).totalDistance}km",
                                style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: kNeutralColor100,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                Text(
                                  "총 시간",
                                  style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                                ),
                                Text(
                                  "${ref.read(walkResultStateProvider).totalWalkTime}",
                                  style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: kNeutralColor100,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: [
                              Text(
                                "총 칼로리",
                                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                              Text(
                                "${ref.read(walkResultStateProvider).totalCalorie}kcal",
                                style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TableCalendar<WalkResultItemModel>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                weekendDays: const [DateTime.sunday, 6],
                startingDayOfWeek: StartingDayOfWeek.sunday,
                rangeSelectionMode: _rangeSelectionMode,
                headerVisible: false,
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  cellPadding: EdgeInsets.only(top: 10),
                  cellAlignment: Alignment.bottomCenter,
                  isTodayHighlighted: true,
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });

                  print(_focusedDay);

                  init(
                    DateFormat('yyyy-MM-dd').format(
                      DateTime(
                        _focusedDay.year,
                        _focusedDay.month,
                        1,
                      ),
                    ),
                    DateFormat('yyyy-MM-dd').format(
                      DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                        0,
                      ),
                    ),
                  );
                },
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    return Text(
                      DateFormat.E('ko-KR').format(day),
                      textAlign: TextAlign.center,
                      style: kBody14BoldStyle.copyWith(color: kTextBodyColor),
                    );
                  },
                  // markerBuilder: (context, day, events) {
                  //   return InkWell(
                  //     onTap: () {
                  //       _onDaySelected(day, _focusedDay);
                  //     },
                  //     child: Center(
                  //       child: events.isEmpty && isToday(day)
                  //           ? Container(
                  //               decoration: const BoxDecoration(
                  //                 color: kNeutralColor200,
                  //                 shape: BoxShape.circle,
                  //               ),
                  //               child: Padding(
                  //                 padding: EdgeInsets.only(top: 2),
                  //                 child: Image.asset(
                  //                   'assets/image/character/character_06_mypage_walk_dailylog_default.png',
                  //                   width: 40,
                  //                 ),
                  //               ),
                  //             )
                  //           : isToday(day)
                  //               ? Container(
                  //                   decoration: const BoxDecoration(
                  //                     color: kPrimaryColor,
                  //                     shape: BoxShape.circle,
                  //                   ),
                  //                   child: Padding(
                  //                     padding: EdgeInsets.only(top: 2),
                  //                     child: Image.asset(
                  //                       'assets/image/character/character_06_mypage_walk_dailylog_great.png',
                  //                       width: 40,
                  //                     ),
                  //                   ),
                  //                 )
                  //               : events.isNotEmpty
                  //                   ? Container(
                  //                       decoration: const BoxDecoration(
                  //                         color: kPrimaryColor,
                  //                         shape: BoxShape.circle,
                  //                       ),
                  //                       child: Padding(
                  //                         padding: EdgeInsets.only(top: 2),
                  //                         child: Image.asset(
                  //                           'assets/image/character/character_06_mypage_walk_dailylog_great.png',
                  //                           width: 30,
                  //                         ),
                  //                       ),
                  //                     )
                  //                   : Container(
                  //                       decoration: const BoxDecoration(
                  //                         color: kNeutralColor200,
                  //                         shape: BoxShape.circle,
                  //                       ),
                  //                       child: Padding(
                  //                         padding: EdgeInsets.only(top: 2),
                  //                         child: Image.asset(
                  //                           'assets/image/character/character_06_mypage_walk_dailylog_default.png',
                  //                           width: 30,
                  //                         ),
                  //                       ),
                  //                     ),
                  //     ),
                  //   );
                  // },
                  prioritizedBuilder: (context, day, events) {
                    return Column(
                      children: [
                        Text(
                          DateFormat('d', 'ko_KR').format(day).replaceAll('일', ''),
                          style: kBody14RegularStyle.copyWith(color: kTextSubTitleColor),
                        ),
                        InkWell(
                          onTap: () {
                            _onDaySelected(day, _focusedDay);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: kNeutralColor200,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Image.asset(
                                'assets/image/character/character_06_mypage_walk_dailylog_default.png',
                                width: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },

                  // prioritizedBuilder: (context, day, events) {
                  //   return isToday(day)
                  //       ? Padding(
                  //           padding: const EdgeInsets.only(
                  //             bottom: 14,
                  //           ),
                  //           child: Container(
                  //             width: 25.w,
                  //             height: 16.h,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(10.0),
                  //               color: kOrange300Color,
                  //             ),
                  //             child: Center(
                  //               child: Text(
                  //                 DateFormat('d').format(day),
                  //                 style: kCaption1Style.copyWith(color: kWhiteColor),
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       : DateTime.now().isAfter(day)
                  //           ? Padding(
                  //               padding: EdgeInsets.all(16.0.w),
                  //               child: Text(
                  //                 DateFormat('d').format(day),
                  //                 style: kCaption1Style.copyWith(color: Theme.of(context).colorScheme.iconSubColor),
                  //               ),
                  //             )
                  //           : Container();
                  // },
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ValueListenableBuilder<List<WalkResultItemModel>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            List<WalkResultItemModel> allEvents = getAllEvents();

                            int initialIndex = allEvents.indexOf(value[index]);
                            if (initialIndex == -1) {
                              initialIndex = 0;
                            }

                            print(value[index].walkUuid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WalkLogResultEditScreen(
                                  events: allEvents,
                                  initialIndex: initialIndex,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: kNeutralColor300, width: 1)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                      color: kPrimaryLightColor,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(100.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                                      child: Text(
                                                        "산책일지",
                                                        style: kBody11SemiBoldStyle.copyWith(color: kPrimaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    "${DateFormat('MM-dd EEE', 'ko_KR').format(DateTime.parse(value[index].startDate!))}",
                                                    style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: kNeutralColor200,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Icon(
                                                                Puppycat_social.icon_comment,
                                                                size: 16,
                                                                color: kTextBodyColor,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            formatDuration(
                                                              DateTime.parse(value[index].endDate!).difference(
                                                                DateTime.parse(value[index].startDate!),
                                                              ),
                                                            ),
                                                            style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: kNeutralColor200,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Icon(
                                                                Puppycat_social.icon_comment,
                                                                size: 16,
                                                                color: kTextBodyColor,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            "${value[index].stepText}",
                                                            style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: kNeutralColor200,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Icon(
                                                                Puppycat_social.icon_comment,
                                                                size: 16,
                                                                color: kTextBodyColor,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            '${value[index].distanceText}',
                                                            style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: kNeutralColor200,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Icon(
                                                                Puppycat_social.icon_comment,
                                                                size: 16,
                                                                color: kTextBodyColor,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            '${value[index].calorieText}',
                                                            style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            WidgetMask(
                                              blendMode: BlendMode.srcATop,
                                              childSaveLayer: true,
                                              mask: Center(
                                                child: Image.network(
                                                  Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${value[index].walkPetList![0].petProfileUrl}").toUrl(),
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/image/feed/image/squircle.svg',
                                                height: 40,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: kTextBodyColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  value[index].walkPetList!.length > 1
                                      ? Positioned(
                                          right: 26,
                                          top: 14,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: kTextSubTitleColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Center(
                                                child: Text(
                                                  "+${value[index].walkPetList!.length - 1}",
                                                  style: kBadge10MediumStyle.copyWith(color: kNeutralColor100),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 42,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: kTextSubTitleColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Text(
                      "${DateFormat('M').format(_focusedDay)} 분석",
                      style: kBody11SemiBoldStyle.copyWith(color: kNeutralColor100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
