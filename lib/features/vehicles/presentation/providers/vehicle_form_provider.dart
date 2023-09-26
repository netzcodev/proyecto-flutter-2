import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:cars_app/features/vehicles/domain/domain.dart';
import 'package:cars_app/features/vehicles/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final vehicleFormProvider = StateNotifierProvider.autoDispose
    .family<VehicleFormNotifier, VehicleFormState, Vehicle>((ref, vehicle) {
  final createUpdateCallback =
      ref.watch(vehiclesProvider.notifier).createOrUpdateVehicles;
  final authState = ref.read(authProvider);
  return VehicleFormNotifier(
    vehicle: vehicle,
    onSubmitCallBack: createUpdateCallback,
    authState: authState,
  );
});

class VehicleFormNotifier extends StateNotifier<VehicleFormState> {
  final Future<bool> Function(Map<String, dynamic> vehicleLike)?
      onSubmitCallBack;

  VehicleFormNotifier({
    this.onSubmitCallBack,
    required Vehicle vehicle,
    required AuthState authState,
  }) : super(
          VehicleFormState(
            id: vehicle.id,
            name: VehicleName.dirty(vehicle.name),
            manufacturer: vehicle.manufacturer,
            model: vehicle.model,
            fuel: Fuel.dirty(vehicle.fuel),
            type: vehicle.type,
            color: vehicle.color,
            mileage: Mileage.dirty(vehicle.mileage),
            plate: Plate.dirty(vehicle.plate),
            customerId: authState.user!.role == 'cliente'
                ? Select.dirty(authState.user!.id)
                : Select.dirty(vehicle.customerId),
          ),
        );

  Future<bool> onFormSubmit() async {
    _touchedEveryField();

    final vehicleLike = {
      'id': (state.id == 0) ? null : state.id,
      'name': state.name.value,
      'manufacturer': state.manufacturer,
      'model': state.model,
      'fuel': state.fuel.value,
      'type': state.type,
      'color': state.color,
      'mileage': state.mileage.value,
      'plate': state.plate.value,
      'customerId': state.customerId.value,
    };

    try {
      return await onSubmitCallBack!(vehicleLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEveryField() {
    state = state.copyWith(
      isValidForm: Formz.validate(
        [
          Plate.dirty(state.plate.value),
          Fuel.dirty(state.fuel.value),
          Mileage.dirty(state.mileage.value),
          VehicleName.dirty(state.name.value),
        ],
      ),
    );
  }

  void onNameChanged(String value) {
    state = state.copyWith(
      name: VehicleName.dirty(value),
      isValidForm: Formz.validate([
        Plate.dirty(state.plate.value),
        Select.dirty(state.customerId.value),
        Fuel.dirty(state.fuel.value),
        Mileage.dirty(state.mileage.value),
        VehicleName.dirty(value),
      ]),
    );
  }

  void onFuelChanged(String value) {
    state = state.copyWith(
      fuel: Fuel.dirty(value),
      isValidForm: Formz.validate([
        Plate.dirty(state.plate.value),
        Select.dirty(state.customerId.value),
        Fuel.dirty(value),
        Mileage.dirty(state.mileage.value),
        VehicleName.dirty(state.name.value),
      ]),
    );
  }

  void onMileageChanged(int value) {
    state = state.copyWith(
      mileage: Mileage.dirty(value),
      isValidForm: Formz.validate([
        Plate.dirty(state.plate.value),
        Select.dirty(state.customerId.value),
        Fuel.dirty(state.fuel.value),
        Mileage.dirty(value),
        VehicleName.dirty(state.name.value),
      ]),
    );
  }

  void onPlateChanged(String value) {
    state = state.copyWith(
      plate: Plate.dirty(value),
      isValidForm: Formz.validate([
        Plate.dirty(value),
        Select.dirty(state.customerId.value),
        Fuel.dirty(state.fuel.value),
        Mileage.dirty(state.mileage.value),
        VehicleName.dirty(state.name.value),
      ]),
    );
  }

  void onOwnerChanged(int value) {
    state = state.copyWith(
      customerId: Select.dirty(value),
      isValidForm: Formz.validate([
        Plate.dirty(state.plate.value),
        Fuel.dirty(state.fuel.value),
        Mileage.dirty(state.mileage.value),
        VehicleName.dirty(state.name.value),
        Select.dirty(value),
      ]),
    );
  }

  void onManufacturerChanged(String value) {
    state = state.copyWith(manufacturer: value);
  }

  void onModelChanged(String value) {
    state = state.copyWith(model: value);
  }

  void onColorChanged(String value) {
    state = state.copyWith(color: value);
  }

  void onTypeChanged(String value) {
    state = state.copyWith(type: value);
  }
}

// TODO: Acá se puede crear tantos campos personalizados como se necesite ej: Plate, Select.
class VehicleFormState {
  final bool isValidForm;
  final int? id;
  final VehicleName name;
  final String manufacturer;
  final String model;
  final Fuel fuel;
  final String type;
  final String color;
  final Mileage mileage;
  final Plate plate;
  final Select customerId;
  final String? createdAt;
  final String? updatedAt;

  VehicleFormState({
    this.isValidForm = false,
    this.id,
    this.name = const VehicleName.dirty(''),
    this.manufacturer = '',
    this.model = '',
    this.fuel = const Fuel.dirty(''),
    this.type = '',
    this.color = '',
    this.mileage = const Mileage.dirty(0),
    this.plate = const Plate.dirty(''),
    this.customerId = const Select.dirty(0),
    this.createdAt,
    this.updatedAt,
  });

  VehicleFormState copyWith({
    bool? isValidForm,
    int? id,
    VehicleName? name,
    String? manufacturer,
    String? model,
    Fuel? fuel,
    String? type,
    String? color,
    Mileage? mileage,
    Plate? plate,
    Select? customerId,
  }) =>
      VehicleFormState(
        isValidForm: isValidForm ?? this.isValidForm,
        id: id ?? this.id,
        name: name ?? this.name,
        manufacturer: manufacturer ?? this.manufacturer,
        model: model ?? this.model,
        fuel: fuel ?? this.fuel,
        type: type ?? this.type,
        color: color ?? this.color,
        mileage: mileage ?? this.mileage,
        plate: plate ?? this.plate,
        customerId: customerId ?? this.customerId,
      );
}
