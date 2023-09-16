import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonCustomWidget extends StatelessWidget {
  String? text;
  Color color;
  String iconPath;
  Function? onPressed;
  ButtonCustomWidget({
    super.key,
    required this.text,
    required this.color,
    required this.iconPath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: color,
        ),
        onPressed: () {
          onPressed!();
        },
        icon: SvgPicture.asset(
          iconPath,
          height: 24,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        label: Text(
          text!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
