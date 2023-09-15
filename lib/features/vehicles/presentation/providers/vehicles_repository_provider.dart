import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/vehicles/domain/domain.dart';
import 'package:cars_app/features/vehicles/infraestructure/infraestructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleRepositoryProvider = Provider<VehiclesRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final vehiclesRepository = VehiclesRepositoryImpl(
    datasource: VehiclesDatasourceImpl(accessToken: accessToken),
  );

  return vehiclesRepository;
});
