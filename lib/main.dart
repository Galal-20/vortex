import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vortex/firebase_options.dart';
import 'package:vortex/src/core/utils/theme/theme.dart';
import 'package:vortex/src/feature/authentication/data/AuthRepository.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthBloc.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthEvent.dart';
import 'package:vortex/src/feature/home/data/WeatherRepositoryImpl.dart';
import 'package:vortex/src/feature/home/domain/UseCase/GetWeatherUseCase.dart';
import 'package:vortex/src/feature/home/presentation/bloc/WeatherBloc.dart';
import 'package:vortex/src/feature/splash_screen/domain/SplashUseCase.dart';
import 'package:vortex/src/feature/splash_screen/presentation/bloc/SplashBloc.dart';
import 'package:vortex/src/feature/splash_screen/presentation/screen/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

  runApp(
    MultiBlocProvider(
      providers: [
        RepositoryProvider(
          create: (context) => WeatherRepositoryImpl(), // ✅ Use the concrete implementation
        ),
        BlocProvider(
          create: (context) {
            final authBloc = AuthBloc(authRepository: AuthRepository());
            if (isLoggedIn) {
              authBloc.add(AutoLoginRequested());
            }
            return authBloc;
          },
        ),
        BlocProvider(
          create: (context) => WeatherBloc(GetWeatherUseCase(context.read<WeatherRepositoryImpl>())), // ✅ Use WeatherRepositoryImpl
        ),
        BlocProvider(
          create: (context) => SplashBloc(splashUseCase: Splashusecase()),
        ),
      ],
      child: MyApp(),
    ),
  );
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

