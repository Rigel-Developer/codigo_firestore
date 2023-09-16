import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codigo_firetask/models/task_model.dart';
import 'package:codigo_firetask/models/user_model.dart';
import 'package:codigo_firetask/pages/login_page.dart';
import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:codigo_firetask/ui/widgets/button_normal_widget.dart';
import 'package:codigo_firetask/ui/widgets/general_widgets.dart';
import 'package:codigo_firetask/ui/widgets/item_task_wdiget.dart';
import 'package:codigo_firetask/ui/widgets/task_form_widget.dart';
import 'package:codigo_firetask/ui/widgets/textfield_normal_widget.dart';
import 'package:codigo_firetask/utils/task_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  UserModel userModel;

  CollectionReference tasksReference =
      FirebaseFirestore.instance.collection('tasks');
  TaskModel? taskModel;
  List<TaskModel> tasksGeneral = [];

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final tasksRef = FirebaseFirestore.instance
      .collection('tasks')
      .withConverter<TaskModel>(
        fromFirestore: (snapshots, _) => TaskModel.fromJson(snapshots.data()!),
        toFirestore: (task, _) => task.toJson(),
      );

  final TextEditingController _searchController = TextEditingController();

  getDataGoogle() {
    print("currentUser ${userModel.urlImage}");
  }

  HomePage({super.key, required this.userModel});

  showTaskForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const TaskFormWidget(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    getDataGoogle();
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          showTaskForm(context);
        },
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kBrandPrimaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: kBrandPrimaryColor.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(4, 4),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                dividerHorizontal6(),
                const Text(
                  "Agregar tarea",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ),
      backgroundColor: kBrandSecondaryColor,

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(4, 4),
                    )
                  ]),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userModel.urlImage!),
                                ),
                                dividerHorizontal6(),
                                Text(
                                  userModel.name!.substring(
                                    0,
                                    userModel.name!.indexOf(" "),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: kBrandPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Mis tareas",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: kBrandPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            FacebookAuth.instance.logOut();
                            googleSignIn.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          icon: const Icon(Icons.exit_to_app),
                        ),
                      ],
                    ),
                    divider14(),
                    TextFieldNormalWidget(
                      hintText: "Buscar tarea...",
                      iconData: Icons.search,
                      controller: _searchController,
                      onTap: () {
                        showSearch(
                            context: context,
                            delegate: TaskSearchDelegate(
                              taskModel: tasksGeneral,
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ),
            divider6(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Todas las tareas",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kBrandPrimaryColor.withOpacity(0.9),
                    ),
                  ),
                  // divider10(),
                  StreamBuilder(
                    stream: tasksRef.snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        QuerySnapshot querySnapshot = snap.data;
                        List<TaskModel> tasks = querySnapshot.docs
                            .map((e) {
                              taskModel = e.data() as TaskModel;
                              taskModel!.id = e.id;
                              return taskModel;
                            })
                            .toList()
                            .cast<TaskModel>();
                        tasksGeneral.clear();
                        tasksGeneral.addAll(tasks);

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ItemTaskWidget(
                              taskModel: tasks[index],
                            );
                          },
                        );

                        // List<TaskModel> tasks = [];
                        // QuerySnapshot querySnapshot = snap.data;
                        // for (var doc in querySnapshot.docs) {
                        //   Map<String, dynamic> data =
                        //       doc.data() as Map<String, dynamic>;
                        //   tasks.add(TaskModel.fromJson(data));
                        // }

                        // List<TaskModel> tasks = [];
                        // QuerySnapshot querySnapshot = snap.data;
                        // for (var doc in querySnapshot.docs) {
                        //   Map<String, dynamic> data =
                        //       doc.data() as Map<String, dynamic>;
                        //   tasks.add(TaskModel.fromJson(data));
                        // }

                        // return ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemCount: tasks.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return ItemTaskWidget(
                        //       taskModel: tasks[index],
                        //     );
                        //   },
                        // );
                      }
                      return const Text("hi");
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),

      // body: StreamBuilder(
      //   stream: tasksReference.snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return const Text('Something went wrong');
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

      //     return ListView(
      //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //         Map<String, dynamic> data =
      //             document.data() as Map<String, dynamic>;
      //         return ListTile(
      //           title: Text(data['descripcion']),
      //           subtitle: Text(data['status'].toString()),
      //         );
      //       }).toList(),
      //     );
      //   },
      // ),
    );
  }
}


//Example 

     // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       ElevatedButton(
      //         onPressed: () {
      //           print(tasksReference.id);
      //           tasksReference.get().then((QuerySnapshot querySnapshot) {
      //             // List<QueryDocumentSnapshot> docs = querySnapshot.docs;
      //             // QueryDocumentSnapshot doc = docs[0];
      //             // print(doc.data());
      //             // print(doc.id);

      //             for (var doc in querySnapshot.docs) {
      //               Map<String, dynamic> data =
      //                   doc.data() as Map<String, dynamic>;
      //               print(data["descripcion"]);
      //               print(doc.id);
      //             }
      //           });
      //         },
      //         child: const Text('Get tasks'),
      //       ),
      //       ElevatedButton(
      //           onPressed: () {
      //             tasksReference
      //                 .add({
      //                   'descripcion': 'Tarea 3',
      //                   'status': true,
      //                 })
      //                 .then(
      //                   (value) => ScaffoldMessenger.of(context).showSnackBar(
      //                     const SnackBar(
      //                       content: Text('Tarea agregada'),
      //                     ),
      //                   ),
      //                 )
      //                 .catchError((error) {
      //                   print('Error: $error');
      //                 })
      //                 .whenComplete(
      //                     () => print('Se ha completado la operación'));
      //           },
      //           child: const Text('add task')),
      //       ElevatedButton(
      //           onPressed: () {
      //             tasksReference.doc('pJRML9KzMa0iGEApvbNc').update({
      //               'descripcion': 'HACER EJERCICIO EN EL TECHO',
      //               'status': true,
      //             });
      //           },
      //           child: const Text('update task')),
      //       ElevatedButton(
      //           onPressed: () {
      //             tasksReference.doc('pJRML9KzMa0iGEApvbNc').delete();
      //           },
      //           child: const Text('delete task')),
      //       ElevatedButton(
      //           onPressed: () {
      //             tasksReference
      //                 .doc('A0001')
      //                 .set({
      //                   'descripcion': 'HACER EJERCICIO EN EL TECHO',
      //                   'status': true,
      //                 })
      //                 .then((value) => {
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //                         const SnackBar(
      //                           content: Text('Tarea agregada'),
      //                         ),
      //                       )
      //                     })
      //                 .catchError((error) {
      //                   print('Error: $error');
      //                 })
      //                 .whenComplete(
      //                     () => print('Se ha completado la operación'));
      //           },
      //           child: const Text('Add task custom')),
      //     ],
      //   ),
      // ),