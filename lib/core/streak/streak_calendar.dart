import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:getshap/core/streak/streak_date_utils.dart';

//goal: month calendar for the streak page: the days of the running
//      streak are highlighted, freeze days get a snowflake
class StreakCalendar extends StatefulWidget {
    final int streak;
    //day number of the first day of the streak (0 = no active streak)
    final int startDate;
    //day numbers on which a freeze was used
    final Set<int> freezeDays;

    const StreakCalendar({
        super.key,
        required this.streak,
        required this.startDate,
        required this.freezeDays,
    });

    @override
    State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
    //first day of the month being shown
    late DateTime _month;

    @override
    void initState() {
        super.initState();
        final now = DateTime.now();
        _month = DateTime(now.year, now.month, 1);
    }

    void _changeMonth(int step) {
        setState(() {
            _month = DateTime(_month.year, _month.month + step, 1);
        });
    }

    Widget _dayCell(int day) {
        int dayN = StreakDateUtils.dayNum(DateTime(_month.year, _month.month, day));
        int today = StreakDateUtils.dayNum(DateTime.now());

        bool isFreezeDay = widget.freezeDays.contains(dayN);
        bool inStreak = widget.streak > 0 &&
            widget.startDate > 0 &&
            dayN >= widget.startDate &&
            dayN <= today;

        Color background = Colors.transparent;
        Border? border;
        Widget content = Text(
            '$day',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
        );

        if (isFreezeDay) {
            background = Colors.lightBlue;
            content = const Icon(Icons.ac_unit, color: Colors.white, size: 18);
        } else if (inStreak) {
            background = Colors.orange;
            content = Text(
                '$day',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                ),
            );
        } else if (dayN == today) {
            border = Border.all(color: const Color.fromRGBO(22, 95, 239, 1), width: 2.0);
        }

        return Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: background,
                border: border,
                shape: BoxShape.circle,
            ),
            child: Center(child: content),
        );
    }

    @override
    Widget build(BuildContext context) {
        final locale = Localizations.localeOf(context).toString();

        //2024-01-01 was a Monday, used only for the weekday labels
        final weekdayNames = List.generate(
            7,
            (i) => DateFormat.E(locale).format(DateTime(2024, 1, 1 + i)),
        );

        int daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
        int leadingBlanks = DateTime(_month.year, _month.month, 1).weekday - 1;

        final cells = <Widget>[
            for (int i = 0; i < leadingBlanks; i++) const SizedBox(),
            for (int day = 1; day <= daysInMonth; day++) Center(child: _dayCell(day)),
        ];
        while (cells.length % 7 != 0) {
            cells.add(const SizedBox());
        }

        final rows = <Widget>[];
        for (int i = 0; i < cells.length; i += 7) {
            rows.add(Row(
                children: [
                    for (int j = i; j < i + 7; j++) Expanded(child: SizedBox(height: 42, child: cells[j])),
                ],
            ));
        }

        return Column(
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        IconButton(
                            icon: const Icon(Icons.chevron_left, color: Colors.black54),
                            onPressed: () => _changeMonth(-1),
                        ),
                        Text(
                            DateFormat.yMMMM(locale).format(_month),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                            ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.black54),
                            onPressed: () => _changeMonth(1),
                        ),
                    ],
                ),
                Row(
                    children: [
                        for (final name in weekdayNames)
                            Expanded(
                                child: Center(
                                    child: Text(
                                        name,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                        ),
                                    ),
                                ),
                            ),
                    ],
                ),
                const SizedBox(height: 4),
                ...rows,
            ],
        );
    }
}
