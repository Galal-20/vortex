import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vortex/src/core/utils/theme/theme.dart';
import 'package:vortex/src/feature/splash_screen/domain/SplashUseCase.dart';
import 'package:vortex/src/feature/splash_screen/presentation/bloc/SplashBloc.dart';
import 'package:vortex/src/feature/splash_screen/presentation/screen/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(splashUseCase: Splashusecase()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: WeatherTheme.lightTheme,
        darkTheme: WeatherTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: SplashScreen(),
      ),
    );
  }
}

