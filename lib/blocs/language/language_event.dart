part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LoadLanguage extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final String languageName;

  const ChangeLanguage(this.languageName);

  @override
  List<Object> get props => [languageName];
}

class TranslateText extends LanguageEvent {
  final String text;

  const TranslateText(this.text);

  @override
  List<Object> get props => [text];
}
