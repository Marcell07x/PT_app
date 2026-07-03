import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:getshap/core/streak/streak_date_utils.dart';

//goal: month calendar for the streak page, Duolingo style: the days of
//      the running streak are connected by an orange band, workout days
//      get an orange circle, freeze days a snowflake, rest days only the
//      band. The band runs squared into the neighbouring month's cells
//      when the streak crosses the month boundary.
class StreakCalendar extends StatefulWidget {
    final int streak;
    //day number of the first day of the streak (0 = no active streak)
    final int startDate;
    //day numbers on which a freeze was used
    final Set<int> freezeDays;
    //day numbers with an actual workout
    final Set<int> workoutDays;
    //today has a workout that is not done yet -> today is grey, not orange
    final bool todayPending;

    const StreakCalendar({
        super.key,
        required this.streak,
        required this.startDate,
        required this.freezeDays,
        required this.workoutDays,
        required this.todayPending,
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

    bool _inSpan(int dayN, int today) {
        return widget.streak > 0 &&
            widget.startDate > 0 &&
            dayN >= widget.startDate &&
            dayN <= today;
    }

    //inMonth = false: a cell of the neighbouring month, only the band shows
    Widget _dayCell(DateTime date, bool inMonth) {
        int dayN = StreakDateUtils.dayNum(date);
        int today = StreakDateUtils.dayNum(DateTime.now());

        bool inStreak = _inSpan(dayN, today);
        bool bandLeft = inStreak && _inSpan(dayN - 1, today);
        bool bandRight = inStreak && _inSpan(dayN + 1, today);

        //the band connecting the streak days: square where it continues,
        //rounded only at the real start and end of the streak
        Widget? band;
        if (inStreak) {
            band = Container(
                height: 36,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.orange.shade200,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(bandLeft ? 0 : 18),
                        right: Radius.circular(bandRight ? 0 : 18),
                    ),
                ),
            );
        }

        if (!inMonth) {
            return band == null ? const SizedBox() : Center(child: band);
        }

        bool isFreezeDay = widget.freezeDays.contains(dayN);
        bool isWorkoutDay = widget.workoutDays.contains(dayN);
        bool isPendingToday = inStreak && dayN == today && widget.todayPending;

        Color background = Colors.transparent;
        Border? border;
        Widget content = Text(
            '${date.day}',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
        );

        if (isFreezeDay) {
            background = Colors.lightBlue;
            content = const Icon(Icons.ac_unit, color: Colors.white, size: 18);
        } else if (isPendingToday) {
            background = Colors.grey;
            content = Text(
                '${date.day}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                ),
            );
        } else if (inStreak && isWorkoutDay) {
            background = Colors.orange;
            content = Text(
                '${date.day}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                ),
            );
        } else if (inStreak) {
            //rest day: the band passes through, no circle
            content = Text(
                '${date.day}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                ),
            );
        } else if (dayN == today) {
            border = Border.all(color: const Color.fromRGBO(22, 95, 239, 1), width: 2.0);
        }

        return Stack(
            children: [
                if (band != null) Center(child: band),
                Center(
                    child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: background,
                            border: border,
                            shape: BoxShape.circle,
                        ),
                        child: Center(child: content),
                    ),
                ),
            ],
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
        int cellCount = leadingBlanks + daysInMonth;
        while (cellCount % 7 != 0) {
            cellCount++;
        }

        final rows = <Widget>[];
        for (int i = 0; i < cellCount; i += 7) {
            rows.add(Row(
                children: [
                    for (int j = i; j < i + 7; j++)
                        Expanded(
                            child: SizedBox(
                                height: 42,
                                child: _dayCell(
                                    DateTime(_month.year, _month.month, j - leadingBlanks + 1),
                                    j >= leadingBlanks && j < leadingBlanks + daysInMonth,
                                ),
                            ),
                        ),
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
