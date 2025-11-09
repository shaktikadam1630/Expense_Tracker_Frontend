import '../../data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class singup extends AuthState {
  final UserModel user;
 singup (this.user);
}

class AuthLoggedOut extends AuthState {}
