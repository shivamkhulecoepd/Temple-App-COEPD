import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mslgd/models/user_model.dart';
import 'package:mslgd/services/storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final StorageService _storageService;

  AuthBloc({required StorageService storageService})
      : _storageService = storageService,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isLoggedIn = await _storageService.isUserLoggedIn();
      
      if (isLoggedIn) {
        final userDataString = await _storageService.getUserData();
        if (userDataString != null) {
          final user = UserModel.fromStorage(userDataString);
          emit(Authenticated(user));
        } else {
          // Data corrupted, logout
          await _storageService.clearUserData();
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      log('Error checking auth status: $e');
      emit(const Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('https://marakatasrilaxmiganapathi.org/api/devotee_login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobile': event.mobile,
          'password': event.password,
        }),
      );

      log('Login response status: ${response.statusCode}');
      log('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['success'] == true) {
          final user = UserModel.fromJson(json['data'], event.mobile);
          
          // Save to storage
          await _storageService.setUserLoggedIn(true);
          await _storageService.saveUserData(user.toStorageString());
          await _storageService.saveUserToken(user.token);
          
          log('User logged in: ${user.devoteeName} (ID: ${user.devoteeId})');
          emit(Authenticated(user));
        } else {
          emit(AuthFailure(json['message'] ?? 'Login failed'));
        }
      } else {
        emit(AuthFailure('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      log('Login error: $e');
      emit(AuthFailure('Network error: $e'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('https://marakatasrilaxmiganapathi.org/api/devotee_register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': event.name,
          'mobile': event.mobile,
          'password': event.password,
          'confirm_password': event.confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['success'] == true) {
          // Registration successful, but not logged in yet
          emit(const Unauthenticated(
            errorMessage: 'Registered successfully! Please sign in.',
          ));
        } else {
          emit(AuthFailure(json['message'] ?? 'Registration failed'));
        }
      } else {
        emit(AuthFailure('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      log('Registration error: $e');
      emit(AuthFailure('Network error: $e'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _storageService.clearUserData();
      emit(const Unauthenticated());
      log('User logged out successfully');
    } catch (e) {
      log('Logout error: $e');
      // Even if storage fails, we still emit unauthenticated
      emit(const Unauthenticated());
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await _storageService.isUserLoggedIn();
      
      if (isLoggedIn) {
        final userDataString = await _storageService.getUserData();
        if (userDataString != null) {
          final user = UserModel.fromStorage(userDataString);
          emit(Authenticated(user));
        } else {
          await _storageService.clearUserData();
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      log('Error checking auth status: $e');
      emit(const Unauthenticated());
    }
  }
}