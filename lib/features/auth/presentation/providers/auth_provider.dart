import 'package:cars_app/features/auth/domain/domain.dart';
import 'package:cars_app/features/auth/infraestructure/infraestructure.dart';
import 'package:cars_app/features/users/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  chenking,
  authenticated,
  notAuthenticated,
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(
    authRepository: authRepository,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({
    required this.authRepository,
  }) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(error: e.message);
    } catch (e) {
      logout(error: 'Algo salió mal... Error no controlado');
    }
  }

  void registerUser(String email, String password, String fulName) async {}
  void checkAuthStatus() async {}

  void _setLoggedUser(User user) {
    // TODO: necesito guardar el token en el dispositivo.
    state = state.copyWith(
      user: user,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout({String? error}) async {
    // TODO: limpiar el token
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: error,
    );
  }
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.chenking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
