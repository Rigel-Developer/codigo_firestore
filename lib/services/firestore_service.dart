import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codigo_firetask/models/task_model.dart';
import 'package:codigo_firetask/models/user_model.dart';

class FirestoreService {
  String collection;
  FirestoreService({required this.collection});

  late final CollectionReference tasksReference =
      FirebaseFirestore.instance.collection(collection);

  //get
  Stream<QuerySnapshot> getTasks() {
    return tasksReference.snapshots();
  }

  //add
  Future<String> addTask(TaskModel task) async {
    DocumentReference documentReference =
        await tasksReference.add(task.toJson());
    return documentReference.id;
  }

  //finish task
  Future<void> finishTask(String idTask) async {
    await tasksReference.doc(idTask).update({"isDone": true});
  }

  //update
  Future<void> updateTask(Map<String, dynamic> task, String id) {
    return tasksReference.doc(id).update(task);
  }

  //delete
  Future<void> deleteTask(String id) {
    return tasksReference.doc(id).delete();
  }

  //**USERS */

  //add
  Future<String> addUser(UserModel user) async {
    DocumentReference documentReference =
        await tasksReference.add(user.toJson());
    return documentReference.id;
  }

  Future<bool> existUser(String email) async {
    QuerySnapshot querySnapshot = await tasksReference
        .where("email", isEqualTo: email)
        .get()
        .catchError((error) {
      print("error $error");
    });
    return querySnapshot.docs.isNotEmpty;
  }
}
