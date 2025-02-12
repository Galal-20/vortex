abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String? displayName;
  Authenticated({this.displayName});
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}