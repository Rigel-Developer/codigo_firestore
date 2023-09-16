class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? urlImage;

  UserModel({this.id, this.name, this.email, this.password, this.urlImage});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["password"] is String) {
      password = json["password"];
    }
    if (json["urlImage"] is String) {
      urlImage = json["urlImage"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["password"] = password;
    data["urlImage"] = urlImage;
    return data;
  }
}
