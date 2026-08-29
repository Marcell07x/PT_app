import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:getshap/common/ui/app_button.dart';
import 'package:getshap/common/ui/app_card.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

class WorkoutScreen extends StatefulWidget {
    final String videoPath;
    final String exerciseName;
    final String reps;
    final String description;
    final String buttonText;
    final String label;
    final VoidCallback onNextPressed;
    final VoidCallback onPreviousPressed;
    final int currentIndex;
    final int totalWorkouts;
    final int level;

    const WorkoutScreen({
        super.key,
        required this.videoPath,
        required this.exerciseName,
        required this.reps,
        required this.description,
        required this.buttonText,
        required this.label,
        required this.onNextPressed,
        required this.onPreviousPressed,
        required this.currentIndex,
        required this.totalWorkouts,
        required this.level,
    });

    @override
    State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
    late VideoPlayerController _controller;
    double _videoAspectRatio = 16 / 9;

    @override
    void initState() {
        super.initState();
        _initializeVideo();
    }

    void _initializeVideo() {
        // Capture the controller locally so the initialize callback always acts
        // on this exact instance, never on one that was later replaced/disposed.
        final controller = VideoPlayerController.asset(widget.videoPath);
        _controller = controller;

        controller.initialize().then((_) {
            if (!mounted || controller != _controller) return;
            setState(() {
                _videoAspectRatio = controller.value.aspectRatio;
            });
            controller.setLooping(true);
            controller.setVolume(0.0);
            controller.play();
        });
    }

    void _disposeController() {
        _controller.dispose();
    }

    @override
    void didUpdateWidget(WorkoutScreen oldWidget) {
        super.didUpdateWidget(oldWidget);
        if (oldWidget.videoPath != widget.videoPath) {
            _disposeController();
            _initializeVideo();
        }
    }

    @override
    void dispose() {
        _disposeController();
        super.dispose();
    }

    /// True once there is somewhere to step back to: an earlier exercise, or
    /// the warm-up that preceded the workout at level 130 and above.
    bool _canGoBack(AppLocalizations loc) =>
        widget.currentIndex > 0 ||
        (widget.label == loc.workout && widget.level >= 130);

    @override
    Widget build(BuildContext context) {
        final AppLocalizations loc = AppLocalizations.of(context)!;
        final bool canGoBack = _canGoBack(loc);

        return AppScaffold(
            title: '${widget.label} (${widget.currentIndex + 1}/${widget.totalWorkouts})',
            leading: IconButton(
                icon: const Icon(Icons.close),
                // Pop back to the live home page rather than building a second
                // one. Both exits from a workout now take the same route (the
                // congratulations screen already does this), and the existing
                // home keeps its WorkoutSignal.onSignalChanged registration — a
                // fresh MyHomePage would claim that single static slot in
                // initState only for the old page's dispose to null it again
                // immediately afterwards, silently killing the home screen's
                // streak/flame refresh for the rest of the session. The workout
                // route is removed either way, so back still cannot return to it.
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
            ),
            bottomBar: Row(
                children: <Widget>[
                    if (canGoBack) ...<Widget>[
                        AppButton.icon(
                            icon: Icons.arrow_back_rounded,
                            label: loc.goback,
                            onPressed: widget.onPreviousPressed,
                        ),
                        const SizedBox(width: AppSpacing.md),
                    ],
                    Expanded(
                        child: AppButton(
                            label: widget.buttonText,
                            size: AppButtonSize.md,
                            trailingIcon: Icons.arrow_forward_rounded,
                            onPressed: widget.onNextPressed,
                        ),
                    ),
                ],
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    const SizedBox(height: AppSpacing.md),
                    LinearProgressIndicator(
                        value: (widget.currentIndex + 1) / widget.totalWorkouts,
                        minHeight: 6,
                        borderRadius: AppRadius.all(AppRadius.xs),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildVideo(context),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                        widget.exerciseName,
                        textAlign: TextAlign.center,
                        style: AppText.headlineSmall.copyWith(color: AppColors.n900),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildRepsPill(),
                    const SizedBox(height: AppSpacing.xl),
                    // Takes the remaining height and scrolls inside it, rather
                    // than the old fixed 200px box that clipped at large system
                    // font sizes.
                    Expanded(
                        child: AppCard(
                            color: AppColors.n100,
                            shadow: const <BoxShadow>[],
                            padding: const EdgeInsets.fromLTRB(
                                AppSpacing.xl,
                                AppSpacing.lg,
                                AppSpacing.sm,
                                AppSpacing.lg,
                            ),
                            child: Scrollbar(
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                    padding: const EdgeInsets.only(right: AppSpacing.md),
                                    child: Text(
                                        widget.description,
                                        style: AppText.bodyMedium.copyWith(
                                            color: AppColors.n900,
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                ],
            ),
        );
    }

    Widget _buildVideo(BuildContext context) {
        return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            alignment: Alignment.center,
            child: AspectRatio(
                aspectRatio: _videoAspectRatio,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: AppColors.videoBackdrop,
                        borderRadius: AppRadius.all(AppRadius.md),
                        boxShadow: AppShadows.md,
                    ),
                    child: ClipRRect(
                        borderRadius: AppRadius.all(AppRadius.md),
                        child: _controller.value.isInitialized
                            ? VideoPlayer(_controller)
                            : const Center(child: CircularProgressIndicator()),
                    ),
                ),
            ),
        );
    }

    /// The rep count, set apart from the exercise name by a brand-tinted pill
    /// rather than the old full-width blue rule.
    Widget _buildRepsPill() {
        return Center(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                    color: AppColors.brand50,
                    borderRadius: AppRadius.all(AppRadius.pill),
                ),
                child: Text(
                    widget.reps,
                    style: AppText.titleMedium.copyWith(color: AppColors.brand700),
                ),
            ),
        );
    }
}
