part of 'splashscreen_bloc.dart';

class SplashScreenState{
  final bool imageMove;
  final double opacity;

  SplashScreenState({required this.imageMove, required this.opacity});

  SplashScreenState copyWith({bool? imageMove, double? opacity}){
    return SplashScreenState(
      imageMove: imageMove ?? this.imageMove, 
      opacity: opacity ?? this.opacity
    );
  }

}

class Navigate extends SplashScreenState {
  final String routeName;

  Navigate({
    required bool imageMove,
    required double opacity,
    required this.routeName,
  }) : super(imageMove: imageMove, opacity: opacity);
}


// abstract class SplashScreenState {}

// class SplashScreenSuccessState extends SplashScreenState{
//   final bool imageMove;
//   final double opacity;

//   SplashScreenSuccessState({required this.imageMove, required this.opacity});

//   SplashScreenSuccessState copyWith({bool? imageMove, double? opacity}){
//     return SplashScreenSuccessState(
//       imageMove: imageMove ?? this.imageMove, 
//       opacity: opacity ?? this.opacity
//     );
//   }

// }

// class SplashScreenNavigateState extends SplashScreenState{}
