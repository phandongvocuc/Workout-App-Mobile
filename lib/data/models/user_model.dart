class UserModel {
  final int id;
  final String email;
  final String fullName;
  final String? phone;
  final String? fitnessGoal;
  final String? membershipTier;
  final double? heightCm;
  final double? weightKg;
  final int? age;
  final String? gender;
  final String role; // 'ADMIN' or 'USER'
  final bool active;
  final String? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.fitnessGoal,
    this.membershipTier,
    this.heightCm,
    this.weightKg,
    this.age,
    this.gender,
    required this.role,
    this.active = true,
    this.createdAt,
  });

  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'HF';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: (json['email'] as String?) ?? '',
      fullName: (json['fullName'] as String?) ?? 'HydroFit Member',
      phone: json['phone'] as String?,
      fitnessGoal: json['fitnessGoal'] as String?,
      membershipTier: json['membershipTier'] as String?,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      role: (json['role'] as String?) ?? 'USER',
      active: (json['active'] as bool?) ?? true,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'fitnessGoal': fitnessGoal,
      'membershipTier': membershipTier,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'age': age,
      'gender': gender,
      'role': role,
      'active': active,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? fullName,
    String? phone,
    String? fitnessGoal,
    String? membershipTier,
    double? heightCm,
    double? weightKg,
    int? age,
    String? gender,
    String? role,
    bool? active,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      membershipTier: membershipTier ?? this.membershipTier,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

