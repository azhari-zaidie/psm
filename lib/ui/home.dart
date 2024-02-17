import 'package:flutter/material.dart';
import 'package:psm_v2/constant/responsive.dart';
import 'package:psm_v2/ui/mobile/introduction/splash_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveWidget(
        largeScreen: SplashScreen(),
        smallScreen: SplashScreen(),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   final GetPref getPref = GetPref();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.helloWorld),
//       ),
//       body: Center(
//         child: LanguageChangeButton(),
//       )
//     );
//   }
// }

// class LanguageChangeButton extends StatelessWidget {
//   final getPref = GetPref();
//   @override
//   Widget build(BuildContext context) {
//     final languageBloc = BlocProvider.of<LanguageBloc>(context);

//     return BlocBuilder<LanguageBloc, LanguageState>(
//       builder: (context, state) {
//         return ElevatedButton(
//           onPressed: () {
//             // Example: Switch to Malay if the current locale is English, and vice versa
//             Locale newLocale = state.appLocale.languageCode == 'en' ? Locale('ms') : Locale('en');
//             languageBloc.add(ChangeLanguage(newLocale));
//           },
//           child: Text(
//             state.appLocale.languageCode == 'en' ? 'Switch to Malay' : 'Switch to English',
//           ),
//         );
//       },
//     );
//   }

// }

