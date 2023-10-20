import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/base_picker_model.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_time_spinner.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/i18n_model.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/walk_result/walk_result_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/work_log/work_log_result_screen.dart';
import 'package:table_calendar/table_calendar.dart';

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
final kFirstDay = DateTime(2020, 12, 20);
final kLastDay = DateTime.now();

class WorkLogCalendarScreen extends ConsumerStatefulWidget {
  const WorkLogCalendarScreen({Key? key}) : super(key: key);

  @override
  WorkLogCalendarScreenState createState() => WorkLogCalendarScreenState();
}

class WorkLogCalendarScreenState extends ConsumerState<WorkLogCalendarScreen> {
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

    init();
  }

  init() async {
    await ref.read(walkResultStateProvider.notifier).getWalkResult(
          searchStartDate: DateFormat('yyyy-MM-dd').format(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            1,
          )),
          searchEndDate: DateFormat('yyyy-MM-dd').format(DateTime(
            DateTime.now().year,
            DateTime.now().month + 1,
            0,
          )),
        );

    _populateEvents(ref.read(walkResultStateProvider).list);
  }

  void _populateEvents(List<WalkResultItemModel> results) {
    setState(() {
      for (var result in results) {
        final date = DateTime.parse(result.regDate!);

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
      body: Column(
        children: [
          InkWell(
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
                  itemStyle: kButton14MediumStyle.copyWith(color: kNeutralColor600),
                  backgroundColor: kNeutralColor100,
                  title: "다른 날짜 보기",
                  isBirthDay: false,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('yyyy년 M월').format(_focusedDay),
                    style: kTitle18BoldStyle.copyWith(color: kNeutralColor600),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
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
              isTodayHighlighted: true,
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkLogResultScreen(
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
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            children: [
                              Text('혼자 산책'),
                              Text('${value[index]}'),
                            ],
                          )),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
