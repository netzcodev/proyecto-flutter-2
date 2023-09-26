import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/auth/presentation/providers/providers.dart';
// import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/services/domain/domain.dart';
import 'package:cars_app/features/services/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:cars_app/features/vehicles/vehicles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceFormWidget extends ConsumerWidget {
  final Service service;
  final int scheduleId;

  const ServiceFormWidget({
    Key? key,
    required this.service,
    required this.scheduleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref
        .watch(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'Services');
    final serviceForm = ref.watch(serviceFormProvider(service));
    final authState = ref.watch(authProvider);
    final vehiclesList = ref.watch(vehiclesProvider).vehicles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormField(
              enabled: permissions.modify == 1 ? true : false,
              isTopField: true,
              label: 'Nombre',
              initialValue: serviceForm.name.value,
              onChanged:
                  ref.read(serviceFormProvider(service).notifier).onNameChanged,
              errorMessage: serviceForm.name.errorMessage,
            ),
            CustomFormField(
              enabled: permissions.modify == 1 ? true : false,
              label: 'Descripción',
              initialValue: serviceForm.description.value,
              onChanged: ref
                  .read(serviceFormProvider(service).notifier)
                  .onDescriptionChanged,
              errorMessage: serviceForm.description.errorMessage,
            ),
            CustomFormField(
              enabled: permissions.modify == 1 ? true : false,
              label: 'Duración',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              initialValue: serviceForm.duration.value == 0
                  ? ''
                  : serviceForm.duration.value.toString(),
              onChanged: (value) => ref
                  .read(serviceFormProvider(service).notifier)
                  .onDurationChanged(int.tryParse(value) ?? -1),
              errorMessage: serviceForm.duration.errorMessage,
            ),
            CustomFormField(
              enabled: permissions.modify == 1 ? true : false,
              isBottomField: true,
              label: 'Kilometraje',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              initialValue: serviceForm.mileage.value == 0
                  ? ''
                  : serviceForm.mileage.value.toString(),
              onChanged: (value) => ref
                  .read(serviceFormProvider(service).notifier)
                  .onMileageChanged(int.tryParse(value) ?? -1),
              errorMessage: serviceForm.mileage.errorMessage,
            ),
            if (authState.user!.role != 'cliente') const SizedBox(height: 10),
            if (authState.user!.role != 'cliente')
              VehicleDropdown(
                enabled: permissions.modify == 1 ? true : false,
                entityList: vehiclesList,
                displayNameFunction: null,
                label: 'Vehiculo',
                selected: authState.user!.role != 'cliente'
                    ? authState.user!.id
                    : serviceForm.vehicleId.value,
                onSelected: (value) => ref
                    .read(serviceFormProvider(service).notifier)
                    .onVehicleChanged(value ?? -1),
                errorMessage: serviceForm.vehicleId.errorMessage,
              ),
            const SizedBox(height: 3),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(serviceFormProvider(service).notifier)
                    .onFormSubmit()
                    .then((value) {
                  if (value) {
                    if (!value) return;
                    Navigator.of(context).pop();
                    ref.read(goRouterProvider).go('/calendar');
                  }
                });
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
