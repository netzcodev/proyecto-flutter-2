import 'package:cars_app/features/services/domain/domain.dart';
import 'package:cars_app/features/services/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceProvider = StateNotifierProvider.autoDispose
    .family<ServiceNotifier, ServiceState, List<int>>((ref, serviceId) {
  final servicesRepository = ref.watch(servicesRepositoryProvider);
  return ServiceNotifier(
    servicesRepository: servicesRepository,
    serviceId: serviceId.first,
    scheduleId: serviceId.last,
  );
});

class ServiceNotifier extends StateNotifier<ServiceState> {
  final ServicesRepository servicesRepository;

  ServiceNotifier({
    required this.servicesRepository,
    required int serviceId,
    required int scheduleId,
  }) : super(ServiceState(id: serviceId, scheduleId: scheduleId)) {
    loadService();
  }

  Service _newEmptyService() {
    return Service(
      id: 0,
      name: '',
      serviceTypeId: 1,
      description: '',
      duration: 0,
      currentDate: DateTime.now().toString(),
      comingDate: _calcularFecha().toString(),
      scheduleId: state.scheduleId,
    );
  }

  Future<void> loadService() async {
    try {
      if (state.id == 0) {
        state = state.copyWith(
          isLoading: false,
          service: _newEmptyService(),
          id: 0,
        );
        return;
      }

      final service = await servicesRepository.getServiceById(state.id!);

      state = state.copyWith(
        isLoading: false,
        service: service,
      );
    } catch (e) {
      print(e);
    }
  }
}

class ServiceState {
  final int? id;
  final int? scheduleId;
  final Service? service;
  final bool isLoading;
  final bool isSaving;

  ServiceState({
    this.id,
    this.scheduleId,
    this.service,
    this.isLoading = true,
    this.isSaving = false,
  });

  ServiceState copyWith({
    int? id,
    int? scheduleId,
    Service? service,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ServiceState(
        id: id ?? this.id,
        scheduleId: scheduleId ?? this.scheduleId,
        service: service ?? this.service,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}

DateTime _calcularFecha() {
  DateTime currentDate = DateTime.now();
  DateTime restultDate = currentDate.add(const Duration(days: 30 * 6));

  if (restultDate.weekday == DateTime.sunday) {
    restultDate = restultDate.add(const Duration(days: 1));
  }

  return restultDate;
}
