import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vortex/src/feature/splash_screen/domain/SplashUseCase.dart';
import 'package:vortex/src/feature/splash_screen/presentation/bloc/SplashBloc.dart';
import 'package:vortex/src/feature/splash_screen/presentation/bloc/SplashState.dart';
import '../../../../core/constants/image_strings.dart';
import '../../../../core/constants/size.dart';
import '../../../../core/constants/strings.dart';
import '../../../home/presentation/screen/HomeScreen.dart';
import '../../../welcome_screen/presentation/screen/welcome_screen.dart';
import '../bloc/SplashEvent.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  Future<bool> _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(splashUseCase: Splashusecase())
        ..add(StartSplashAnimation()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) async {
          if (state is SplashFadingOut) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                isLoggedIn ? const Homescreen() : const WelcomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 1000),
              ),
            );
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
              } else if (state is SplashFadingOut) {
                opacity = 0.0;
              }

              return AnimatedOpacity(
                duration: const Duration(seconds: 1),
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