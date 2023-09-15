import 'package:cars_app/features/shared/shared.dart';
import 'package:cars_app/features/vehicles/domain/domain.dart';
import 'package:cars_app/features/vehicles/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final vehicleFormProvider = StateNotifierProvider.autoDispose
    .family<VehicleFormNotifier, VehicleFormState, Vehicle>((ref, vehicle) {
  final createUpdateCallback =
      ref.watch(vehiclesProvider.notifier).createOrUpdateVehicles;

  return VehicleFormNotifier(
    vehicle: vehicle,
    onSubmitCallBack: createUpdateCallback,
  );
});

class VehicleFormNotifier extends StateNotifier<VehicleFormState> {
  final Future<bool> Function(Map<String, dynamic> vehicleLike)?
      onSubmitCallBack;

  VehicleFormNotifier({
    this.onSubmitCallBack,
    required Vehicle vehicle,
  }) : super(
          VehicleFormState(
            id: vehicle.id,
            name: vehicle.name,
            manufacturer: vehicle.manufacturer,
            model: vehicle.model,
            fuel: vehicle.fuel,
            type: vehicle.type,
            color: vehicle.color,
            mileage: vehicle.mileage,
            vId: vehicle.vId,
            plate: Plate.dirty(vehicle.plate),
            owner: Select.dirty(vehicle.owner),
          ),
        );

  Future<bool> onFormSubmit() async {
    _touchedEveryField();

    final vehicleLike = {
      'id': (state.id == 0) ? null : state.id,
      'name': state.name,
      'manufacturer': state.manufacturer,
      'model': state.model,
      'fuel': state.fuel,
      'type': state.type,
      'color': state.color,
      'mileage': state.mileage,
      'vId': state.vId,
      'plate': state.plate.value,
      'owner': state.owner.value,
    };

    try {
      return await onSubmitCallBack!(vehicleLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEveryField() {
    state = state.copyWith(
        isValidForm: Formz.validate([
      Plate.dirty(state.plate.value),
      Select.dirty(state.owner.value),
    ]));
  }
}

// TODO: Acá se puede crear tantos campos personalizados como se necesite ej: Plate, Select.
class VehicleFormState {
  final bool isValidForm;
  final int? id;
  final String name;
  final String manufacturer;
  final String model;
  final String fuel;
  final String type;
  final String color;
  final int mileage;
  final String vId;
  final Plate plate;
  final Select owner;
  final String? createdAt;
  final String? updatedAt;

  VehicleFormState({
    this.isValidForm = false,
    this.id,
    this.name = '',
    this.manufacturer = '',
    this.model = '',
    this.fuel = '',
    this.type = '',
    this.color = '',
    this.mileage = 0,
    this.vId = '',
    this.plate = const Plate.dirty(''),
    this.owner = const Select.dirty(0),
    this.createdAt,
    this.updatedAt,
  });

  VehicleFormState copyWith({
    bool? isValidForm,
    int? id,
    String? name,
    String? manufacturer,
    String? model,
    String? fuel,
    String? type,
    String? color,
    int? mileage,
    String? vId,
    Plate? plate,
    Select? owner,
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
        vId: vId ?? this.vId,
        plate: plate ?? this.plate,
        owner: owner ?? this.owner,
      );
}
