import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputBorder? border;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final AutovalidateMode? autoValidateMode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const InputField(
      {Key? key,
        required this.label,
        this.keyboardType = TextInputType.text,
        this.obscureText = false,
        this.prefixIcon,
        this.suffixIcon,
        this.border,
        this.validator,
        this.controller,
        this.inputFormatters,
        this.readOnly = false,
        this.autoValidateMode,
        this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autoValidateMode,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16),
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: border),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
