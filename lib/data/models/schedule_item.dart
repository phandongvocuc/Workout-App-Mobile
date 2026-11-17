class ScheduleItem {
  final int? id;
  final int dayOfWeek; // 1=Mon ... 7=Sun
  final int timeHour; // 0-23
  final int timeMinute; // 0-59
  final String title;
  final String? description;
  final int createdAt;

  const ScheduleItem({
    this.id,
    required this.dayOfWeek,
    required this.timeHour,
    required this.timeMinute,
    required this.title,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'day_of_week': dayOfWeek,
      'time_hour': timeHour,
      'time_minute': timeMinute,
      'title': title,
      'description': description,
      'created_at': createdAt,
    };
  }

  factory ScheduleItem.fromMap(Map<String, dynamic> map) {
    return ScheduleItem(
      id: map['id'] as int?,
      dayOfWeek: map['day_of_week'] as int,
      timeHour: map['time_hour'] as int,
      timeMinute: map['time_minute'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      createdAt: map['created_at'] as int,
    );
  }

  ScheduleItem copyWith({
    int? id,
    int? dayOfWeek,
    int? timeHour,
    int? timeMinute,
    String? title,
    String? description,
    int? createdAt,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      timeHour: timeHour ?? this.timeHour,
      timeMinute: timeMinute ?? this.timeMinute,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get formattedTime {
    final hourStr = timeHour.toString().padLeft(2, '0');
    final minuteStr = timeMinute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  String get dayName {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }
}

