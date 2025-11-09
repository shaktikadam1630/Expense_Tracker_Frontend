import 'package:expense_tracker/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final AuthService authService;

  AuthBloc(this.repository, this.authService) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.login(event.email, event.password);
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    

    on<AuthSignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user =
            await repository.signup(event.name, event.email, event.password);
        emit(singup (user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await authService.clearToken();
      emit(AuthLoggedOut());
    });
  }
}
