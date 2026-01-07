import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:temple_app/services/storage_service.dart';
import 'package:temple_app/services/theme_service.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StorageService _storageService;

  ThemeBloc({required StorageService storageService})
      : _storageService = storageService,
        super(ThemeState.initial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // Load persisted theme mode
    final prefs = await _storageService.getPreferences();
    final savedThemeMode = prefs.getString('theme_mode') ?? 'system';

    ThemeModeType themeMode = ThemeModeType.system;
    try {
      themeMode = ThemeModeType.values.firstWhere(
        (e) => e.toString().split('.').last == savedThemeMode,
        orElse: () => ThemeModeType.system,
      );
    } catch (e) {
      themeMode = ThemeModeType.system;
    }

    emit(
      state.copyWith(
        themeMode: themeMode,
        isLoading: false,
      ),
    );
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<ThemeState> emit,
  ) async {
    if (event.themeMode == state.themeMode) return;

    // Save to storage
    final prefs = await _storageService.getPreferences();
    await prefs.setString('theme_mode', event.themeMode.toString().split('.').last);

    emit(
      state.copyWith(
        themeMode: event.themeMode,
      ),
    );
  }
}