import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vortex/src/feature/splash_screen/domain/SplashUseCase.dart';
import 'package:vortex/src/feature/splash_screen/presentation/bloc/SplashBloc.dart';
import '../../../../core/constants/image_strings.dart';
import '../../../../core/constants/size.dart';
import '../../../../core/constants/strings.dart';
import '../../../welcome_screen/presentation/screen/welcome_screen.dart';
import '../Bloc/SplashState.dart';
import '../bloc/SplashEvent.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(splashUseCase: Splashusecase())..add(StartSplashAnimation()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
          }
        },
        child: Scaffold(
          body: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              double opacity = 0.0;
              bool animated = false;

              if (state is SplashAnimating) {
                opacity = state.opacity;
                animated = state.animated;
              }

              return AnimatedOpacity(
                duration: const Duration(seconds: 3),
                opacity: opacity,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(tWelcomeScreenImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 3000),
                          top: animated ? 60 : -300,
                          left: animated ? tDefaultSize : -30,
                          right: animated ? tDefaultSize : -30,
                          child: Image(
                            image: AssetImage(tWelcomeLogo),
                            width: 300,
                            height: 300,
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 3000),
                          bottom: animated ? 300 : -50,
                          left: animated ? tDefaultSize : -30,
                          right: animated ? tDefaultSize : -30,
                          child: Column(
                            children: [
                              Text(
                                tWelcomeTitle,
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}