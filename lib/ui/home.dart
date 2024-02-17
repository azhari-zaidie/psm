import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psm_v2/constant/storage.dart';
import 'package:psm_v2/localization/app_language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  final GetPref getPref = GetPref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helloWorld),
      ),
      body: Center(
        child: LanguageChangeButton(),
      )
    );
  }
}

class LanguageChangeButton extends StatelessWidget {
  final getPref = GetPref();
  @override
  Widget build(BuildContext context) {
    final languageBloc = BlocProvider.of<LanguageBloc>(context);

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            // Example: Switch to Malay if the current locale is English, and vice versa
            Locale newLocale = state.appLocale.languageCode == 'en' ? Locale('ms') : Locale('en');
            languageBloc.add(ChangeLanguage(newLocale));
          },
          child: Text(
            state.appLocale.languageCode == 'en' ? 'Switch to Malay' : 'Switch to English',
          ),
        );
      },
    );
  }

}

