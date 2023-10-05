import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/base_picker_model.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_time_spinner.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/i18n_model.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/common/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
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

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) {
      final date = DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5);
      return List.generate(item % 4 + 1, (index) => Event('Event $item | ${index + 1}', date));
    })
  ..addAll({
    kToday: [
      Event('Event Today | 1', kToday),
      Event('Event Today | 2', kToday),
    ],
  });

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
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class WorkLogCalendarScreen extends StatefulWidget {
  const WorkLogCalendarScreen({Key? key}) : super(key: key);

  @override
  State<WorkLogCalendarScreen> createState() => _WorkLogCalendarScreenState();
}

class _WorkLogCalendarScreenState extends State<WorkLogCalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day]?.map((e) => Event(e.title, day)).toList() ?? [];
  }

  List<Event> getAllEvents() {
    List<Event> allEvents = [];
    kEvents.forEach((date, events) {
      events.forEach((event) {
        allEvents.add(Event(event.title, date));
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
          TableCalendar<Event>(
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
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        List<Event> allEvents = getAllEvents();

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
