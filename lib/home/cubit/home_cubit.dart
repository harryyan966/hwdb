import 'package:bloc/bloc.dart';
import 'package:tools/tools.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(int tabIndex) {
    emit(state.copyWith(tabIndex: tabIndex));
  }
}
