import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final servicesRepository = ServicesRepositoryImpl(
    datasource: ServicesDatasourceImpl(accessToken: accessToken),
  );

  return servicesRepository;
});
