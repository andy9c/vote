part of 'vote_cubit.dart';

class VoteState extends Equatable {
  final List<StudentState> candidateMap;

  const VoteState({
    this.candidateMap = const [],
  });

  @override
  List<Object> get props => [candidateMap];

  VoteState copyWith({
    List<StudentState>? candidateMap,
  }) {
    return VoteState(
      candidateMap: candidateMap ?? this.candidateMap,
    );
  }

  static Map<String, dynamic> toMap(VoteState state) {
    return {
      'candidateMap':
          state.candidateMap.map((e) => StudentState.toMap(e)).toList(),
    };
  }

  factory VoteState.fromMap(Map<String, dynamic> map) {
    return const VoteState().copyWith(
      candidateMap: (map['candidateMap'] as List<dynamic>)
          .map((e) => StudentState.fromMap(e))
          .toList(),
    );
  }

  String toJson(VoteState state) => json.encode(toMap(state));

  factory VoteState.fromJson(String source) =>
      VoteState.fromMap(json.decode(source));

  @override
  String toString() => 'VoteState(candidateMap: $candidateMap)';
}
