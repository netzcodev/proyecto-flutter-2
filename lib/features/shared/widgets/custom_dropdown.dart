import 'package:cars_app/features/people/people.dart';
import 'package:flutter/material.dart';

class OwnerDropdown extends StatefulWidget {
  final List<People> entityList;
  final String? errorMessage;
  final bool? enabled;
  final String label;
  final String Function(People)? displayNameFunction;
  final void Function(int?)? onSelected;
  final People? selectedEntity;
  final int? selected;

  const OwnerDropdown({
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
  State<OwnerDropdown> createState() => _CustomDropdownState<People>();
}

class _CustomDropdownState<People> extends State<OwnerDropdown> {
  final TextEditingController textContoller = TextEditingController();
  int? selectedRow;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<int>> entries = <DropdownMenuEntry<int>>[];

    for (final item in widget.entityList) {
      entries.add(
        DropdownMenuEntry<int>(
          value: item.id,
          label: item.toString(),
          enabled: true,
        ),
      );
    }
    return Center(
      child: DropdownMenu<int>(
        controller: textContoller,
        errorText: widget.errorMessage,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        label: Text(widget.label),
        dropdownMenuEntries: entries,
        hintText: 'Selecciona',
        enabled: widget.enabled!,
        onSelected: widget.onSelected,
        initialSelection: widget.selected,
      ),
    );
  }
}