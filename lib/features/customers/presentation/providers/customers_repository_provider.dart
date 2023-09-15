import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/customers/domain/domain.dart';
import 'package:cars_app/features/customers/infraestructure/infraestructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customersRepositoryProvider = Provider<CustomersRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final customersRepository = CustomersRepositoryImpl(
    datasource: CustomersDatasourceImpl(accessToken: accessToken),
  );

  return customersRepository;
});
