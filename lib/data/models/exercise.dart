class Exercise {
  final String id;
  final String name;
  final String muscleGroup; // e.g. Chest, Back, Legs, Arms, Core, Shoulders, Full Body
  final String exerciseType; // Gym, Cardio, Bodyweight, Stretching
  final String equipment; // e.g. "Bodyweight", "Dumbbell", "Machine", "Barbell"
  final String gifAssetPath; // e.g. "assets/gifs/push_up.gif"
  final String? youtubeUrl; // optional
  final String instructions; // short text

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.exerciseType,
    required this.equipment,
    required this.gifAssetPath,
    this.youtubeUrl,
    required this.instructions,
  });
}

