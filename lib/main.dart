import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:psm_v2/constant/route.dart';
import 'package:psm_v2/constant/storage.dart';
import 'package:psm_v2/l10n/l10n.dart';
import 'package:psm_v2/localization/app_language.dart';
import 'package:psm_v2/ui/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
Future<void> main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();

    ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

    // AppLanguage

    //IOS
    // Platform.isIOS || Platform.isAndroid ? await FlutterDownloader.initialize(debug: true, ignoreSsl: true) : null; 
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
// arb-dir: lib/l10n
// template-arb-file: app_en.arb
// output-localization-file: app_localizations.dart
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //wrap with bloc provider for main
    return BlocProvider(
      create: (context) => LanguageBloc(GetPref()), //passing get pref as arg
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state){
          return ScreenUtilInit(
            builder: (BuildContext context, child) => MaterialApp(
              title: 'UjiMakro',
              locale: state.appLocale, //change app locale based on state
              supportedLocales: L1on.all,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalMaterialLocalizations.delegate
              ],
              // Define your app's theme, routes, etc.
              // Example:
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              routes: AppRoutes.getRoutes(),
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              // onGenerateRoute: (_){
              //   if(_.arguments == null) {
              //     return MaterialPageRoute(
              //     builder: (context) => null);
              //   }else{
              //     return MaterialPageRoute(
              //     builder: (context) => null);
              //   }
              // },
              builder: (context, widget){
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), 
                  child: widget!
                );
              },
              home: HomeScreen(),
            ),
          );
        },
      )

    );
  }
}

