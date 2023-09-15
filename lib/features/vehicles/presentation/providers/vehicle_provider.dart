import 'package:cars_app/features/vehicles/vehicles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleProvider = StateNotifierProvider.autoDispose
    .family<VehicleNotifier, VehicleState, int>((ref, vehicleId) {
  final vehiclesRepository = ref.watch(vehicleRepositoryProvider);
  return VehicleNotifier(
    vehiclesRepository: vehiclesRepository,
    vehicleId: vehicleId,
  );
});

class VehicleNotifier extends StateNotifier<VehicleState> {
  final VehiclesRepository vehiclesRepository;

  VehicleNotifier({
    required this.vehiclesRepository,
    required int vehicleId,
  }) : super(VehicleState(id: vehicleId)) {
    loadVehicle();
  }

  Vehicle _newEmptyVehicle() {
    return Vehicle(
      id: 0,
      name: '',
      manufacturer: '',
      model: '',
      fuel: '',
      type: '',
      color: '',
      mileage: 0,
      plate: '',
      customerId: 0,
    );
  }

  Future<void> loadVehicle() async {
    try {
      if (state.id == 0) {
        state = state.copyWith(
          isLoading: false,
          vehicle: _newEmptyVehicle(),
        );
        return;
      }

      final vehicle = await vehiclesRepository.getVehicleById(state.id);

      state = state.copyWith(
        isLoading: false,
        vehicle: vehicle,
      );
    } catch (e) {
      print(e);
    }
  }
}

class VehicleState {
  final int id;
  final Vehicle? vehicle;
  final bool isLoading;
  final bool isSaving;

  VehicleState({
    required this.id,
    this.vehicle,
    this.isLoading = true,
    this.isSaving = false,
  });

  VehicleState copyWith({
    int? id,
    Vehicle? vehicle,
    bool? isLoading,
    bool? isSaving,
  }) =>
      VehicleState(
        id: id ?? this.id,
        vehicle: vehicle ?? this.vehicle,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
