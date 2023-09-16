import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:flutter/material.dart';

class TextFieldNormalWidget extends StatefulWidget {
  String? hintText;
  IconData? iconData;
  void Function()? onTap;
  TextEditingController controller;

  TextFieldNormalWidget({
    super.key,
    required this.hintText,
    required this.iconData,
    this.onTap,
    required this.controller,
  });

  @override
  State<TextFieldNormalWidget> createState() => _TextFieldNormalWidgetState();
}

class _TextFieldNormalWidgetState extends State<TextFieldNormalWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onTap: widget.onTap,
      readOnly: widget.onTap == null ? false : true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: kBrandPrimaryColor.withOpacity(0.5),
        ),
        filled: true,
        fillColor: kBrandSecondaryColor,
        prefixIcon: Icon(
          widget.iconData,
          color: kBrandPrimaryColor.withOpacity(0.5),
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
