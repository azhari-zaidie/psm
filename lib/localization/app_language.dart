import 'dart:async';

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

class ChangeLanguageState extends  LanguageState{
  final Locale appLocale;

  ChangeLanguageState({required this.appLocale}) : super(appLocale);
}


// Define BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final Locale locale; // Your constant widget instance
  final GetPref getPref;

  LanguageBloc(this.locale, this.getPref) : super(LanguageState(locale)) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<FetchLocale>(_onFetchLocale);
  }

  FutureOr<void> _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    await getPref.secure.write(key: 'language_code', value: event.locale.languageCode);
    emit(LanguageState(event.locale));
  }

  FutureOr<void> _onFetchLocale(FetchLocale event, Emitter<LanguageState> emit) async {
    var appLocale = await getPref.secure.read(key: 'language_code') ?? null;

    if(appLocale == null){
      await getPref.secure.write(key: 'language_code', value: 'en');
      emit(LanguageState(Locale('en')));
    }else{
      emit(LanguageState(Locale(appLocale)));
    }
  }

  
}