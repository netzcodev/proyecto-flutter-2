import 'package:cars_app/features/vehicles/vehicles.dart';
import 'package:flutter/material.dart';

class VehicleDropdown extends StatefulWidget {
  final List<Vehicle> entityList;
  final String? errorMessage;
  final bool? enabled;
  final String label;
  final String Function(Vehicle)? displayNameFunction;
  final void Function(int?)? onSelected;
  final Vehicle? selectedEntity;
  final int? selected;

  const VehicleDropdown({
    super.key,
    required this.entityList,
    this.displayNameFunction,
    this.onSelected,
    required this.label,
    this.selectedEntity,
    this.errorMessage,
    this.enabled = true,
    this.selected,
  });

  @override
  State<VehicleDropdown> createState() => _CustomDropdownState<Vehicle>();
}

class _CustomDropdownState<Vehicle> extends State<VehicleDropdown> {
  final TextEditingController textContoller = TextEditingController();
  int? selectedRow;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<int>> entries = <DropdownMenuEntry<int>>[];

    for (final item in widget.entityList) {
      entries.add(
        DropdownMenuEntry<int>(
          value: item.id!,
          label: item.plate,
          enabled: true,
        ),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Center(
        child: DropdownMenu<int>(
          width: MediaQuery.of(context).size.width * 0.6,
          controller: textContoller,
          errorText: widget.errorMessage,
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          ),
          label: Text(widget.label),
          dropdownMenuEntries: entries,
          hintText: 'Selecciona',
          enabled: widget.enabled!,
          onSelected: widget.onSelected,
          initialSelection: widget.selected,
        ),
      ),
    );
  }
}
