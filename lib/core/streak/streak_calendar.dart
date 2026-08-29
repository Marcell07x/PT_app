import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:getshap/core/debug_clock.dart';
import 'package:getshap/core/streak/streak_date_utils.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

//goal: month calendar for the streak page: the days of
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
        final now = DebugClock.now();
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
        int today = StreakDateUtils.dayNum(DebugClock.now());

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
                    color: AppColors.flameBand,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(bandLeft ? 0 : AppRadius.lg),
                        right: Radius.circular(bandRight ? 0 : AppRadius.lg),
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

        // Five states, each with its own shape cue as well as its own colour:
        // freeze = filled + snowflake, pending today = filled muted, workout =
        // filled warm, rest day inside the streak = bare numeral on the band,
        // today outside the streak = ring. Every white-on-colour pair here
        // clears WCAG AA; the previous orange/grey fills did not.
        Color background = Colors.transparent;
        Border? border;
        Widget content = Text(
            '${date.day}',
            style: AppText.bodySmall.copyWith(color: AppColors.n600),
        );

        Widget numeral(Color color) => Text(
            '${date.day}',
            style: AppText.weight(
                AppText.bodySmall.copyWith(color: color),
                700,
            ),
        );

        if (isFreezeDay) {
            background = AppColors.freeze;
            content = const Icon(Icons.ac_unit, color: AppColors.onBrand, size: 18);
        } else if (isPendingToday) {
            background = AppColors.n500;
            content = numeral(AppColors.onBrand);
        } else if (inStreak && isWorkoutDay) {
            background = AppColors.flameInk;
            content = numeral(AppColors.onBrand);
        } else if (inStreak) {
            //rest day: the band passes through, no circle
            content = numeral(AppColors.flameBandInk);
        } else if (dayN == today) {
            border = Border.all(color: AppColors.brand500, width: 2.0);
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
                    children: [
                        IconButton(
                            icon: const Icon(Icons.chevron_left, color: AppColors.n500),
                            onPressed: () => _changeMonth(-1),
                        ),
                        // Expanded rather than spaceBetween: a long month name
                        // ("2026. augusztus") overflows a narrow phone once the
                        // two 48px arrow buttons have taken their share.
                        Expanded(
                            child: Text(
                                DateFormat.yMMMM(locale).format(_month),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.titleSmall.copyWith(color: AppColors.n900),
                            ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.chevron_right, color: AppColors.n500),
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
                                        style: AppText.labelSmall.copyWith(color: AppColors.n500),
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
