import 'package:flutter/material.dart';

class ExerciseImageView extends StatelessWidget {
  final String assetPath;
  final String exerciseName;
  final String muscleGroup;
  final double? height;
  final double? width;
  final BoxFit fit;

  const ExerciseImageView({
    super.key,
    required this.assetPath,
    required this.exerciseName,
    required this.muscleGroup,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  IconData _getMuscleIcon(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'chest':
        return Icons.fitness_center;
      case 'back':
        return Icons.accessibility_new;
      case 'legs':
        return Icons.directions_walk;
      case 'shoulders':
        return Icons.accessibility;
      case 'arms':
        return Icons.sports_mma;
      case 'core':
        return Icons.sports_gymnastics;
      default:
        return Icons.bolt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Image.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Aesthetic placeholder when asset GIF hasn't been added yet
        return Container(
          height: height,
          width: width,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getMuscleIcon(muscleGroup),
                size: (height != null && height! < 120) ? 36 : 48,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  muscleGroup.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
