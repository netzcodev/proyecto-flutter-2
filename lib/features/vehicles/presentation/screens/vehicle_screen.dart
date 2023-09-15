import 'package:cars_app/features/customers/presentation/providers/customers_provider.dart';
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
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Persona Actualizada')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(vehicleProvider(vechicleId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Vehiculo'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.supervised_user_circle_outlined),
            )
          ],
        ),
        body: const _VehicleView(),
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
                context.push('/vehicles');
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
  // final Vehicle vehicle;

  const _VehicleView(
      // {
      // required this.vehicle,
      // }
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final personForm = ref.watch(personFormProvider(person));
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        const _PlateField(placa: ''),
        const SizedBox(height: 10),
        Center(child: Text('', style: textStyles.titleSmall)),
        const SizedBox(height: 10),
        const _VehicleInformation(),
      ],
    );
  }
}

class _VehicleInformation extends ConsumerWidget {
  // final Vehicle vehicle;
  const _VehicleInformation(
      // {required this.vehicle}
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final vehicleForm = ref.watch(personFormProvider(vehicle));
    final customerState = ref.watch(customersProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Datos:'),
          const SizedBox(height: 15),
          const CustomFormField(
            isTopField: true,
            label: 'Nombre',
            initialValue: '',
            // onChanged:
            //     ref.watch(personFormProvider(vehicle).notifier).onNameChanged,
            // errorMessage: personForm.fullName.errorMessage,
          ),
          const CustomFormField(
            label: 'Fabricante',
            initialValue: '',
            // onChanged: (value) => ref
            //     .read(personFormProvider(vehicle).notifier)
            //     .onDocumentChanged(int.tryParse(value) ?? -1),
            // errorMessage: personForm.document.errorMessage,
          ),
          const CustomFormField(
            label: 'Modelo',
            initialValue: '',
            // onChanged:
            //     ref.read(personFormProvider(vehicle).notifier).onEmailChanged,
            // errorMessage: personForm.email.errorMessage,
          ),
          const CustomFormField(
            label: 'Combustible',
            initialValue: '',
            // onChanged:
            //     ref.read(personFormProvider(vehicle).notifier).onEmailChanged,
            // errorMessage: personForm.email.errorMessage,
          ),
          const CustomFormField(
            label: 'Tipo',
            initialValue: '',
            // onChanged:
            //     ref.read(personFormProvider(vehicle).notifier).onEmailChanged,
            // errorMessage: personForm.email.errorMessage,
          ),
          const CustomFormField(
            label: 'Color',
            initialValue: '',
            // onChanged:
            //     ref.read(personFormProvider(vehicle).notifier).onEmailChanged,
            // errorMessage: personForm.email.errorMessage,
          ),
          const CustomFormField(
            label: 'Kilometraje',
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            initialValue: '',
            // onChanged:
            //     ref.read(personFormProvider(vehicle).notifier).onEmailChanged,
            // errorMessage: personForm.email.errorMessage,
          ),
          const CustomFormField(
            isBottomField: true,
            label: 'Identificación',
            initialValue: '',
            // onChanged:
            //     ref.read(personFormProvider(vehicle).notifier).onEmailChanged,
            // errorMessage: personForm.email.errorMessage,
          ),
          const SizedBox(height: 15),
          OwnerDropdown(
            entityList: customerState.customers,
            displayNameFunction: null,
            onSelected: (p0) {
              print(p0);
              return p0 as int;
            },
            label: 'Propietario',
          ),
          const SizedBox(height: 25),
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
  const _PlateField({required this.placa});

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
          child: TextField(
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
            decoration: const InputDecoration(
              hintText: 'ABC123',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              counterText: '',
              focusedBorder: OutlineInputBorder(
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
