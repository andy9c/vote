import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vote/candidates.dart';
import 'package:vote/cubit/student_cubit.dart';

part 'vote_state.dart';

class VoteCubit extends Cubit<VoteState> with HydratedMixin {
  VoteCubit() : super(const VoteState()) {
    hydrate();
  }

  VoteState getCopy() {
    return VoteState.fromMap(VoteState.toMap(state));
  }

  void toggleHover(int index, bool forSPLParam) {
    VoteState configCopy = getCopy();

    StudentState o = configCopy.candidateMap
        .where((c) => c.forSPL == forSPLParam)
        .elementAt(index);

    bool orgiHover = o.hover;

    StudentState t = configCopy.candidateMap
        .where((c) => c.forSPL == forSPLParam)
        .elementAt(index)
        .copyWith(hover: !orgiHover);

    int realIndex = configCopy.candidateMap.indexOf(o);
    configCopy.candidateMap.removeAt(realIndex);
    configCopy.candidateMap.insert(realIndex, t);

    emit(state.copyWith(candidateMap: configCopy.candidateMap));
  }

  void toggleClick(int index, bool forSPLParam) {
    VoteState configCopy = getCopy();

    StudentState o = configCopy.candidateMap
        .where((c) => c.forSPL == forSPLParam)
        .elementAt(index);

    bool orgiClick = o.click;

    StudentState t = configCopy.candidateMap
        .where((c) => c.forSPL == forSPLParam)
        .elementAt(index)
        .copyWith(click: !orgiClick);

    int realIndex = configCopy.candidateMap.indexOf(o);
    configCopy.candidateMap.removeAt(realIndex);
    configCopy.candidateMap.insert(realIndex, t);

    emit(state.copyWith(candidateMap: configCopy.candidateMap));
  }

  void increaseCount(int index, bool forSPLParam) {
    VoteState configCopy = getCopy();

    int count = configCopy.candidateMap
        .where((c) => c.forSPL == forSPLParam)
        .elementAt(index)
        .count;

    StudentState o = configCopy.candidateMap
        .where((c) => c.forSPL == forSPLParam)
        .elementAt(index);

    StudentState t =
        configCopy.candidateMap.elementAt(index).copyWith(count: count + 1);

    int realIndex = configCopy.candidateMap.indexOf(o);
    configCopy.candidateMap.removeAt(realIndex);
    configCopy.candidateMap.insert(realIndex, t);

    emit(state.copyWith(candidateMap: configCopy.candidateMap));
  }

  void decreaseCount(int index, bool forSPLParam) {
    VoteState configCopy = getCopy();

    int count = configCopy.candidateMap
        .where((c) => c.forSPL == forSPLParam)
        .elementAt(index)
        .count;

    StudentState o = configCopy.candidateMap
        .where((c) => c.forSPL == forSPLParam)
        .elementAt(index);

    StudentState t = configCopy.candidateMap
        .elementAt(index)
        .copyWith(count: count > 0 ? count - 1 : 0);

    int realIndex = configCopy.candidateMap.indexOf(o);
    configCopy.candidateMap.removeAt(realIndex);
    configCopy.candidateMap.insert(realIndex, t);

    emit(state.copyWith(candidateMap: configCopy.candidateMap));
  }

  void reset() {
    VoteState configCopy = getCopy();
    final List<StudentState> studentStateList = candidateList
        .map((candidate) => StudentState(
              name: candidate['name'],
              logo: candidate['logo'],
              forSPL: candidate['forSPL'],
              isMale: candidate['isMale'],
              hover: candidate['hover'],
              click: candidate['click'],
              count: candidate['count'],
            ))
        .toList();

    emit(configCopy.copyWith(candidateMap: studentStateList));
  }

  @override
  VoteState? fromJson(Map<String, dynamic> json) {
    return VoteState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(VoteState state) {
    return VoteState.toMap(state);
  }
}
