import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:flutter/material.dart';

class TextFieldPasswordWidget extends StatefulWidget {
  void Function()? onTap;
  TextEditingController controller;
  bool isPassword = true;

  TextFieldPasswordWidget({
    super.key,
    this.onTap,
    required this.controller,
  });

  @override
  State<TextFieldPasswordWidget> createState() =>
      _TextFieldPasswordWidgetState();
}

class _TextFieldPasswordWidgetState extends State<TextFieldPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onTap: widget.onTap,
      readOnly: widget.onTap == null ? false : true,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        hintText: "Contraseña",
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: kBrandPrimaryColor.withOpacity(0.5),
        ),
        filled: true,
        fillColor: kBrandSecondaryColor,
        prefixIcon: Icon(
          Icons.lock,
          color: kBrandPrimaryColor.withOpacity(0.5),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            widget.isPassword = !widget.isPassword;
            setState(() {});
          },
          icon: Icon(
            widget.isPassword ? Icons.visibility : Icons.visibility_off,
            color: kBrandPrimaryColor.withOpacity(0.5),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => value!.trim().isEmpty ? "Campo requerido" : null,
    );
  }
}
