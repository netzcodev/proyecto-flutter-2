import 'package:cars_app/features/users/users.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password, String firebaseToken);
  Future<User> register(String email, String password, String fullName);
  Future<User> checkAuthStatus(String token, String firebaseToken);
}
