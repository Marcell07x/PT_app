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

            appBarTheme: AppBarTheme(
                backgroundColor: AppColors.brand500,
                foregroundColor: AppColors.onBrand,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: false,
                titleTextStyle: AppText.titleLarge.copyWith(
                    color: AppColors.onBrand,
                ),
                iconTheme: const IconThemeData(color: AppColors.onBrand),
                actionsIconTheme: const IconThemeData(color: AppColors.onBrand),
                // The bar is saturated blue at the top of every screen, so the
                // status bar needs light content. Nothing in the app used to
                // set this at all.
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.dark,
                ),
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

            drawerTheme: const DrawerThemeData(
                backgroundColor: AppColors.brand500,
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
