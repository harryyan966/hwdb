import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'student_score_state.dart';

class StudentScoreCubit extends Cubit<StudentScoreState> {
  StudentScoreCubit() : super(StudentScoreInitial());
}
