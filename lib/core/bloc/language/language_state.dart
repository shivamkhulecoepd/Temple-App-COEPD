import 'package:equatable/equatable.dart';
import '../../models/translation_model.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final LanguageModel selectedLanguage;
  final List<LanguageModel> availableLanguages;

  const LanguageLoaded({
    required this.selectedLanguage,
    required this.availableLanguages,
  });

  @override
  List<Object?> get props => [selectedLanguage, availableLanguages];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError({required this.message});

  @override
  List<Object?> get props => [message];
}