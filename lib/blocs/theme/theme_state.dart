part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeModeType themeMode;
  final bool isLoading;

  const ThemeState({
    required this.themeMode,
    this.isLoading = false,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: ThemeModeType.system,
    );
  }

  ThemeState copyWith({
    ThemeModeType? themeMode,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [themeMode, isLoading];
}