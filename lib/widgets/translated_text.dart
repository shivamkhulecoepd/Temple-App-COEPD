import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/blocs/language/language_bloc.dart';

class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTranslation();
  }

  @override
  void didUpdateWidget(TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _fetchTranslation();
    }
  }

  Future<void> _fetchTranslation() async {
    final bloc = context.read<LanguageBloc>();
    final translated = await bloc.getTranslation(widget.text);
    if (mounted) {
      setState(() {
        _translatedText = translated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listenWhen: (previous, current) =>
          previous.selectedLanguageCode != current.selectedLanguageCode,
      listener: (context, state) {
        _fetchTranslation();
      },
      child: Text(
        _translatedText ?? widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
        overflow: widget.overflow,
        maxLines: widget.maxLines,
      ),
    );
  }
}
