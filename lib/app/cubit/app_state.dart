part of 'app_cubit.dart';

enum Language { en, zh }

@immutable
class AppState extends Equatable {
  final User user;
  final ThemeMode themeMode;
  final Language language;

  const AppState({
    this.user = const User.empty(),
    this.themeMode = ThemeMode.system,
    this.language = Language.en,
  });

  AppState copyWith({
    User? user,
    ThemeMode? themeMode,
    Language? language,
  }) {
    return AppState(
      user: user ?? this.user,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [user, themeMode, language];
}
