import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/schedules/domain/domain.dart';
import 'package:cars_app/features/schedules/presentation/providers/providers.dart';
import 'package:cars_app/features/services/services.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleScreen extends ConsumerWidget {
  final int scheduleId;
  final int _serviceId = 0;

  const ScheduleScreen({
    super.key,
    required this.scheduleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleState = ref.watch(scheduleProvider(scheduleId));
    final serviceState = ref.watch(serviceProvider([_serviceId, scheduleId]));
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
              onPressed: () => _showServiceDialog(context, ref,
                  scheduleId: scheduleId, service: serviceState.service!),
              icon: const Icon(Icons.supervised_user_circle_outlined),
            )
          ],
        ),
        body: scheduleState.isLoading
            ? const FullScreenLoader()
            : _ScheduleView(schedule: scheduleState.schedule!),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (scheduleId != 0)
              FloatingActionButton(
                onPressed: () {
                  _showServiceDialog(context, ref,
                      service: serviceState.service!, scheduleId: scheduleId);
                },
                child: const Icon(
                  Icons.build_outlined,
                ),
              ),
            const SizedBox(height: 15),
            FloatingActionButton(
              heroTag: scheduleState,
              onPressed: () {
                if (scheduleState.schedule == null) return;
                if (permissions.modify == 0) return;
                ref
                    .watch(
                        scheduleFormProvider(scheduleState.schedule!).notifier)
                    .onFormSubmit()
                    .then(
                  (value) {
                    if (!value) return;
                    _showSnackbar(context, scheduleState.schedule!.id);
                    ref.read(goRouterProvider).go('/calendar');
                  },
                );
              },
              child: const Icon(Icons.save_outlined),
            ),
          ],
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
  final ScrollController _scrollController = ScrollController();
  _ScheduleInformation({required this.schedule});

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
          if (schedule.services.isNotEmpty) const SizedBox(height: 30),
          if (schedule.services.isNotEmpty) const Divider(),
          if (schedule.services.isNotEmpty) const SizedBox(height: 13),
          if (schedule.services.isNotEmpty)
            const Text(
              'Servicios:',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (schedule.services.isNotEmpty) const SizedBox(height: 15),
          if (schedule.services.isNotEmpty)
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: schedule.services.map((service) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        service.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      leading: const Icon(Icons.build_outlined),
                      trailing: IconButton(
                          onPressed: () {
                            // ref.read(scheduleProvider(service.scheduleId!).notifier).onDeletedService(service.id);
                            ref
                                .read(servicesProvider.notifier)
                                .deleteService(service.id!);
                          },
                          icon: const Icon(Icons.cancel_outlined)),
                      subtitle: Text(service.description),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

void _showServiceDialog(BuildContext context, WidgetRef ref,
    {required Service service, required int scheduleId}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('${service.id == 0 ? 'Agregar' : 'Editar '} Servicio'),
        content: ServiceFormWidget(service: service, scheduleId: scheduleId),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

void _showSnackbar(BuildContext context, int? id) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Cita ${id == 0 ? 'Creada' : 'Actualizada'}'),
    ),
  );
}
