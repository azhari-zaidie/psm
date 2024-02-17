import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:psm_v2/constant/storage.dart';

// Define events
abstract class LanguageEvent {}

class FetchLocale extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;

  ChangeLanguage(this.locale);
}

// Define state
class LanguageState {
  final Locale appLocale;
  LanguageState(this.appLocale);
}

// Define BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final GetPref getPref; // Your constant widget instance

  LanguageBloc(this.getPref) : super(LanguageState(const Locale('ms'))) {
    on<ChangeLanguage>(_onChangeLanguage);
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    final currentState = state;
    if (currentState.appLocale != event.locale) {
      await getPref.secure.write(key: 'language_code', value: event.locale.languageCode);
      emit(LanguageState(event.locale));
    }
  }
}