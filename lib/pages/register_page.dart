import 'package:codigo_firetask/models/user_model.dart';
import 'package:codigo_firetask/pages/home_page.dart';
import 'package:codigo_firetask/services/firestore_service.dart';
import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:codigo_firetask/ui/widgets/button_custom_wdiget.dart';
import 'package:codigo_firetask/ui/widgets/general_widgets.dart';
import 'package:codigo_firetask/ui/widgets/textfield_normal_widget.dart';
import 'package:codigo_firetask/ui/widgets/textfield_password_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final keyForm = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController namesController = TextEditingController();

  FirestoreService userService = FirestoreService(collection: "users");

  _registerUser() async {
    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance
    //       .createUserWithEmailAndPassword(
    //           email: emailController.text, password: passwordController.text);
    //   print(userCredential);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     showSnackBarError(context, "La contraseña es muy débil");
    //   } else if (e.code == 'email-already-in-use') {
    //     showSnackBarError(context, "El correo ya está en uso");
    //   }
    // } catch (e) {
    //   print(e);
    // }
    // FocusScope.of(context).unfocus();

    if (!keyForm.currentState!.validate()) {
      return;
    }

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
        .then((value) => {
              if (value.user != null)
                {
                  userService
                      .addUser(
                        UserModel(
                          name: namesController.text,
                          email: emailController.text,
                        ),
                      )
                      .then(
                        (value) => {
                          {
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => HomePage(),
                            //   ),
                            //   (route) => false,
                            // ),
                          }
                        },
                      ),
                }
            })
        .catchError((error) => {
              if (error.code == 'weak-password')
                {
                  showSnackBarError(context, "La contraseña es muy débil"),
                }
              else if (error.code == 'email-already-in-use')
                {
                  showSnackBarError(context, "El correo ya está en uso"),
                }
            });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    namesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: keyForm,
            child: Column(
              children: [
                divider30(),
                SvgPicture.asset(
                  "assets/images/register.svg",
                  height: 180,
                ),
                divider6(),
                const Text(
                  "Crear cuenta",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                divider20(),
                TextFieldNormalWidget(
                  hintText: "Nombres y apellidos",
                  iconData: Icons.person,
                  controller: namesController,
                ),
                divider6(),
                TextFieldNormalWidget(
                  hintText: "Correo electrónico",
                  iconData: Icons.email,
                  controller: emailController,
                ),
                divider6(),
                TextFieldPasswordWidget(
                  controller: passwordController,
                ),
                divider20(),
                ButtonCustomWidget(
                  text: "Crear cuenta",
                  color: kBrandPrimaryColor,
                  iconPath: "assets/icons/check.svg",
                  onPressed: () {
                    _registerUser();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
