import 'package:cars_app/features/auth/infraestructure/infraestructure.dart';
import 'package:cars_app/features/auth/domain/domain.dart';
import 'package:cars_app/features/users/users.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : _dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> chechAuthStatus(String token) {
    return _dataSource.chechAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return _dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return _dataSource.register(email, password, fullName);
  }
}
