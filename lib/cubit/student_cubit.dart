import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:convert';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> with HydratedMixin {
  StudentCubit() : super(const StudentState()) {
    hydrate();
  }

  @override
  StudentState? fromJson(Map<String, dynamic> json) {
    return StudentState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(StudentState state) {
    return StudentState.toMap(state);
  }
}
