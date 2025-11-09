import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  Future<UserModel> login(String email, String password) async {
    final data = await authService.login(email, password);
    return UserModel.fromJson(data);
  }

  Future<UserModel> signup(String name, String email, String password) async {
    final data = await authService.signup(name, email, password);
    return UserModel.fromJson(data);
  }

  Future<void> logout() async {
    await authService.clearToken();
  }
}
