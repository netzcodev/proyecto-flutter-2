import 'package:cars_app/features/users/users.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<User> chechAuthStatus(String token);
}
