import 'package:cars_app/features/auth/infraestructure/infraestructure.dart';
import 'package:cars_app/features/auth/domain/domain.dart';
import 'package:cars_app/features/users/users.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : _dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token, String firebaseToken) {
    return _dataSource.checkAuthStatus(token, firebaseToken);
  }

  @override
  Future<User> login(String email, String password, String firebaseToken) {
    return _dataSource.login(email, password, firebaseToken);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return _dataSource.register(email, password, fullName);
  }
}
