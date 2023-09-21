import 'package:flutter/material.dart';

class CustomTimePickerFormField extends StatefulWidget {
  final bool isTopField;
  final bool isBottomField;
  final bool enabled;
  final String? label;
  final String? hint;
  final String? errorMessage;
  final TimeOfDay? initialValue;
  final Function(TimeOfDay)? onChanged;

  const CustomTimePickerFormField({
    Key? key,
    this.isTopField = false,
    this.isBottomField = false,
    this.enabled = true,
    this.label,
    this.hint,
    this.errorMessage,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  CustomTimePickerFormFieldState createState() =>
      CustomTimePickerFormFieldState();
}

class CustomTimePickerFormFieldState extends State<CustomTimePickerFormField> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    const borderRadius = Radius.circular(15);

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: widget.isTopField ? borderRadius : Radius.zero,
          topRight: widget.isTopField ? borderRadius : Radius.zero,
          bottomLeft: widget.isBottomField ? borderRadius : Radius.zero,
          bottomRight: widget.isBottomField ? borderRadius : Radius.zero,
        ),
        boxShadow: [
          if (widget.isBottomField)
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
        ],
      ),
      child: TextFormField(
        enabled: widget.enabled,
        readOnly: true,
        onTap: () async {
          final selectedTime = await showTimePicker(
            context: context,
            initialTime: _selectedTime ?? TimeOfDay.now(),
            initialEntryMode: TimePickerEntryMode.inputOnly,
          );

          if (selectedTime != null) {
            setState(() {
              _selectedTime = selectedTime;
            });

            if (widget.onChanged != null) {
              widget.onChanged!(_selectedTime!);
            }
          }
        },
        controller: TextEditingController(
          text: _selectedTime != null
              ? _selectedTime!.format(context)
              : widget.initialValue != null
                  ? widget.initialValue!.format(context)
                  : "",
        ),
        style: TextStyle(
          fontSize: 15,
          color: widget.enabled ? Colors.black54 : Colors.grey.shade400,
        ),
        decoration: InputDecoration(
          disabledBorder: border,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: border.copyWith(
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          isDense: true,
          label: widget.label != null ? Text(widget.label!) : null,
          hintText: widget.hint,
          errorText: widget.errorMessage,
          focusColor: colors.primary,
        ),
      ),
    );
  }
}
