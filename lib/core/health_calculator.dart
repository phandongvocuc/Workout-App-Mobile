import 'package:flutter/material.dart';

enum HealthMetricType {
  bmi,
  minCaloriesNeeded,
  minCaloriesToBurn,
  dailyWater,
}

class HealthMetricResult {
  final HealthMetricType type;
  final String title;
  final String shortTitle;
  final String formattedValue;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String formula;
  final String calculationBreakdown;
  final String referenceTitle;
  final String referenceUrl;
  final bool hasAllInputs;

  const HealthMetricResult({
    required this.type,
    required this.title,
    required this.shortTitle,
    required this.formattedValue,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.formula,
    required this.calculationBreakdown,
    required this.referenceTitle,
    required this.referenceUrl,
    required this.hasAllInputs,
  });
}

class HealthCalculator {
  static double? calculateBmi({
    required double? heightCm,
    required double? weightKg,
  }) {
    if (heightCm == null || weightKg == null || heightCm <= 0 || weightKg <= 0) {
      return null;
    }
    final heightM = heightCm / 100.0;
    return weightKg / (heightM * heightM);
  }

  static String bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  /// Mifflin-St Jeor Equation for Basal Metabolic Rate (kcal/day).
  static double? calculateBmr({
    required double? heightCm,
    required double? weightKg,
    required int? age,
    required String? gender,
  }) {
    if (heightCm == null ||
        weightKg == null ||
        age == null ||
        gender == null ||
        heightCm <= 0 ||
        weightKg <= 0 ||
        age <= 0) {
      return null;
    }
    final normalizedGender = gender.trim().toLowerCase();
    final base = (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * age);
    if (normalizedGender == 'male') {
      return base + 5.0;
    }
    if (normalizedGender == 'female') {
      return base - 161.0;
    }
    return null;
  }

  /// Minimum daily calorie burn (Sedentary TDEE baseline = BMR * 1.2).
  static double? calculateMinDailyBurn({
    required double? heightCm,
    required double? weightKg,
    required int? age,
    required String? gender,
  }) {
    final bmr = calculateBmr(
      heightCm: heightCm,
      weightKg: weightKg,
      age: age,
      gender: gender,
    );
    if (bmr == null) return null;
    return bmr * 1.2;
  }

  /// Daily water intake in liters (35 mL per kg of body weight).
  static double? calculateWaterLiters({required double? weightKg}) {
    if (weightKg == null || weightKg <= 0) return null;
    return weightKg * 0.035;
  }

