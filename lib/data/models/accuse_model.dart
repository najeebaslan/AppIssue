class AccusedModel {
  int? id;
  String? name;
  String? note;
  String? date;
  int? phoneNu;
  String? issueNumber;
  String? accused;
  int? isCompleted;
  int? firstAlarm;
  int? nextAlarm;
  int? thirdAlert;
  AccusedModel({
    this.id,
    this.name,
    this.note,
    this.isCompleted,
    this.date,
    this.phoneNu,
    this.issueNumber,
    this.accused,
    this.firstAlarm,
    this.nextAlarm,
    this.thirdAlert,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'note': note,
      'date': date,
      'phoneNu': phoneNu,
      'issueNumber': issueNumber,
      'accused': accused,
      'isCompleted': isCompleted,
      'firstAlarm': firstAlarm,
      'nextAlarm': nextAlarm,
      'thirdAlert': thirdAlert,
    };
  }

  factory AccusedModel.fromMap(Map<String, dynamic> map) {
    return AccusedModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      phoneNu: map['phoneNu'] != null ? map['phoneNu'] as int : null,
      issueNumber: map['issueNumber'] != null ? map['issueNumber'] as String : null,
      accused: map['accused'] != null ? map['accused'] as String : null,
      isCompleted: map['isCompleted'] != null ? map['isCompleted'] as int : null,
      firstAlarm: map['firstAlarm'] != null ? map['firstAlarm'] as int : null,
      nextAlarm: map['nextAlarm'] != null ? map['nextAlarm'] as int : null,
      thirdAlert: map['thirdAlert'] != null ? map['thirdAlert'] as int : null,
    );
  }

  AccusedModel copyWith({
    int? id,
    String? name,
    String? note,
    String? date,
    int? phoneNu,
    String? issueNumber,
    String? accused,
    int? isCompleted,
    int? firstAlarm,
    int? nextAlarm,
    int? thirdAlert,
  }) {
    return AccusedModel(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      date: date ?? this.date,
      phoneNu: phoneNu ?? this.phoneNu,
      issueNumber: issueNumber ?? this.issueNumber,
      accused: accused ?? this.accused,
      isCompleted: isCompleted ?? this.isCompleted,
      firstAlarm: firstAlarm ?? this.firstAlarm,
      nextAlarm: nextAlarm ?? this.nextAlarm,
      thirdAlert: thirdAlert ?? this.thirdAlert,
    );
  }

  AccusedModel accuseCompleted() {
    return AccusedModel(
      id: id,
      name: name,
      note: note,
      date: date,
      phoneNu: phoneNu,
      issueNumber: issueNumber,
      accused: accused,
      isCompleted: 1,
      firstAlarm: 1,
      nextAlarm: 1,
      thirdAlert: 1,
    );
  }

  AccusedModel reActiveAccuse() {
    return AccusedModel(
      id: id,
      name: name,
      note: note,
      date: date,
      phoneNu: phoneNu,
      issueNumber: issueNumber,
      accused: accused,
      isCompleted: 0,
      firstAlarm: 0,
      nextAlarm: 0,
      thirdAlert: 0,
    );
  }

  @override
  bool operator ==(covariant AccusedModel other) {
    if (identical(this, other)) return true;
    return (other.issueNumber == issueNumber);
  }

  @override
  int get hashCode => issueNumber.hashCode;

  /// remove duplicated issueNumber
  static List<AccusedModel> removeDuplicates(List<AccusedModel> list) {
    return list.toSet().toList();
  }
}
