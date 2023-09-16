import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:flutter/material.dart';

class ItemCategoryWidget extends StatelessWidget {
  ItemCategoryWidget({
    super.key,
    required this.text,
  });

  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: categoryColor[text],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          )),
    );
  }
}
