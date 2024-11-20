part of 'student_cubit.dart';

class StudentState extends Equatable {
  final String name;
  final String logo;
  final bool forSPL;
  final bool isMale;
  final bool hover;
  final bool click;
  final int count;

  const StudentState({
    this.name = "",
    this.logo = "",
    this.forSPL = false,
    this.isMale = false,
    this.hover = false,
    this.click = false,
    this.count = 0,
  });

  @override
  List<Object> get props {
    return [
      name,
      logo,
      forSPL,
      isMale,
      hover,
      click,
      count,
    ];
  }

  StudentState copyWith({
    String? name,
    String? logo,
    bool? forSPL,
    bool? isMale,
    bool? hover,
    bool? click,
    int? count,
  }) {
    return StudentState(
      name: name ?? this.name,
      logo: logo ?? this.logo,
      forSPL: forSPL ?? this.forSPL,
      isMale: isMale ?? this.isMale,
      hover: hover ?? this.hover,
      click: click ?? this.click,
      count: count ?? this.count,
    );
  }

  static Map<String, dynamic> toMap(StudentState state) {
    return {
      'name': state.name,
      'logo': state.logo,
      'forSPL': state.forSPL,
      'isMale': state.isMale,
      'hover': state.hover,
      'click': state.click,
      'count': state.count,
    };
  }

  factory StudentState.fromMap(Map<String, dynamic> map) {
    return const StudentState().copyWith(
      name: map['name'],
      logo: map['logo'],
      forSPL: map['forSPL'],
      isMale: map['isMale'],
      hover: map['hover'],
      click: map['click'],
      count: map['count'],
    );
  }

  String toJson(StudentState state) => json.encode(toMap(state));

  factory StudentState.fromJson(String source) =>
      StudentState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudentState(name: $name, logo: $logo, forSPL: $forSPL, isMale: $isMale, hover: $hover, click: $click, count: $count)';
  }

  @override
  bool get stringify => true;
}
