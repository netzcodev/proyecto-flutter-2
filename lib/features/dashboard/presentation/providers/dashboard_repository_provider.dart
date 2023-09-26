import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/dashboard/domain/domain.dart';
import 'package:cars_app/features/dashboard/infraestructure/datasoruces/dashboard_datasource_impl.dart';
import 'package:cars_app/features/dashboard/infraestructure/repositories/dashboard_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final dashboardRepository = DashboardRepositoryImpl(
    datasource: DashboardDatasourceImpl(accessToken: accessToken),
  );

  return dashboardRepository;
});
