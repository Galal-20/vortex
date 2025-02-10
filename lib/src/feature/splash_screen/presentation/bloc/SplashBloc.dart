import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vortex/src/feature/splash_screen/domain/SplashUseCase.dart';
import 'package:vortex/src/feature/splash_screen/presentation/bloc/SplashState.dart';
import 'package:vortex/src/feature/splash_screen/presentation/bloc/SplashEvent.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final Splashusecase splashUseCase;

  SplashBloc({required this.splashUseCase}) : super(SplashInitial()) {
    on<StartSplashAnimation>(_onStartAnimation);
  }

  Future<void> _onStartAnimation(
      StartSplashAnimation event, Emitter<SplashState> emit) async {
    await Future.delayed(const Duration(milliseconds: 600));
    emit(SplashAnimating(opacity: 1.0, animated: true));

    await splashUseCase.execute();
    emit(SplashFadingOut());

    await Future.delayed(const Duration(milliseconds: 1000));
    emit(SplashCompleted());
  }
}

