import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tools/tools.dart';

part 'app_state.dart';

class AppCubit extends HydratedCubit<AppState> {
  AppCubit() : super(const AppState());

  void updateUser(User user) {
    emit(state.copyWith(user: user));
  }

  void setTheme(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
  }

  void setLanguage(Language language) {
    emit(state.copyWith(language: language));
  }

  @override
  AppState? fromJson(Json json) {
    return AppState(
      user: User.fromJson(json['user']),
      language: Language.values.byName(json['language']),
      themeMode: ThemeMode.values.byName(json['themeMode']),
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'user': state.user.toJson(),
      'language': state.language.name,
      'themeMode': state.themeMode.name,
    };
  }
}
