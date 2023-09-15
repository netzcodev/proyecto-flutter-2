import 'package:cars_app/features/customers/customers.dart';
import 'package:cars_app/features/vehicles/vehicles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehiclesProvider =
    StateNotifierProvider<VehiclesNotifier, VehiclesState>((ref) {
  final vehiclesRepository = ref.watch(vehicleRepositoryProvider);
  ref.watch(customersProvider.notifier).loadNextPage();
  return VehiclesNotifier(vehiclesRepository: vehiclesRepository);
});

class VehiclesNotifier extends StateNotifier<VehiclesState> {
  final VehiclesRepository vehiclesRepository;

  VehiclesNotifier({
    required this.vehiclesRepository,
  }) : super(VehiclesState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateVehicles(Map<String, dynamic> vehicleLike) async {
    try {
      final vehicle =
          await vehiclesRepository.createUpdateVehicles(vehicleLike);
      final isVehicleInList =
          state.vehicles.any((element) => element.id == vehicle.id);

      if (!isVehicleInList) {
        state = state.copyWith(
          vehicles: [...state.vehicles, vehicle],
        );
        return true;
      }

      state = state.copyWith(
        vehicles: state.vehicles
            .map((element) => (element.id == vehicle.id) ? vehicle : element)
            .toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteVehicle(int id) async {
    try {
      final vehicle = await vehiclesRepository.deleteVehicle(id);
      final isPersonInList = state.vehicles
          .any((element) => element.id == int.parse(vehicle['id']));

      if (isPersonInList) {
        state.vehicles
            .removeWhere((element) => element.id == int.parse(vehicle['id']));
        state = state.copyWith(vehicles: List<Vehicle>.from(state.vehicles));
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

    final vehicles = await vehiclesRepository.getVehiclesByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (vehicles.isEmpty) {
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
      vehicles: [...state.vehicles, ...vehicles],
    );
  }
}

class VehiclesState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Vehicle> vehicles;

  VehiclesState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.vehicles = const [],
  });

  VehiclesState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Vehicle>? vehicles,
  }) =>
      VehiclesState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        vehicles: vehicles ?? this.vehicles,
      );
}
