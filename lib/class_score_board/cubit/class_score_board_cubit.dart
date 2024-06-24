import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'class_score_board_state.dart';

class ClassScoreBoardCubit extends Cubit<ClassScoreBoardState> {
  ClassScoreBoardCubit() : super(ClassScoreBoardInitial());
}
