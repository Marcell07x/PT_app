import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

/// The app's one and only theme.
///
/// There is no dark variant by design: the brand is a single light appearance,
/// applied identically on both platforms.
///
/// Component themes are configured generously here rather than at call sites,
/// so that widgets the app does not style by hand — dialogs, snack bars,
/// checkboxes, progress indicators — come out on-brand for free. The
/// user-facing "update available" dialog in particular used to render in stock
/// Material lavender.
abstract final class AppTheme {
    /// The system bars on every ordinary screen — the ones on [AppColors.pageBg].
    ///
    /// A const shorthand for `systemBarsOn(AppColors.pageBg)`, so [AppBarTheme]
    /// can hold it without rebuilding.
    ///
    /// The navigation bar used to be set in exactly one place: the splash
    /// screen, to brand blue. Nothing ever set it back, so that blue leaked into
    /// every screen for the rest of the session and the bottom of the app stayed
    /// a colour no page actually used.
    static const SystemUiOverlayStyle systemBars = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.pageBg,
        systemNavigationBarDividerColor: AppColors.pageBg,
        systemNavigationBarIconBrightness: Brightness.dark,
    );

    /// The system bars for a screen whose background is [background].
    ///
    /// The navigation bar takes the colour of the page it sits under, so the
    /// back button and its neighbours read as part of the screen rather than a
    /// strip laid across the bottom of it. The two screens that are full-bleed
    /// brand blue therefore get a blue bar, not a pale one.
    ///
    /// The icon brightness is derived from the colour rather than passed in, so
    /// a caller cannot pair a dark background with dark icons and make the
    /// buttons vanish.
    static SystemUiOverlayStyle systemBarsOn(Color background) {
        final bool isDark =
            ThemeData.estimateBrightnessForColor(background) == Brightness.dark;

        return SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: background,
            systemNavigationBarDividerColor: background,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
        );
    }

    static ThemeData light() {
        final ColorScheme scheme = const ColorScheme.light(
            primary: AppColors.brand500,
            onPrimary: AppColors.onBrand,
            primaryContainer: AppColors.brand100,
            onPrimaryContainer: AppColors.brand900,
            secondary: AppColors.brand600,
            onSecondary: AppColors.onBrand,
            surface: AppColors.surface,
            onSurface: AppColors.n900,
            surfaceContainerHighest: AppColors.n100,
            onSurfaceVariant: AppColors.n600,
            outline: AppColors.n300,
            outlineVariant: AppColors.n200,
            error: AppColors.danger,
            onError: AppColors.onBrand,
            errorContainer: AppColors.dangerSubtle,
            onErrorContainer: AppColors.danger,
        );

        final TextTheme text = AppText.textTheme;

        return ThemeData(
            useMaterial3: true,
            colorScheme: scheme,
            fontFamily: AppText.family,
            textTheme: text.apply(
                bodyColor: AppColors.n900,
                displayColor: AppColors.n900,
            ),
            scaffoldBackgroundColor: AppColors.pageBg,
            canvasColor: AppColors.pageBg,
            splashFactory: InkSparkle.splashFactory,

            // The bar is no longer a saturated slab: the page background runs
            // straight through it. Blue used to sit at the top of every screen,
            // which meant it marked nothing in particular — it is now spent
            // where a decision is (the primary button, the progress, the
            // selected option), and the header just holds a title.
            //
            // The one screen that stays full-bleed brand blue is the
            // congratulations page: there the colour *is* the content.
            appBarTheme: AppBarTheme(
                backgroundColor: AppColors.pageBg,
                foregroundColor: AppColors.n900,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: false,
                titleTextStyle: AppText.titleLarge.copyWith(
                    color: AppColors.n900,
                ),
                iconTheme: const IconThemeData(color: AppColors.n600),
                actionsIconTheme: const IconThemeData(color: AppColors.n600),
                // Light bar, so the status bar needs dark content — and the
                // navigation bar comes along, so an AppBar screen cannot leave
                // the bottom on whatever the previous route set.
                systemOverlayStyle: systemBars,
            ),

            iconTheme: const IconThemeData(color: AppColors.n600),

            dividerTheme: const DividerThemeData(
                color: AppColors.n200,
                thickness: 1,
                space: 1,
            ),

            progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: AppColors.brand500,
                linearTrackColor: AppColors.n100,
                circularTrackColor: AppColors.n100,
            ),

            // A hairline rather than Material's grey slab. Where a screen asks
            // for a persistent scrollbar it is saying "there is more below" —
            // that message does not need eight pixels of grey to land, and the
            // default one competed with the text it was pointing at.
            scrollbarTheme: const ScrollbarThemeData(
                thumbColor: WidgetStatePropertyAll<Color>(AppColors.n300),
                thickness: WidgetStatePropertyAll<double>(4),
                radius: Radius.circular(2),
                crossAxisMargin: 2,
                interactive: true,
            ),

            checkboxTheme: CheckboxThemeData(
                fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
                    return s.contains(WidgetState.selected)
                        ? AppColors.brand500
                        : AppColors.surface;
                }),
                checkColor: const WidgetStatePropertyAll<Color>(AppColors.onBrand),
                side: const BorderSide(color: AppColors.n300, width: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.all(AppRadius.xs),
                ),
            ),

            sliderTheme: SliderThemeData(
                activeTrackColor: AppColors.brand500,
                inactiveTrackColor: AppColors.n200,
                thumbColor: AppColors.surface,
                overlayColor: AppColors.brand200,
                valueIndicatorColor: AppColors.n900,
            ),

            listTileTheme: ListTileThemeData(
                iconColor: AppColors.n600,
                textColor: AppColors.n900,
                titleTextStyle: AppText.titleSmall.copyWith(color: AppColors.n900),
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.all(AppRadius.sm),
                ),
            ),

            // White panel rather than a blue one, for the same reason as the
            // app bar: a menu is not a decision.
            drawerTheme: const DrawerThemeData(
                backgroundColor: AppColors.surface,
                surfaceTintColor: Colors.transparent,
                elevation: 12,
            ),

            dialogTheme: DialogThemeData(
                backgroundColor: AppColors.surface,
                surfaceTintColor: Colors.transparent,
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.all(AppRadius.lg),
                ),
                titleTextStyle: AppText.titleLarge.copyWith(color: AppColors.n900),
                contentTextStyle: AppText.bodyMedium.copyWith(color: AppColors.n600),
            ),

            snackBarTheme: SnackBarThemeData(
                backgroundColor: AppColors.n900,
                contentTextStyle: AppText.bodyMedium.copyWith(
                    color: AppColors.onBrand,
                ),
                actionTextColor: AppColors.brand200,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.all(AppRadius.sm),
                ),
            ),

            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.brand500,
                    textStyle: AppText.labelLarge,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.all(AppRadius.sm),
                    ),
                ),
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand500,
                    foregroundColor: AppColors.onBrand,
                    textStyle: AppText.labelLarge,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.all(AppRadius.sm),
                    ),
                ),
            ),

            inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppColors.n100,
                hintStyle: AppText.bodyMedium.copyWith(color: AppColors.n400),
                border: OutlineInputBorder(
                    borderRadius: AppRadius.all(AppRadius.sm),
                    borderSide: const BorderSide(color: AppColors.n200),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.all(AppRadius.sm),
                    borderSide: const BorderSide(color: AppColors.n200),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.all(AppRadius.sm),
                    borderSide: const BorderSide(
                        color: AppColors.brand500,
                        width: 2,
                    ),
                ),
            ),
        );
    }
}
