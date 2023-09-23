import 'package:cars_app/features/services/domain/domain.dart';
import 'package:cars_app/features/services/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final servicesProvider =
    StateNotifierProvider<ServicesNotifier, ServicesState>((ref) {
  final servicesRepository = ref.watch(servicesRepositoryProvider);

  return ServicesNotifier(servicesRepository: servicesRepository);
});

class ServicesNotifier extends StateNotifier<ServicesState> {
  final ServicesRepository servicesRepository;

  ServicesNotifier({
    required this.servicesRepository,
  }) : super(ServicesState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateServices(Map<String, dynamic> serviceLike) async {
    try {
      final service =
          await servicesRepository.createUpdateServices(serviceLike);
      final isServiceInList =
          state.services.any((element) => element.id == service.id);

      if (!isServiceInList) {
        state = state.copyWith(
          services: [...state.services, service],
        );
        return true;
      }

      state = state.copyWith(
        services: state.services
            .map((element) => (element.id == service.id) ? service : element)
            .toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteService(int id) async {
    try {
      final service = await servicesRepository.deleteService(id);
      final isPersonInList = state.services
          .any((element) => element.id == int.parse(service['id']));

      if (isPersonInList) {
        state.services
            .removeWhere((element) => element.id == int.parse(service['id']));
        state = state.copyWith(services: List<Service>.from(state.services));
        return true;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(
      isLoading: true,
    );

    final services = await servicesRepository.getServicesByPage(
        limit: state.limit, offset: state.offset, scheduleId: state.scheduleId);

    if (services.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      services: [...state.services, ...services],
    );
  }
}

class ServicesState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final int scheduleId;
  final List<Service> services;

  ServicesState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.scheduleId = 0,
    this.isLoading = false,
    this.services = const [],
  });

  ServicesState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    int? scheduleId,
    bool? isLoading,
    List<Service>? services,
  }) =>
      ServicesState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        services: services ?? this.services,
        scheduleId: scheduleId ?? this.scheduleId,
      );
}
