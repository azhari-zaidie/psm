import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psm_v2/localization/app_language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        print(state);
          return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.helloWorld),
              ),
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Determine the new locale based on the current locale
                    Locale newLocale = state.appLocale.languageCode == 'ms'
                        ? Locale('en')
                        : Locale('ms');

                    print('New language state: ${state.appLocale.languageCode}');
                    print('New language newLocale: ${newLocale.languageCode}');

                    // Get the LanguageBloc instance
                    final languageBloc = BlocProvider.of<LanguageBloc>(context);

                    // Dispatch the ChangeLanguage event with the new locale
                    languageBloc.add(ChangeLanguage(newLocale));
                  },
                  child: Text(
                    state.appLocale.languageCode == 'en'
                        ? 'Switch to Malay'
                        : 'Switch to English',
                  ),
                ),
              ),
            );
      },
    );
  }
}

// class LanguageChangeButton extends StatefulWidget {
//   @override
//   State<LanguageChangeButton> createState() => _LanguageChangeButtonState();
// }

// class _LanguageChangeButtonState extends State<LanguageChangeButton> {
//   LanguageBloc languageBloc = LanguageBloc(GetPref());
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     languageBloc.add(FetchLocale());
//   }
  
  

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LanguageBloc, LanguageState>(
//       builder: (context, state) {
//         return ElevatedButton(
//           onPressed: () {
//             // Example: Switch to Malay if the current locale is English, and vice versa
//             Locale newLocale = state.appLocale.languageCode == 'en' ? Locale('ms') : Locale('en');
//             languageBloc.add(ChangeLanguage(newLocale));
//             print("sini ${state}");
//           },
//           child: Text(
//             state.appLocale.languageCode == 'en' ? 'Switch to Malay' : 'Switch to English',
//           ),
//         );
//       },
//     );
//   }
// }

