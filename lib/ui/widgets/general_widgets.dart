import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:flutter/material.dart';

Widget divider3() => const SizedBox(height: 3);
Widget divider6() => const SizedBox(height: 6);
Widget divider10() => const SizedBox(height: 10);
Widget divider14() => const SizedBox(height: 14);
Widget divider20() => const SizedBox(height: 20);
Widget divider30() => const SizedBox(height: 30);
Widget divider40() => const SizedBox(height: 40);

Widget dividerHorizontal3() => const SizedBox(width: 3);
Widget dividerHorizontal6() => const SizedBox(width: 6);
Widget dividerHorizontal10() => const SizedBox(width: 10);
Widget dividerHorizontal14() => const SizedBox(width: 14);
Widget dividerHorizontal20() => const SizedBox(width: 20);
Widget dividerHorizontal30() => const SizedBox(width: 30);
Widget dividerHorizontal40() => const SizedBox(width: 40);

Widget loadingWidget() => Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(kBrandPrimaryColor),
        ),
      ),
    );

showSnackBarSucces(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: kBrandPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      content: Text(text),
      duration: const Duration(seconds: 2),
    ),
  );
}

showSnackBarError(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      content: Text(text),
      duration: const Duration(seconds: 2),
    ),
  );
}
