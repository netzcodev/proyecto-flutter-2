import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:cars_app/features/schedules/infraestructure/infraestructure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schedulesRepositoryProvider = Provider<SchedulesRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final schedulesRepository = SchedulesRepositoryImpl(
    datasource: SchedulesDatasourceImpl(accessToken: accessToken),
  );

  return schedulesRepository;
});
