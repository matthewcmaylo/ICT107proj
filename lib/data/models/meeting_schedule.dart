class MeetingSchedule {
  final String id;
  final String title;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final List<int> repeatDays;
  final String mode;
  final bool isEnabled;
  final int alertMinutesBefore;
  final bool restoreAfter; // new: restore sound after meeting ends

  const MeetingSchedule({
    required this.id,
    required this.title,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.repeatDays,
    required this.mode,
    required this.isEnabled,
    required this.alertMinutesBefore,
    this.restoreAfter = true,
  });

  MeetingSchedule copyWith({
    String? id, String? title,
    int? startHour, int? startMinute,
    int? endHour, int? endMinute,
    List<int>? repeatDays, String? mode,
    bool? isEnabled, int? alertMinutesBefore,
    bool? restoreAfter,
  }) => MeetingSchedule(
    id: id ?? this.id, title: title ?? this.title,
    startHour: startHour ?? this.startHour, startMinute: startMinute ?? this.startMinute,
    endHour: endHour ?? this.endHour, endMinute: endMinute ?? this.endMinute,
    repeatDays: repeatDays ?? List.from(this.repeatDays),
    mode: mode ?? this.mode, isEnabled: isEnabled ?? this.isEnabled,
    alertMinutesBefore: alertMinutesBefore ?? this.alertMinutesBefore,
    restoreAfter: restoreAfter ?? this.restoreAfter,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title,
    'startHour': startHour, 'startMinute': startMinute,
    'endHour': endHour, 'endMinute': endMinute,
    'repeatDays': repeatDays, 'mode': mode,
    'isEnabled': isEnabled, 'alertMinutesBefore': alertMinutesBefore,
    'restoreAfter': restoreAfter,
  };

  factory MeetingSchedule.fromJson(Map<String, dynamic> json) => MeetingSchedule(
    id: json['id'] as String, title: json['title'] as String,
    startHour: json['startHour'] as int, startMinute: json['startMinute'] as int,
    endHour: json['endHour'] as int, endMinute: json['endMinute'] as int,
    repeatDays: List<int>.from(json['repeatDays'] as List),
    mode: json['mode'] as String, isEnabled: json['isEnabled'] as bool,
    alertMinutesBefore: json['alertMinutesBefore'] as int,
    restoreAfter: json['restoreAfter'] as bool? ?? true,
  );
}
