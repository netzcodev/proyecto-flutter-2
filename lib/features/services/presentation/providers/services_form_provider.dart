import 'package:cars_app/features/services/domain/domain.dart';
import 'package:cars_app/features/services/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final serviceFormProvider = StateNotifierProvider.autoDispose
    .family<ServiceFormNotifier, ServiceFormState, Service>((ref, service) {
  final createUpdateCallback =
      ref.watch(servicesProvider.notifier).createOrUpdateServices;
  return ServiceFormNotifier(
    service: service,
    onSubmitCallBack: createUpdateCallback,
  );
});

class ServiceFormNotifier extends StateNotifier<ServiceFormState> {
  final Future<bool> Function(Map<String, dynamic> serviceLike)?
      onSubmitCallBack;

  ServiceFormNotifier({
    this.onSubmitCallBack,
    required Service service,
  }) : super(
          ServiceFormState(
              duration: DurationService.dirty(service.duration),
              name: ScheduleName.dirty(service.name),
              description: Description.dirty(service.description),
              currentDate: DateTime.now().toString(),
              comingDate: _calcularFecha().toString(),
              scheduleId: service.scheduleId,
              vehicleId: SelectVehicle.dirty(service.vehicleId)),
        );

  Future<bool> onFormSubmit() async {
    _touchedEveryField();

    final serviceLike = {
      'id': (state.id == 0) ? null : state.id,
      'name': state.name.value,
      'serviceTypeId': 1,
      'duration': state.duration.value,
      'description': state.description.value,
      'currentDate': state.currentDate,
      'comingDate': state.comingDate,
      'scheduleId': state.scheduleId,
      'vehicleId': state.vehicleId.value,
      'mileage': state.mileage.value,
    };

    try {
      return await onSubmitCallBack!(serviceLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEveryField() {
    state = state.copyWith(
      isValidForm: Formz.validate(
        [
          DurationService.dirty(state.duration.value),
          ScheduleName.dirty(state.name.value),
          Description.dirty(state.description.value),
          SelectVehicle.dirty(state.vehicleId.value),
          Mileage.dirty(state.mileage.value),
        ],
      ),
    );
  }

  void onDurationChanged(int value) {
    state = state.copyWith(
      duration: DurationService.dirty(value),
      isValidForm: Formz.validate([
        DurationService.dirty(value),
        ScheduleName.dirty(state.name.value),
        Description.dirty(state.description.value),
        SelectVehicle.dirty(state.vehicleId.value),
        Mileage.dirty(state.mileage.value),
      ]),
    );
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(
      description: Description.dirty(value),
      isValidForm: Formz.validate([
        DurationService.dirty(state.duration.value),
        ScheduleName.dirty(state.name.value),
        Description.dirty(value),
        SelectVehicle.dirty(state.vehicleId.value),
        Mileage.dirty(state.mileage.value),
      ]),
    );
  }

  void onNameChanged(String value) {
    state = state.copyWith(
      name: ScheduleName.dirty(value),
      isValidForm: Formz.validate([
        DurationService.dirty(state.duration.value),
        ScheduleName.dirty(value),
        Description.dirty(state.description.value),
        SelectVehicle.dirty(state.vehicleId.value),
        Mileage.dirty(state.mileage.value),
      ]),
    );
  }

  void onVehicleChanged(int value) {
    state = state.copyWith(
      vehicleId: SelectVehicle.dirty(value),
      isValidForm: Formz.validate([
        DurationService.dirty(state.duration.value),
        ScheduleName.dirty(state.name.value),
        Description.dirty(state.description.value),
        SelectVehicle.dirty(value),
        Mileage.dirty(state.mileage.value),
      ]),
    );
  }

  void onMileageChanged(int value) {
    state = state.copyWith(
      mileage: Mileage.dirty(value),
      isValidForm: Formz.validate([
        DurationService.dirty(state.duration.value),
        ScheduleName.dirty(state.name.value),
        Description.dirty(state.description.value),
        SelectVehicle.dirty(state.vehicleId.value),
        Mileage.dirty(value),
      ]),
    );
  }

  void onScheduleIdChanged(int value) {
    state = state.copyWith(scheduleId: value);
  }
}

// TODO: Acá se puede crear tantos campos personalizados como se necesite ej: Plate, Select.
class ServiceFormState {
  final bool isValidForm;
  final int? id;
  final DurationService duration;
  final ScheduleName name;
  final Description description;
  final Mileage mileage;
  final String currentDate;
  final String comingDate;
  final int? scheduleId;
  final SelectVehicle vehicleId;

  ServiceFormState({
    this.isValidForm = false,
    this.id,
    this.duration = const DurationService.dirty(0),
    this.name = const ScheduleName.dirty(''),
    this.description = const Description.dirty(''),
    required this.currentDate,
    required this.comingDate,
    this.scheduleId,
    this.vehicleId = const SelectVehicle.dirty(0),
    this.mileage = const Mileage.dirty(0),
  });

  ServiceFormState copyWith({
    bool? isValidForm,
    int? id,
    int? scheduleId,
    SelectVehicle? vehicleId,
    DurationService? duration,
    ScheduleName? name,
    Description? description,
    String? currentDate,
    String? comingDate,
    Mileage? mileage,
  }) =>
      ServiceFormState(
        isValidForm: isValidForm ?? this.isValidForm,
        id: id ?? this.id,
        duration: duration ?? this.duration,
        description: description ?? this.description,
        name: name ?? this.name,
        currentDate: currentDate ?? this.currentDate,
        comingDate: comingDate ?? this.comingDate,
        scheduleId: scheduleId ?? this.scheduleId,
        vehicleId: vehicleId ?? this.vehicleId,
        mileage: mileage ?? this.mileage,
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
