import 'package:cars_app/config/constants/environment.dart';
import 'package:cars_app/features/auth/domain/domain.dart';
import 'package:cars_app/features/auth/infraestructure/infraestructure.dart';
import 'package:cars_app/features/users/users.dart';
import 'package:dio/dio.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    ),
  );

  @override
  Future<User> chechAuthStatus(String token) {
    // TODO: implement chechAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'username': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw WrongCredential();
      if (e.type == DioExceptionType.connectionTimeout) throw ConnetionTimeOut();
      throw CustomError('Someting wring happend ${e.message}', 1);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