  static List<HealthMetricResult> computeAll({
    required double? heightCm,
    required double? weightKg,
    required int? age,
    required String? gender,
  }) {
    final bmi = calculateBmi(heightCm: heightCm, weightKg: weightKg);
    final bmr = calculateBmr(
      heightCm: heightCm,
      weightKg: weightKg,
      age: age,
      gender: gender,
    );
    final minBurn = calculateMinDailyBurn(
      heightCm: heightCm,
      weightKg: weightKg,
      age: age,
      gender: gender,
    );
    final waterLiters = calculateWaterLiters(weightKg: weightKg);

    final bmiBreakdown = bmi != null
        ? 'Weight: ${weightKg!.toStringAsFixed(1)} kg\n'
            'Height: ${(heightCm! / 100).toStringAsFixed(2)} m\n'
            'BMI = ${weightKg.toStringAsFixed(1)} / (${(heightCm / 100).toStringAsFixed(2)})² = ${bmi.toStringAsFixed(1)} (${bmiCategory(bmi)})'
        : 'Enter your height and weight in your profile to calculate BMI.';

    final isMale = gender?.trim().toLowerCase() == 'male';
    final genderConstant = isMale ? '+ 5' : '- 161';
    final bmrBreakdown = bmr != null
        ? 'Gender: $gender ($genderConstant)\n'
            'BMR = (10 × ${weightKg!.toStringAsFixed(1)}) + (6.25 × ${heightCm!.toStringAsFixed(0)}) - (5 × $age) $genderConstant\n'
            '= ${bmr.round()} kcal/day'
        : 'Enter your height, weight, age, and gender in your profile to calculate BMR.';

    final burnBreakdown = minBurn != null && bmr != null
        ? 'BMR: ${bmr.round()} kcal/day\n'
            'Sedentary PAL factor: 1.2\n'
            'Min. Daily Burn = ${bmr.round()} × 1.2 = ${minBurn.round()} kcal/day\n'
            '(Includes ${(minBurn - bmr).round()} kcal/day of basic daily movement above BMR)'
        : 'Enter your height, weight, age, and gender in your profile to calculate daily calorie burn.';

    final waterMl = waterLiters != null ? (waterLiters * 1000).round() : null;
    final waterBreakdown = waterLiters != null
        ? 'Weight: ${weightKg!.toStringAsFixed(1)} kg\n'
            'Water = ${weightKg.toStringAsFixed(1)} × 35 mL = $waterMl mL (${waterLiters.toStringAsFixed(2)} L/day)'
        : 'Enter your weight in your profile to calculate daily water intake.';

    return [
      HealthMetricResult(
        type: HealthMetricType.bmi,
        title: 'Body Mass Index (BMI)',
        shortTitle: 'BMI',
        formattedValue: bmi != null ? bmi.toStringAsFixed(1) : '—',
        subtitle: bmi != null ? bmiCategory(bmi) : 'Set height & weight',
        icon: Icons.monitor_weight_outlined,
        accentColor: Colors.teal,
        formula: 'BMI = weight (kg) ÷ [height (m)]²',
        calculationBreakdown: bmiBreakdown,
        referenceTitle: 'CDC — About Adult BMI',
        referenceUrl: 'https://www.cdc.gov/bmi/about/index.html',
        hasAllInputs: bmi != null,
      ),
      HealthMetricResult(
        type: HealthMetricType.minCaloriesNeeded,
        title: 'Minimum Calories Needed',
        shortTitle: 'Min. Calories Needed',
        formattedValue: bmr != null ? '${bmr.round()} kcal' : '—',
        subtitle: bmr != null ? 'BMR / day (at rest)' : 'Complete profile',
        icon: Icons.restaurant_outlined,
        accentColor: Colors.orange,
        formula:
            'Mifflin-St Jeor Equation:\n'
            'Male: (10 × kg) + (6.25 × cm) − (5 × age) + 5\n'
            'Female: (10 × kg) + (6.25 × cm) − (5 × age) − 161',
        calculationBreakdown: bmrBreakdown,
        referenceTitle: 'PubMed — Mifflin-St Jeor BMR Equation',
        referenceUrl: 'https://pubmed.ncbi.nlm.nih.gov/2305711/',
        hasAllInputs: bmr != null,
      ),
      HealthMetricResult(
        type: HealthMetricType.minCaloriesToBurn,
        title: 'Min. Daily Calories to Burn',
        shortTitle: 'Min. Daily Burn',
        formattedValue: minBurn != null ? '${minBurn.round()} kcal' : '—',
        subtitle: minBurn != null ? 'Sedentary TDEE / day' : 'Complete profile',
        icon: Icons.local_fire_department_outlined,
        accentColor: Colors.deepOrange,
        formula:
            'Minimum Daily Burn (Sedentary TDEE) = BMR × 1.2\n'
            '(1.2 is the baseline Physical Activity Level factor)',
        calculationBreakdown: burnBreakdown,
        referenceTitle: 'FAO/WHO — Human Energy Requirements (PAL)',
        referenceUrl: 'https://www.fao.org/4/y5686e/y5686e07.htm',
        hasAllInputs: minBurn != null,
      ),
      HealthMetricResult(
        type: HealthMetricType.dailyWater,
        title: 'Daily Water Intake',
        shortTitle: 'Water',
        formattedValue:
            waterLiters != null ? '${waterLiters.toStringAsFixed(2)} L' : '—',
        subtitle: waterMl != null ? '$waterMl mL / day' : 'Set weight',
        icon: Icons.water_drop_outlined,
        accentColor: Colors.blue,
        formula:
            'Daily Water (mL) = weight (kg) × 35 mL\n'
            'Daily Water (L) = weight (kg) × 0.035 L',
        calculationBreakdown: waterBreakdown,
        referenceTitle: 'National Academies — Dietary Reference Intakes for Water',
        referenceUrl: 'https://nap.nationalacademies.org/read/10925/chapter/6',
        hasAllInputs: waterLiters != null,
      ),
    ];
  }
}

