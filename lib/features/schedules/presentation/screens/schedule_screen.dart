import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:cars_app/features/schedules/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleScreen extends ConsumerWidget {
  final int scheduleId;
  const ScheduleScreen({
    super.key,
    required this.scheduleId,
  });

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cita ${scheduleId == 0 ? 'Creada' : 'Actualizada'}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(scheduleProvider(scheduleId));
    final permissions = ref
        .read(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'Schedules');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${scheduleState.schedule?.id == 0 ? 'Crear' : 'Actualizar'} Cita',
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.supervised_user_circle_outlined),
            )
          ],
        ),
        body: scheduleState.isLoading
            ? const FullScreenLoader()
            : _ScheduleView(schedule: scheduleState.schedule!),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (scheduleState.schedule == null) return;
            if (permissions.modify == 0) return;
            ref
                .read(scheduleFormProvider(scheduleState.schedule!).notifier)
                .onFormSubmit()
                .then(
              (value) {
                if (!value) return;
                showSnackbar(context);
                ref.read(goRouterProvider).go('/calendar');
              },
            );
          },
          child: const Icon(Icons.save_outlined),
        ),
      ),
    );
  }
}

class _ScheduleView extends ConsumerWidget {
  final Schedule schedule;

  const _ScheduleView({required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        const SizedBox(height: 10),
        _ScheduleInformation(schedule: schedule),
      ],
    );
  }
}

class _ScheduleInformation extends ConsumerWidget {
  final Schedule schedule;
  const _ScheduleInformation({required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleForm = ref.watch(scheduleFormProvider(schedule));
    final authState = ref.read(authProvider);
    final customersList = ref
        .watch(peopleProvider)
        .people
        .where((element) => element.roleId == 2)
        .toList();
    final employeesList = ref
        .watch(peopleProvider)
        .people
        .where((element) => element.roleId == 3)
        .toList();
    final permissions = ref
        .watch(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'Schedules');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos:'),
          const SizedBox(height: 15),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            isTopField: true,
            label: 'Nombre',
            initialValue: scheduleForm.name.value,
            onChanged:
                ref.read(scheduleFormProvider(schedule).notifier).onNameChanged,
            errorMessage: scheduleForm.name.errorMessage,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'Description',
            initialValue: scheduleForm.description.value,
            onChanged: ref
                .read(scheduleFormProvider(schedule).notifier)
                .onDescriptionChanged,
            errorMessage: scheduleForm.description.errorMessage,
          ),
          CustomDatePickerFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'fecha',
            initialValue: scheduleForm.date.value,
            onChanged:
                ref.read(scheduleFormProvider(schedule).notifier).onDateChanged,
            errorMessage: scheduleForm.date.errorMessage,
          ),
          CustomTimePickerFormField(
            enabled: permissions.modify == 1 ? true : false,
            isBottomField: true,
            label: 'Hora',
            initialValue: scheduleForm.time.value,
            onChanged:
                ref.read(scheduleFormProvider(schedule).notifier).onTimeChanged,
            errorMessage: scheduleForm.time.errorMessage,
          ),
          const SizedBox(height: 15),
          if (authState.user!.role == 'admin' ||
              authState.user!.role == 'gerente' ||
              authState.user!.role == 'mecanico')
            OwnerDropdown(
              enabled: permissions.modify == 1 ? true : false,
              entityList: customersList,
              displayNameFunction: null,
              label: 'Cliente',
              selected: authState.user!.role == 'cliente'
                  ? authState.user!.id
                  : scheduleForm.customerId.value,
              onSelected: (value) => ref
                  .read(scheduleFormProvider(schedule).notifier)
                  .onCustomerChanged(value ?? -1),
              errorMessage: scheduleForm.customerId.errorMessage,
            ),
          const SizedBox(height: 15),
          if (authState.user!.role == 'admin' ||
              authState.user!.role == 'gerente' ||
              authState.user!.role == 'cliente')
            OwnerDropdown(
              enabled: permissions.modify == 1 ? true : false,
              entityList: employeesList,
              displayNameFunction: null,
              label: 'Empleado',
              selected: authState.user!.role == 'mecanico'
                  ? authState.user!.id
                  : scheduleForm.employeeId.value,
              onSelected: (value) => ref
                  .read(scheduleFormProvider(schedule).notifier)
                  .onEmployeeChanged(value ?? -1),
              errorMessage: scheduleForm.employeeId.errorMessage,
            ),
        ],
      ),
    );
  }
}
