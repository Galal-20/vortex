

abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String password;

  SignUpRequested({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}

class AutoLoginRequested extends AuthEvent {} // ✅ Move this here