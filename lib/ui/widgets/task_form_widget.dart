import 'package:codigo_firetask/models/task_model.dart';
import 'package:codigo_firetask/services/firestore_service.dart';
import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:codigo_firetask/ui/widgets/button_normal_widget.dart';
import 'package:codigo_firetask/ui/widgets/general_widgets.dart';
import 'package:codigo_firetask/ui/widgets/textfield_normal_widget.dart';
import 'package:flutter/material.dart';

class TaskFormWidget extends StatefulWidget {
  const TaskFormWidget({
    super.key,
  });

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  final formKey = GlobalKey<FormState>();
  FirestoreService firestoreService = FirestoreService(collection: "tasks");
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String _category = "Personal";
  final List<String> _categories = [
    "Personal",
    "Trabajo",
    "Otro",
  ];

  showSelectedDate() async {
    DateTime? datetime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      cancelText: "Cancelar",
      confirmText: "Aceptar",
      helpText: "Seleccionar fecha",
      builder: (BuildContext context, Widget? widget) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogTheme: DialogTheme(
              backgroundColor: kBrandSecondaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: kBrandPrimaryColor,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: widget!,
        );
      },
    );

    if (datetime != null) {
      _dateController.text = datetime.toString().substring(0, 10);
    }
  }

  registerTask() {
    if (formKey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        category: _category,
        isDone: false,
      );

      firestoreService.addTask(taskModel).then((value) {
        if (value.isNotEmpty) {
          Navigator.pop(context);
          showSnackBarSucces(context, "Tarea agregada");
        }
      }).catchError((error) {
        showSnackBarError(context, "Error al agregar tarea");
      });

      //snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Task",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kBrandPrimaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              divider3(),
              TextFieldNormalWidget(
                hintText: "Titulo",
                iconData: Icons.text_fields,
                controller: _titleController,
              ),
              divider10(),
              TextFieldNormalWidget(
                hintText: "Descripcion",
                iconData: Icons.description,
                controller: _descriptionController,
              ),
              divider10(),
              TextFieldNormalWidget(
                hintText: "Fecha",
                iconData: Icons.date_range,
                controller: _dateController,
                onTap: () {
                  showSelectedDate();
                },
              ),
              divider10(),
              Text(
                "Categoria: ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kBrandPrimaryColor.withOpacity(0.9),
                ),
              ),
              Wrap(
                spacing: 10,
                children: [
                  ..._categories.map(
                    (e) => FilterChip(
                      selected: _category == e,
                      label: Text(e),
                      backgroundColor: kBrandSecondaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      selectedColor: categoryColor[e],
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                          color: _category == e ? Colors.white : Colors.grey),
                      onSelected: (bool value) {
                        _category = e;
                        _categoryController.text = e;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              divider6(),
              ButtonNormalWidget(
                text: "Agregar",
                onPressed: () {
                  registerTask();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
