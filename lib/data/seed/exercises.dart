import '../models/exercise.dart';

const List<Exercise> seedExercises = [
  // CHEST
  Exercise(
    id: 'chest_pushup',
    name: 'Standard Push-Up',
    muscleGroup: 'Chest',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/push_up.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
    instructions:
        'Place hands shoulder-width apart, keep body in a rigid straight plank line, lower chest until elbows reach 90 degrees, and push back up smoothly.',
  ),
  Exercise(
    id: 'chest_bench_press',
    name: 'Barbell Bench Press',
    muscleGroup: 'Chest',
    exerciseType: 'Gym',
    equipment: 'Barbell',
    gifAssetPath: 'assets/gifs/chest_bench_press.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=rT7DgCr-3pg',
    instructions:
        'Lie flat on the bench, grip the barbell slightly wider than shoulder width. Lower bar with control to mid-chest, then drive upwards keeping scapulae retracted.',
  ),
  Exercise(
    id: 'chest_incline_dumbbell_press',
    name: 'Incline Dumbbell Press',
    muscleGroup: 'Chest',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/chest_incline_dumbbell_press.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=8iPEnn-ltC8',
    instructions:
        'Set bench to a 30-45 degree incline. Press dumbbells upward together over upper chest, converging near the peak without clanking.',
  ),
  Exercise(
    id: 'chest_cable_crossover',
    name: 'Cable Crossover Fly',
    muscleGroup: 'Chest',
    exerciseType: 'Gym',
    equipment: 'Machine',
    gifAssetPath: 'assets/gifs/chest_cable_crossover.gif',
    instructions:
        'Stand centered between high pulleys. Bring handles forward and down in a hugging arc, squeezing chest at contraction point.',
  ),
  Exercise(
    id: 'chest_dips',
    name: 'Chest Dips',
    muscleGroup: 'Chest',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/chest_dips.gif',
    instructions:
        'Support yourself on parallel bars. Lean torso forward slightly, bend elbows to lower body until a gentle stretch is felt in chest, then push up.',
  ),
  Exercise(
    id: 'chest_dumbbell_pullover',
    name: 'Dumbbell Pullover',
    muscleGroup: 'Chest',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/chest_dumbbell_pullover.gif',
    instructions:
        'Lie perpendicular across a flat bench with upper back supported. Lower dumbbell back over head with slightly bent arms, feel chest and lats expand, then pull back.',
  ),

  // BACK
  Exercise(
    id: 'back_superman',
    name: 'Superman Holds',
    muscleGroup: 'Back',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/superman.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=z6PJMT2y8GQ',
    instructions:
        'Lie face down on a mat with arms extended forward. Simultaneously lift chest, arms, and legs off the ground engaging erector spinae and glutes. Hold and lower.',
  ),
  Exercise(
    id: 'back_pullup',
    name: 'Wide Grip Pull-Up',
    muscleGroup: 'Back',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/back_pullup.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=eGo4IYlbE5g',
    instructions:
        'Hang from bar with hands wider than shoulders, palms facing away. Pull chest up toward the bar, driving elbows down and back.',
  ),
  Exercise(
    id: 'back_barbell_deadlift',
    name: 'Conventional Barbell Deadlift',
    muscleGroup: 'Back',
    exerciseType: 'Gym',
    equipment: 'Barbell',
    gifAssetPath: 'assets/gifs/back_barbell_deadlift.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=op9kVnSso6Q',
    instructions:
        'Stand with feet hip-width apart under the barbell. Hinge at hips with flat spine, grip bar, and stand tall by driving hips forward and engaging posterior chain.',
  ),
  Exercise(
    id: 'back_bent_over_row',
    name: 'Bent-Over Barbell Row',
    muscleGroup: 'Back',
    exerciseType: 'Gym',
    equipment: 'Barbell',
    gifAssetPath: 'assets/gifs/back_bent_over_row.gif',
    instructions:
        'Hinge forward at 45 degrees with flat back. Pull bar toward lower ribs while retracting shoulder blades and keeping elbows close to body.',
  ),
  Exercise(
    id: 'back_lat_pulldown',
    name: 'Seated Lat Pulldown',
    muscleGroup: 'Back',
    exerciseType: 'Gym',
    equipment: 'Machine',
    gifAssetPath: 'assets/gifs/back_lat_pulldown.gif',
    instructions:
        'Grip wide bar, sit down with thighs secured under pads. Pull bar down smoothly to upper chest while arching upper spine slightly.',
  ),
  Exercise(
    id: 'back_seated_cable_row',
    name: 'Seated Cable Row',
    muscleGroup: 'Back',
    exerciseType: 'Gym',
    equipment: 'Machine',
    gifAssetPath: 'assets/gifs/back_seated_cable_row.gif',
    instructions:
        'Sit with feet firmly planted on footrests. Pull V-bar handle towards abdomen, squeezing shoulder blades together without excessive leaning.',
  ),
  Exercise(
    id: 'back_cat_cow_stretch',
    name: 'Cat-Cow Spinal Stretch',
    muscleGroup: 'Back',
    exerciseType: 'Stretching',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/back_cat_cow.gif',
    instructions:
        'Begin on hands and knees. Inhale, drop belly toward floor while looking up (cow). Exhale, arch spine upwards toward ceiling while tucking chin (cat).',
  ),

  // LEGS
  Exercise(
    id: 'legs_bodyweight_squat',
    name: 'Air Squat',
    muscleGroup: 'Legs',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/legs_bodyweight_squat.gif',
    instructions:
        'Stand feet shoulder-width, toes slightly flared. Bend knees and push hips back to lower into deep squat, keeping heels planted and chest high.',
  ),
  Exercise(
    id: 'legs_barbell_squat',
    name: 'Barbell Back Squat',
    muscleGroup: 'Legs',
    exerciseType: 'Gym',
    equipment: 'Barbell',
    gifAssetPath: 'assets/gifs/legs_barbell_squat.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=bEv6CCg2BC8',
    instructions:
        'Rest bar across upper traps. Inhale, brace core, sit hips down and back until thighs reach parallel, then push through mid-foot to stand.',
  ),
  Exercise(
    id: 'legs_romanian_deadlift',
    name: 'Dumbbell Romanian Deadlift',
    muscleGroup: 'Legs',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/legs_romanian_deadlift.gif',
    instructions:
        'Hold dumbbells at thighs. Keep soft bend in knees, push hips backward as dumbbells glide down shins until hamstrings stretch, then snap hips forward.',
  ),
  Exercise(
    id: 'legs_bulgarian_split_squat',
    name: 'Bulgarian Split Squat',
    muscleGroup: 'Legs',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/legs_bulgarian_split_squat.gif',
    instructions:
        'Elevate rear foot on bench. Lower hips vertically until front thigh is nearly parallel to ground, maintaining upright torso posture.',
  ),
  Exercise(
    id: 'legs_leg_press',
    name: 'Incline Leg Press',
    muscleGroup: 'Legs',
    exerciseType: 'Gym',
    equipment: 'Machine',
    gifAssetPath: 'assets/gifs/legs_leg_press.gif',
    instructions:
        'Sit firmly in sled machine with feet shoulder-width on footplate. Lower weight with control until knees form 90 degrees, press through heels without locking knees.',
  ),
  Exercise(
    id: 'legs_walking_lunges',
    name: 'Walking Lunges',
    muscleGroup: 'Legs',
    exerciseType: 'Cardio',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/legs_walking_lunges.gif',
    instructions:
        'Step forward boldly, lowering rear knee towards floor. Drive through front heel to step directly into the next forward lunge.',
  ),
  Exercise(
    id: 'legs_standing_calf_raise',
    name: 'Standing Calf Raise',
    muscleGroup: 'Legs',
    exerciseType: 'Gym',
    equipment: 'Machine',
    gifAssetPath: 'assets/gifs/legs_standing_calf_raise.gif',
    instructions:
        'Stand balls of feet on edge of platform. Lower heels to full stretch, then push forcefully onto toes, pausing at full contraction.',
  ),

  // SHOULDERS
  Exercise(
    id: 'shoulders_overhead_press',
    name: 'Standing Barbell Overhead Press',
    muscleGroup: 'Shoulders',
    exerciseType: 'Gym',
    equipment: 'Barbell',
    gifAssetPath: 'assets/gifs/shoulders_overhead_press.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=2yjwXTZQDDI',
    instructions:
        'Clean bar to collarbone. Squeeze glutes and core, press barbell vertically overhead until arms lock out, moving head slightly forward at top.',
  ),
  Exercise(
    id: 'shoulders_lateral_raise',
    name: 'Dumbbell Lateral Raise',
    muscleGroup: 'Shoulders',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/shoulders_lateral_raise.gif',
    instructions:
        'Hold dumbbells at sides with slight elbow bend. Raise arms outward to shoulder height leading with elbows, pause, and lower slowly.',
  ),
  Exercise(
    id: 'shoulders_face_pulls',
    name: 'Cable Face Pulls',
    muscleGroup: 'Shoulders',
    exerciseType: 'Gym',
    equipment: 'Machine',
    gifAssetPath: 'assets/gifs/shoulders_face_pulls.gif',
    instructions:
        'Attach rope to upper pulley. Pull handles towards eyes, flaring elbows out and externally rotating shoulders to target rear delts.',
  ),
  Exercise(
    id: 'shoulders_arnold_press',
    name: 'Seated Arnold Press',
    muscleGroup: 'Shoulders',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/shoulders_arnold_press.gif',
    instructions:
        'Hold dumbbells in front of shoulders with palms facing you. Rotate wrists as you press overhead so palms face forward at top of movement.',
  ),
  Exercise(
    id: 'shoulders_pike_pushup',
    name: 'Pike Push-Up',
    muscleGroup: 'Shoulders',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/shoulders_pike_pushup.gif',
    instructions:
        'Assume downward-dog pose with hips piked high. Lower forehead towards floor in front of hands, then push straight back up.',
  ),

  // ARMS
  Exercise(
    id: 'arms_barbell_curl',
    name: 'Standing Barbell Bicep Curl',
    muscleGroup: 'Arms',
    exerciseType: 'Gym',
    equipment: 'Barbell',
    gifAssetPath: 'assets/gifs/arms_barbell_curl.gif',
    instructions:
        'Stand holding barbell with underhand shoulder-width grip. Keeping elbows tucked at sides, curl bar up toward shoulders, squeezing biceps at peak.',
  ),
  Exercise(
    id: 'arms_hammer_curl',
    name: 'Dumbbell Hammer Curl',
    muscleGroup: 'Arms',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/arms_hammer_curl.gif',
    instructions:
        'Hold dumbbells with neutral palms-in grip. Curl weights upward maintaining rigid wrist position to hit brachialis and forearm muscles.',
  ),
  Exercise(
    id: 'arms_tricep_rope_pushdown',
    name: 'Tricep Rope Pushdown',
    muscleGroup: 'Arms',
    exerciseType: 'Gym',
    equipment: 'Machine',
    gifAssetPath: 'assets/gifs/arms_tricep_rope_pushdown.gif',
    instructions:
        'Attach rope to high pulley. Keep upper arms pinned vertically by sides, extend elbows fully and flare rope apart at bottom lockout.',
  ),
  Exercise(
    id: 'arms_skull_crushers',
    name: 'Lying Tricep Skull Crushers',
    muscleGroup: 'Arms',
    exerciseType: 'Gym',
    equipment: 'Barbell',
    gifAssetPath: 'assets/gifs/arms_skull_crushers.gif',
    instructions:
        'Lie on flat bench holding EZ bar straight up. Bend elbows to lower weight carefully down to forehead, then extend triceps back to start.',
  ),
  Exercise(
    id: 'arms_diamond_pushup',
    name: 'Diamond Push-Up',
    muscleGroup: 'Arms',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/arms_diamond_pushup.gif',
    instructions:
        'Position thumbs and index fingers touching under sternum in a diamond shape. Lower chest to hands and press up, isolating triceps.',
  ),
  Exercise(
    id: 'arms_tricep_bench_dips',
    name: 'Bench Tricep Dips',
    muscleGroup: 'Arms',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/arms_bench_dips.gif',
    instructions:
        'Place hands behind you on bench edge with legs extended forward. Lower hips by bending elbows to 90 degrees, then press back up.',
  ),

  // CORE
  Exercise(
    id: 'core_mountain_climber',
    name: 'Mountain Climbers',
    muscleGroup: 'Core',
    exerciseType: 'Cardio',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/mountain_climber.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=nmwgirgXLYM',
    instructions:
        'Start in high plank position. Alternately drive knees towards chest at a brisk, controlled running pace while keeping hips level.',
  ),
  Exercise(
    id: 'core_plank',
    name: 'Forearm Plank',
    muscleGroup: 'Core',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/core_plank.gif',
    instructions:
        'Rest on forearms and toes with elbows directly below shoulders. Squeeze abdominals, glutes, and quads to keep body perfectly straight.',
  ),
  Exercise(
    id: 'core_bicycle_crunches',
    name: 'Bicycle Crunches',
    muscleGroup: 'Core',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/core_bicycle_crunches.gif',
    instructions:
        'Lie on back with hands behind head. Rotate right elbow toward left knee while extending right leg, then fluidly alternate sides.',
  ),
  Exercise(
    id: 'core_hanging_leg_raise',
    name: 'Hanging Leg Raise',
    muscleGroup: 'Core',
    exerciseType: 'Gym',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/core_hanging_leg_raise.gif',
    instructions:
        'Hang from pull-up bar. Without swinging, lift straight legs upward until parallel to floor or higher, curling pelvis at top.',
  ),
  Exercise(
    id: 'core_russian_twists',
    name: 'Russian Twists',
    muscleGroup: 'Core',
    exerciseType: 'Bodyweight',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/core_russian_twists.gif',
    instructions:
        'Sit with knees bent, lean torso back at 45 degrees, elevate feet slightly, and rotate hands side to side touching mat on each rotation.',
  ),
  Exercise(
    id: 'core_cobra_stretch',
    name: 'Cobra Abdominal Stretch',
    muscleGroup: 'Core',
    exerciseType: 'Stretching',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/core_cobra.gif',
    instructions:
        'Lie prone, place hands beside ribs, and gently straighten arms to arch chest upward while keeping pelvis pressed on the floor.',
  ),

  // FULL BODY & CARDIO
  Exercise(
    id: 'fullbody_jumping_jacks',
    name: 'Jumping Jacks',
    muscleGroup: 'Full Body',
    exerciseType: 'Cardio',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/jumping_jacks.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=c4DAnQ6DtF8',
    instructions:
        'Stand tall with feet together. Jump feet out wide while swinging arms overhead in a wide arc, then jump back to start in rhythmic cadence.',
  ),
  Exercise(
    id: 'fullbody_burpees',
    name: 'Full Body Burpees',
    muscleGroup: 'Full Body',
    exerciseType: 'Cardio',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/fullbody_burpees.gif',
    youtubeUrl: 'https://www.youtube.com/watch?v=dZgVxmf6jkA',
    instructions:
        'Drop into squat, kick feet back into plank, perform push-up, jump feet back into squat, and explode upward into a vertical jump with hands high.',
  ),
  Exercise(
    id: 'fullbody_kettlebell_swing',
    name: 'Kettlebell Russian Swing',
    muscleGroup: 'Full Body',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/fullbody_kettlebell_swing.gif',
    instructions:
        'Hinge at hips to swing kettlebell between legs, then snap hips forward forcefully to propel weight to eye level using glute drive.',
  ),
  Exercise(
    id: 'fullbody_thrusters',
    name: 'Dumbbell Thrusters',
    muscleGroup: 'Full Body',
    exerciseType: 'Gym',
    equipment: 'Dumbbell',
    gifAssetPath: 'assets/gifs/fullbody_thrusters.gif',
    instructions:
        'Hold dumbbells at shoulders, drop into deep front squat, then explosively drive up and press dumbbells overhead in one continuous motion.',
  ),
  Exercise(
    id: 'fullbody_high_knees',
    name: 'High Knees Sprint',
    muscleGroup: 'Full Body',
    exerciseType: 'Cardio',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/fullbody_high_knees.gif',
    instructions:
        'Run in place lifting knees vigorously towards chest height while pumping arms in opposition with rapid ground turnover.',
  ),
  Exercise(
    id: 'fullbody_jump_rope',
    name: 'Jump Rope Simulation',
    muscleGroup: 'Full Body',
    exerciseType: 'Cardio',
    equipment: 'Bodyweight',
    gifAssetPath: 'assets/gifs/fullbody_jump_rope.gif',
    instructions:
        'Bounce lightly on the balls of your feet with knees soft while rotating wrists in rhythm as if turning a speed rope.',
  ),
];

