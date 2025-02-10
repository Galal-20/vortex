

import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashAnimating extends SplashState {
  final double opacity;
  final bool animated;

  SplashAnimating({required this.opacity, required this.animated});

  @override
  List<Object> get props => [opacity, animated];
}

class SplashCompleted extends SplashState {}