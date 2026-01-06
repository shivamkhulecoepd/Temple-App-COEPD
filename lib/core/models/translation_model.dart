import 'package:equatable/equatable.dart';

class TranslationModel extends Equatable {
  final String key;
  final String text;
  final String languageCode;
  final DateTime lastUpdated;

  const TranslationModel({
    required this.key,
    required this.text,
    required this.languageCode,
    required this.lastUpdated,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      key: json['key'] as String,
      text: json['text'] as String,
      languageCode: json['languageCode'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'text': text,
      'languageCode': languageCode,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [key, text, languageCode, lastUpdated];
}

class LanguageModel extends Equatable {
  final String name;
  final String code;
  final bool isSelected;

  const LanguageModel({
    required this.name,
    required this.code,
    this.isSelected = false,
  });

  LanguageModel copyWith({
    String? name,
    String? code,
    bool? isSelected,
  }) {
    return LanguageModel(
      name: name ?? this.name,
      code: code ?? this.code,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [name, code, isSelected];
}