import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerFormField extends StatefulWidget {
  final bool isTopField;
  final bool isBottomField;
  final bool enabled;
  final String? label;
  final String? hint;
  final String? errorMessage;
  final String? initialValue;
  final Function(DateTime)? onChanged;

  const CustomDatePickerFormField({
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
  CustomDatePickerFormFieldState createState() =>
      CustomDatePickerFormFieldState();
}

class CustomDatePickerFormFieldState extends State<CustomDatePickerFormField> {
  DateTime? _selectedDate;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialValue != null
        ? DateTime.tryParse(widget.initialValue!)
        : null;
    _updateText();
  }

  void _updateText() {
    final formattedDate = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : '';
    _textController.text = formattedDate;
  }

  DateTime getFirstSelectableDate(DateTime now) {
    DateTime firstDate = (now.hour > 16 || (now.hour == 16 && now.minute > 0))
        ? DateTime.now().add(const Duration(days: 1))
        : DateTime.now();

    while (firstDate.weekday == 7) {
      firstDate = firstDate.add(const Duration(days: 1));
    }

    return firstDate;
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
        controller: _textController,
        onTap: () async {
          final DateTime now = DateTime.now();
          DateTime firstSelectableDate = getFirstSelectableDate(now);

          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: firstSelectableDate,
            lastDate: DateTime(2101),
            selectableDayPredicate: (day) {
              // Si es domingo o es antes de la fecha actual, retorna false
              if (day.weekday == 7 ||
                  day.isBefore(DateTime(now.year, now.month, now.day, 0, 0))) {
                return false;
              }
              return true;
            },
          );

          if (selectedDate != null) {
            setState(() {
              _selectedDate = selectedDate;
              _updateText();
            });

            if (widget.onChanged != null) {
              widget.onChanged!(_selectedDate!);
            }
          }
        },
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
