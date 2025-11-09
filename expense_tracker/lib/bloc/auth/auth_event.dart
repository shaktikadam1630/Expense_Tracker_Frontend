abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested(this.email, this.password);
}

class AuthSignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignupRequested(this.name, this.email, this.password);
}

class AuthLogoutRequested extends AuthEvent {}
