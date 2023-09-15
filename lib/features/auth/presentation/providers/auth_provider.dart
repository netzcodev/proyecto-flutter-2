import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/auth/domain/domain.dart';
import 'package:cars_app/features/auth/infraestructure/infraestructure.dart';
import 'package:cars_app/features/shared/infraestructure/services/keyvalue_storage_service.dart';
import 'package:cars_app/features/shared/infraestructure/services/keyvalue_storage_service_impl.dart';
import 'package:cars_app/features/users/users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  chenking,
  authenticated,
  notAuthenticated,
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();
  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(microseconds: 500));
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

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getKeyValue<String>('token');

    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue(
      'token',
      user.token,
    );

    List<MenuItem> appMenuItems = [];

    for (MenuItem item in globalMenuItems) {
      for (var element in user.menu!) {
        if (element.menuName?.toLowerCase() == item.title.toLowerCase()) {
          appMenuItems.add(item);
        }
      }
    }

    state = state.copyWith(
      user: user,
      menus: appMenuItems,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout({String? error}) async {
    await keyValueStorageService.removeKeyValue('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      menus: [],
      errorMessage: error,
    );
  }
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final List<MenuItem>? menus;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.chenking,
    this.user,
    this.menus,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    List<MenuItem>? menus,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        menus: menus ?? this.menus,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
