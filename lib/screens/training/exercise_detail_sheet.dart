import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/strings.dart';
import '../../data/models/exercise.dart';
import '../../services/timer_service.dart';
import '../../widgets/exercise_image_view.dart';

class ExerciseDetailSheet extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailSheet({super.key, required this.exercise});

  static Future<void> show(BuildContext context, Exercise exercise) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseDetailSheet(exercise: exercise),
    );
  }

  @override
  State<ExerciseDetailSheet> createState() => _ExerciseDetailSheetState();
}

class _ExerciseDetailSheetState extends State<ExerciseDetailSheet> {
  int _selectedDuration = 30; // default 30s
  late final TimerService _timerService;

  @override
  void initState() {
    super.initState();
    _timerService = TimerService();
    _timerService.setup(widget.exercise.name, _selectedDuration);
  }

  @override
  void dispose() {
    _timerService.dispose();
    super.dispose();
  }

  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open YouTube link.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ChangeNotifierProvider<TimerService>.value(
      value: _timerService,
      child: Consumer<TimerService>(
        builder: (context, timer, child) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Exercise Animated GIF Header
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 10,
                            child: ExerciseImageView(
                              assetPath: widget.exercise.gifAssetPath,
                              exerciseName: widget.exercise.name,
                              muscleGroup: widget.exercise.muscleGroup,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title & Tags
                        Text(
                          widget.exercise.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Filter/Meta Chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _buildMetaBadge(
                              label: widget.exercise.muscleGroup,
                              icon: Icons.fitness_center,
                              colorScheme: colorScheme,
                            ),
                            _buildMetaBadge(
                              label: widget.exercise.exerciseType,
                              icon: Icons.category,
                              colorScheme: colorScheme,
                            ),
                            _buildMetaBadge(
                              label: widget.exercise.equipment,
                              icon: Icons.build_circle_outlined,
                              colorScheme: colorScheme,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Instructions
                        Text(
                          AppStrings.instructions,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.exercise.instructions,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.45,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Watch on YouTube button if available
                        if (widget.exercise.youtubeUrl != null) ...[
                          OutlinedButton.icon(
                            onPressed: () => _launchYouTube(widget.exercise.youtubeUrl!),
                            icon: const Icon(Icons.play_circle_fill, color: Colors.red),
                            label: const Text(AppStrings.watchOnYoutube),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // TIMER & WORKOUT SECTION
                        _buildTimerSection(context, timer, theme, colorScheme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetaBadge({
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection(
    BuildContext context,
    TimerService timer,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (timer.isCompleted) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.emoji_events, size: 56, color: Colors.amber),
            const SizedBox(height: 10),
            Text(
              AppStrings.exerciseComplete,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${AppStrings.exerciseCompleteMsg} ${widget.exercise.name}!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      timer.reset();
                    },
                    child: const Text('Do Another Set'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Finish'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (timer.isRunning || timer.isPaused) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: timer.isPaused
                ? Colors.amber.withValues(alpha: 0.5)
                : colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Circular countdown & monospace text
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: CircularProgressIndicator(
                    value: timer.progress,
                    strokeWidth: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      timer.isPaused ? Colors.amber : colorScheme.primary,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timer.formattedRemaining,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      timer.isPaused ? 'PAUSED' : 'REMAINING',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: timer.isPaused ? Colors.amber : colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (timer.isRunning)
                  FilledButton.icon(
                    onPressed: () => timer.pause(),
                    icon: const Icon(Icons.pause),
                    label: const Text(AppStrings.pauseTraining),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: () => timer.resume(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(AppStrings.resumeTraining),
                  ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => timer.cancel(),
                  icon: const Icon(Icons.stop),
                  label: const Text(AppStrings.cancelTraining),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // IDLE: Duration selector & Start Button
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Training Timer',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_selectedDuration}s',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Preset Chips
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [15, 30, 45, 60, 90].map((preset) {
            final isSelected = _selectedDuration == preset;
            return ChoiceChip(
              label: Text('${preset}s'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedDuration = preset;
                  });
                  timer.setup(widget.exercise.name, preset);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),

        // Slider for custom duration (10s to 180s)
        Slider(
          value: _selectedDuration.toDouble(),
          min: 10,
          max: 180,
          divisions: 34,
          label: '${_selectedDuration}s',
          onChanged: (value) {
            setState(() {
              _selectedDuration = value.round();
            });
            timer.setup(widget.exercise.name, _selectedDuration);
          },
        ),
        const SizedBox(height: 8),

        // Large Start Button
        FilledButton.icon(
          onPressed: () {
            timer.start(widget.exercise.name, _selectedDuration);
          },
          icon: const Icon(Icons.timer),
          label: Text('${AppStrings.startTraining} (${_selectedDuration}s)'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
