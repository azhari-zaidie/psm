import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:psm_v2/bloc/introduction/splash_screen_bloc/splashscreen_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashScreenBloc _bloc = SplashScreenBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.add(SplashScreenEvent.start);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
      bloc: _bloc,
      listener: (context, state) {
        // TODO: implement listener
        if(state is Navigate){
          Navigator.pushNamed(context, state.routeName);
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                height: state.imageMove ? 0 : 250,
                width: 200,
                alignment: state.imageMove ? Alignment.topCenter : Alignment.center,
                curve: Curves.fastOutSlowIn,
                child: Image.asset('images/logo52.png'),
                duration: const Duration(seconds: 5),
              ),
              const SizedBox(height: 20,),
              AnimatedOpacity(
                opacity: state.opacity == 1 ? 0 : 1,
                duration: const Duration(seconds: 5),
                child: Text(AppLocalizations.of(context)!.title1, style: TextStyle(fontSize: 12.sp),),
              )
            ],
          ),
        );
      },
    );
  }
}
