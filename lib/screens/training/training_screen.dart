import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../../data/models/exercise.dart';
import '../../data/seed/exercises.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/exercise_image_view.dart';
import 'exercise_detail_sheet.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  String _selectedMuscle = AppStrings.allFilter;
  String _selectedEquipment = AppStrings.allFilter;

  static const List<String> muscleGroups = [
    AppStrings.allFilter,
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Full Body',
  ];

  static const List<String> equipmentList = [
    AppStrings.allFilter,
    'Bodyweight',
    'Dumbbell',
    'Barbell',
    'Machine',
  ];

  List<Exercise> get _filteredExercises {
    return seedExercises.where((ex) {
      final matchesMuscle = _selectedMuscle == AppStrings.allFilter ||
          ex.muscleGroup.toLowerCase() == _selectedMuscle.toLowerCase();
      final matchesEquipment = _selectedEquipment == AppStrings.allFilter ||
          ex.equipment.toLowerCase() == _selectedEquipment.toLowerCase();
      return matchesMuscle && matchesEquipment;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _selectedMuscle = AppStrings.allFilter;
      _selectedEquipment = AppStrings.allFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercises = _filteredExercises;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.trainingTitle),
            Text(
              'Select an exercise to start training',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Muscle group chips row
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: muscleGroups.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final muscle = muscleGroups[index];
                      final isSelected = _selectedMuscle == muscle;
                      return ChoiceChip(
                        label: Text(muscle),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedMuscle = muscle;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),

                // Equipment chips row
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: equipmentList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final equip = equipmentList[index];
                      final isSelected = _selectedEquipment == equip;
                      return FilterChip(
                        label: Text(
                          equip,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedEquipment = selected ? equip : AppStrings.allFilter;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Exercise List or Empty State
          Expanded(
            child: exercises.isEmpty
                ? EmptyStateView(
                    icon: Icons.fitness_center_outlined,
                    title: AppStrings.noExercisesFound,
                    subtitle: 'Try adjusting your muscle group or equipment filter.',
                    actionLabel: AppStrings.resetFilters,
                    onAction: _resetFilters,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return _ExerciseCard(
                        exercise: exercise,
                        onTap: () => ExerciseDetailSheet.show(context, exercise),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 88,
                  height: 88,
                  child: ExerciseImageView(
                    assetPath: exercise.gifAssetPath,
                    exerciseName: exercise.name,
                    muscleGroup: exercise.muscleGroup,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _buildSmallChip(
                          exercise.muscleGroup,
                          colorScheme.primaryContainer,
                          colorScheme.onPrimaryContainer,
                        ),
                        _buildSmallChip(
                          exercise.equipment,
                          colorScheme.surfaceContainerHighest,
                          colorScheme.onSurfaceVariant,
                        ),
                        _buildSmallChip(
                          exercise.exerciseType,
                          colorScheme.tertiaryContainer,
                          colorScheme.onTertiaryContainer,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
