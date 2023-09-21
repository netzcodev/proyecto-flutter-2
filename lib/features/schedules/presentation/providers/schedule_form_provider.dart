import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:cars_app/features/schedules/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final scheduleFormProvider = StateNotifierProvider.autoDispose
    .family<ScheduleFormNotifier, ScheduleFormState, Schedule>((ref, schedule) {
  final createUpdateCallback =
      ref.watch(schedulesProvider.notifier).createOrUpdateSchedules;

  return ScheduleFormNotifier(
    schedule: schedule,
    onSubmitCallBack: createUpdateCallback,
  );
});

class ScheduleFormNotifier extends StateNotifier<ScheduleFormState> {
  final Future<bool> Function(Map<String, dynamic> scheduleLike)?
      onSubmitCallBack;

  ScheduleFormNotifier({
    this.onSubmitCallBack,
    required Schedule schedule,
  }) : super(
          ScheduleFormState(
            id: schedule.id,
            customerId: SelectCustomer.dirty(schedule.customerId),
            employeeId: SelectEmployee.dirty(schedule.employeeId),
            date: CustomDate.dirty(schedule.date),
            time: CustomTime.dirty(schedule.time),
            name: ScheduleName.dirty(schedule.name),
            description: Description.dirty(schedule.description),
          ),
        );

  Future<bool> onFormSubmit() async {
    _touchedEveryField();

    if (!state.isValidForm) return false;
    if (onSubmitCallBack == null) return false;

    final scheduleLike = {
      'id': (state.id == 0) ? null : state.id,
      'customerId': state.customerId.value,
      'employeeId': state.employeeId.value,
      'date': state.date.value,
      'name': state.name.value,
      'description': state.description.value,
      'time':
          '${state.time.value.hour < 10 ? '0' : ''}${state.time.value.hour}:${state.time.value.minute < 10 ? '0' : ''}${state.time.value.minute}:00',
    };

    try {
      return await onSubmitCallBack!(scheduleLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEveryField() {
    state = state.copyWith(
      isValidForm: Formz.validate([
        SelectCustomer.dirty(state.customerId.value),
        SelectEmployee.dirty(state.employeeId.value),
        Description.dirty(state.description.value),
        ScheduleName.dirty(state.name.value),
        CustomDate.dirty(state.date.value),
        CustomTime.dirty(state.time.value),
      ]),
    );
  }

  void onEmployeeChanged(int value) {
    state = state.copyWith(
      employeeId: SelectEmployee.dirty(value),
      isValidForm: Formz.validate([
        SelectCustomer.dirty(state.customerId.value),
        SelectEmployee.dirty(value),
        Description.dirty(state.description.value),
        ScheduleName.dirty(state.name.value),
        CustomDate.dirty(state.date.value),
        CustomTime.dirty(state.time.value),
      ]),
    );
  }

  void onCustomerChanged(int value) {
    state = state.copyWith(
      customerId: SelectCustomer.dirty(value),
      isValidForm: Formz.validate([
        SelectCustomer.dirty(value),
        SelectEmployee.dirty(state.employeeId.value),
        Description.dirty(state.description.value),
        ScheduleName.dirty(state.name.value),
        CustomDate.dirty(state.date.value),
        CustomTime.dirty(state.time.value),
      ]),
    );
  }

  void onNameChanged(String value) {
    state = state.copyWith(
      name: ScheduleName.dirty(value),
      isValidForm: Formz.validate([
        SelectCustomer.dirty(state.customerId.value),
        SelectEmployee.dirty(state.employeeId.value),
        Description.dirty(state.description.value),
        ScheduleName.dirty(value),
        CustomDate.dirty(state.date.value),
        CustomTime.dirty(state.time.value),
      ]),
    );
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(
      description: Description.dirty(value),
      isValidForm: Formz.validate([
        SelectCustomer.dirty(state.customerId.value),
        SelectEmployee.dirty(state.employeeId.value),
        Description.dirty(state.description.value),
        ScheduleName.dirty(state.name.value),
        CustomDate.dirty(state.date.value),
        CustomTime.dirty(state.time.value),
      ]),
    );
  }

  void onTimeChanged(TimeOfDay value) {
    state = state.copyWith(
      time: CustomTime.dirty(value),
      isValidForm: Formz.validate([
        SelectCustomer.dirty(state.customerId.value),
        SelectEmployee.dirty(state.employeeId.value),
        Description.dirty(state.description.value),
        ScheduleName.dirty(state.name.value),
        CustomDate.dirty(state.date.value),
        CustomTime.dirty(value),
      ]),
    );
  }

  void onDateChanged(DateTime value) {
    state = state.copyWith(
      date: CustomDate.dirty(value.toString()),
      isValidForm: Formz.validate([
        SelectCustomer.dirty(state.customerId.value),
        SelectEmployee.dirty(state.employeeId.value),
        Description.dirty(state.description.value),
        ScheduleName.dirty(state.name.value),
        CustomDate.dirty(value.toString()),
        CustomTime.dirty(state.time.value),
      ]),
    );
  }

  void disableAllFields() {
    state = state.copyWith(disableAll: true);
  }
}

class ScheduleFormState {
  final bool isPosting;
  final bool disableAll;
  final bool isValidForm;
  final int? id;
  final SelectCustomer customerId;
  final SelectEmployee employeeId;
  final CustomDate date;
  final ScheduleName name;
  final Description description;
  final CustomTime time;

  ScheduleFormState({
    this.isPosting = false,
    this.disableAll = false,
    this.isValidForm = false,
    this.id,
    this.customerId = const SelectCustomer.dirty(0),
    this.employeeId = const SelectEmployee.dirty(0),
    this.name = const ScheduleName.dirty(''),
    this.description = const Description.dirty(''),
    this.date = const CustomDate.dirty(''),
    this.time = const CustomTime.dirty(TimeOfDay(hour: 0, minute: 0)),
  });

  ScheduleFormState copyWith({
    bool? isPosting,
    bool? disableAll,
    bool? isValidForm,
    int? id,
    SelectCustomer? customerId,
    SelectEmployee? employeeId,
    Select? serviceId,
    CustomDate? date,
    CustomTime? time,
    ScheduleName? name,
    Description? description,
  }) =>
      ScheduleFormState(
        isPosting: isPosting ?? this.isPosting,
        disableAll: disableAll ?? this.disableAll,
        isValidForm: isValidForm ?? this.isValidForm,
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        employeeId: employeeId ?? this.employeeId,
        date: date ?? this.date,
        time: time ?? this.time,
        name: name ?? this.name,
        description: description ?? this.description,
      );
}
