class TaskModel {
  String? id;
  String? category;
  String? title;
  String? description;
  String? date;
  bool? isDone;

  TaskModel({
    this.id,
    this.category,
    this.title,
    this.description,
    this.date,
    this.isDone,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["category"] is String) {
      category = json["category"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["date"] is String) {
      date = json["date"];
    }
    if (json["isDone"] is bool) {
      isDone = json["isDone"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["category"] = category;
    data["title"] = title;
    data["description"] = description;
    data["date"] = date;
    data["isDone"] = isDone;
    return data;
  }
}
