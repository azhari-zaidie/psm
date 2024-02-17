import 'package:bloc/bloc.dart';

part 'splashscreen_event.dart';
part 'splashscreen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenState(imageMove: false, opacity: 1.0)) {
    on<SplashScreenEvent>((event, emit) async {
      if (event == SplashScreenEvent.start) {
        emit(state.copyWith(imageMove: true, opacity: state.opacity == 0.0 ? 1 : 0));
        await Future.delayed(Duration(seconds: 5)).then((value) {
          emit(Navigate(imageMove: false, opacity: 0.0, routeName: '/login'));
        });
      }
    });
  }

}
