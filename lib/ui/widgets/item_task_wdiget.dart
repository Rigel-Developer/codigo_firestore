import 'package:codigo_firetask/models/task_model.dart';
import 'package:codigo_firetask/services/firestore_service.dart';
import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:codigo_firetask/ui/widgets/button_normal_widget.dart';
import 'package:codigo_firetask/ui/widgets/general_widgets.dart';
import 'package:codigo_firetask/ui/widgets/item_category_widget.dart';
import 'package:flutter/material.dart';

class ItemTaskWidget extends StatelessWidget {
  TaskModel taskModel;
  ItemTaskWidget({
    super.key,
    required this.taskModel,
  });

  FirestoreService firestoreService = FirestoreService(collection: "tasks");

  showFinishedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Finalizar tarea",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kBrandPrimaryColor,
                ),
              ),
              divider6(),
              Text(
                "¿Desea finalizar la tarea selecionada?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kBrandPrimaryColor.withOpacity(0.5),
                ),
              ),
              divider10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        color: kBrandPrimaryColor,
                      ),
                    ),
                  ),
                  dividerHorizontal6(),
                  ElevatedButton(
                      onPressed: () {
                        firestoreService.finishTask(taskModel.id!);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBrandPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Finalizar")),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width * 0.9,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(4, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemCategoryWidget(text: taskModel.category!),
              divider6(),
              Text(
                taskModel.title!,
                style: TextStyle(
                  decoration: taskModel.isDone!
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kBrandPrimaryColor,
                ),
              ),
              Text(
                taskModel.description!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kBrandPrimaryColor.withOpacity(0.5),
                ),
              ),
              divider6(),
              Text(
                taskModel.date!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kBrandPrimaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "Editar",
                    child: const Text("Editar"),
                    onTap: () {
                      print("Editar ");
                    },
                  ),
                  PopupMenuItem(
                    enabled: taskModel.isDone! ? false : true,
                    value: "Finalizar",
                    child: const Text("Finalizar"),
                    onTap: () {
                      print("Finalizar ");
                      showFinishedDialog(context);
                    },
                  ),
                ];
              },
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
