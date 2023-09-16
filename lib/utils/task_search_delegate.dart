import 'package:codigo_firetask/models/task_model.dart';
import 'package:codigo_firetask/ui/widgets/item_task_wdiget.dart';
import 'package:flutter/material.dart';

class TaskSearchDelegate extends SearchDelegate {
  List<TaskModel> taskModel;
  TaskSearchDelegate({required this.taskModel});

  List<String> names = [
    "Anshu",
    "Anshika",
    "Amit",
    "Aman",
    "Ankit",
    "Anshu",
    "Anshika",
    "Amit",
    "Aman",
    "Ankit",
    "Anshu",
    "Anshika",
  ];

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Search task...';
  @override
  // TODO: implement searchFieldStyle
  TextStyle? get searchFieldStyle => const TextStyle(
        fontSize: 16,
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<TaskModel> suggestionList2 = taskModel
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ItemTaskWidget(
            taskModel: suggestionList2[index],
          );
        },
        itemCount: suggestionList2.length,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = names
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
    List<TaskModel> suggestionList2 = taskModel
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ItemTaskWidget(
            taskModel: suggestionList2[index],
          );
        },
        itemCount: suggestionList2.length,
      ),
    );
  }
}
