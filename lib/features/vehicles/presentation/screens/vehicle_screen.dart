import 'package:cars_app/config/config.dart';
import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/people/presentation/providers/people_provider.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:cars_app/features/vehicles/vehicles.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VehicleScreen extends ConsumerWidget {
  final int vechicleId;
  const VehicleScreen({
    super.key,
    required this.vechicleId,
  });

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Vehiculo ${vechicleId == 0 ? 'Creado' : 'Actualizado'}')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider(vechicleId));
    final userRole = ref.read(authProvider).user!.role;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '${vehicleState.vehicle?.id == 0 ? 'Crear' : 'Actualizar'} Vehiculo'),
          actions: [
            if (userRole == 'cliente')
              IconButton(
                onPressed: () {
                  context.push('/notifications');
                },
                icon: const Icon(Icons.notifications_none_outlined),
              )
          ],
        ),
        body: vehicleState.isLoading
            ? const FullScreenLoader()
            : _VehicleView(vehicle: vehicleState.vehicle!),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (vehicleState.vehicle == null) return;
            ref
                .read(vehicleFormProvider(vehicleState.vehicle!).notifier)
                .onFormSubmit()
                .then(
              (value) {
                if (!value) return;
                showSnackbar(context);
                ref.read(goRouterProvider).go('/vehicles');
              },
            );
          },
          child: const Icon(Icons.save_outlined),
        ),
      ),
    );
  }
}

class _VehicleView extends ConsumerWidget {
  final Vehicle vehicle;

  const _VehicleView({
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleForm = ref.watch(vehicleFormProvider(vehicle));
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        _PlateField(
          placa: vehicle.plate,
          onChanged:
              ref.read(vehicleFormProvider(vehicle).notifier).onPlateChanged,
          errorMessage: vehicleForm.plate.errorMessage,
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            '${vehicle.manufacturer} ${vehicle.name}',
            style: textStyles.titleSmall,
          ),
        ),
        const SizedBox(height: 10),
        _VehicleInformation(vehicle: vehicle),
      ],
    );
  }
}

class _VehicleInformation extends ConsumerWidget {
  final Vehicle vehicle;
  const _VehicleInformation({required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleForm = ref.watch(vehicleFormProvider(vehicle));
    final authState = ref.read(authProvider);
    final customersList = ref
        .watch(peopleProvider)
        .people
        .where((element) => element.roleId == 2)
        .toList();
    final permissions = ref
        .watch(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'Vehicles');

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
            initialValue: vehicleForm.name.value,
            onChanged:
                ref.read(vehicleFormProvider(vehicle).notifier).onNameChanged,
            errorMessage: vehicleForm.name.errorMessage,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'Fabricante',
            initialValue: vehicleForm.manufacturer,
            onChanged: ref
                .read(vehicleFormProvider(vehicle).notifier)
                .onManufacturerChanged,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'Modelo',
            initialValue: vehicleForm.model,
            onChanged:
                ref.read(vehicleFormProvider(vehicle).notifier).onModelChanged,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'Combustible',
            initialValue: vehicleForm.fuel.value,
            onChanged:
                ref.read(vehicleFormProvider(vehicle).notifier).onFuelChanged,
            errorMessage: vehicleForm.fuel.errorMessage,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'Tipo',
            initialValue: vehicleForm.type,
            onChanged:
                ref.read(vehicleFormProvider(vehicle).notifier).onTypeChanged,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            label: 'Color',
            initialValue: vehicleForm.color,
            onChanged:
                ref.read(vehicleFormProvider(vehicle).notifier).onColorChanged,
          ),
          CustomFormField(
            enabled: permissions.modify == 1 ? true : false,
            isBottomField: true,
            label: 'Kilometraje',
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            initialValue: vehicleForm.mileage.value == 0
                ? ''
                : vehicleForm.mileage.value.toString(),
            onChanged: (value) => ref
                .read(vehicleFormProvider(vehicle).notifier)
                .onMileageChanged(int.tryParse(value) ?? -1),
            errorMessage: vehicleForm.mileage.errorMessage,
          ),
          const SizedBox(height: 15),
          if (authState.user!.role != 'cliente')
            OwnerDropdown(
              enabled: permissions.modify == 1 ? true : false,
              entityList: customersList,
              displayNameFunction: null,
              label: 'Propietario',
              selected: vehicleForm.customerId.value,
              onSelected: (value) => ref
                  .read(vehicleFormProvider(vehicle).notifier)
                  .onOwnerChanged(value ?? -1),
              errorMessage: vehicleForm.customerId.errorMessage,
            ),
          if (authState.user!.role != 'cliente') const SizedBox(height: 25),
          if (ref.watch(authProvider).user!.isAdmin)
            const _StatusSelector(
              status: 'A',
              onStatusChanged: null,
            ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  final String status;
  final void Function(String staus)? onStatusChanged;

  const _StatusSelector({
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            GestureDetector(
              child: _CustomBadge(
                text: 'Activo',
                color: status == 'A' ? Colors.green : Colors.grey,
                width: 100,
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                // onStatusChanged('A');
              },
            ),
            const SizedBox(width: 10),
            GestureDetector(
              child: _CustomBadge(
                text: 'Inactivo',
                color: status == 'D' ? Colors.redAccent : Colors.grey,
                width: 100,
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                // onStatusChanged('D');
              },
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class _CustomBadge extends StatelessWidget {
  final double width;
  final String text;
  final Color color;

  const _CustomBadge(
      {required this.width, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _PlateField extends StatelessWidget {
  final String placa;
  final String? errorMessage;
  final void Function(String)? onChanged;

  const _PlateField({
    required this.placa,
    this.errorMessage,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        width: 200,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            initialValue: placa,
            onChanged: onChanged,
            obscureText: false,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            textAlignVertical: TextAlignVertical.center,
            maxLength: 6,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'ABC123',
              errorText: errorMessage,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              counterText: '',
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusColor: Colors.black,
            ),
            inputFormatters: [UppercaseTextFormatter()],
          ),
        ),
      ),
    );
  }
}

class UppercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
