import 'package:codigo_firetask/models/user_model.dart';
import 'package:codigo_firetask/pages/home_page.dart';
import 'package:codigo_firetask/pages/register_page.dart';
import 'package:codigo_firetask/services/firestore_service.dart';
import 'package:codigo_firetask/ui/general/colors.dart';
import 'package:codigo_firetask/ui/widgets/button_custom_wdiget.dart';
import 'package:codigo_firetask/ui/widgets/general_widgets.dart';
import 'package:codigo_firetask/ui/widgets/textfield_normal_widget.dart';
import 'package:codigo_firetask/ui/widgets/textfield_password_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final keyForm = GlobalKey<FormState>();

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  FirestoreService firestoreService = FirestoreService(collection: "users");

  _login() async {
    if (!keyForm.currentState!.validate()) {
      return;
    }
    try {
      UserCredential user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (user.user != null) {
        if (context.mounted) {
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HomePage(),
          //   ),
          //   (route) => false,
          // );
        }
      }
    } on FirebaseAuthException catch (error) {
      print("errrrrrroresss ${error.code}");
      if (error.code == 'INVALID_LOGIN_CREDENTIALS') {
        print(error);
        if (context.mounted) {
          showSnackBarError(context, "Credenciales inválidas");
        }
      } else if (error.code == 'invalid-email') {
        print(error);
        if (context.mounted) {
          showSnackBarError(context, "Correo inválido");
        }
      }
    } catch (error) {
      print(error);
    }
  }

  _loginWithGoogle() async {
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) {
      return;
    }

    GoogleSignInAuthentication authentication = await account.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      UserModel user = UserModel(
        name: userCredential.user!.displayName,
        email: userCredential.user!.email,
        urlImage: userCredential.user!.photoURL,
      );
      bool existUser = await firestoreService.existUser(user.email!);

      if (!existUser) {
        String userModel = await firestoreService.addUser(user);
        if (userModel.isNotEmpty) {
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(userModel: user),
              ),
              (route) => false,
            );
          }
        }
      } else {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(userModel: user),
            ),
            (route) => false,
          );
        }
      }
    }
  }

  _loginWithFacebook() async {
    LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      AccessToken accessToken = result.accessToken!;
      OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final userData = await FacebookAuth.instance.getUserData();

      if (userCredential.user != null) {
        UserModel user = UserModel(
          name: userCredential.user!.displayName,
          email: userCredential.user!.email,
          urlImage: userData['picture']['data']['url'],
        );
        bool existUser = await firestoreService.existUser(user.email!);

        if (!existUser) {
          String userModel = await firestoreService.addUser(user);
          if (userModel.isNotEmpty) {
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userModel: user),
                ),
                (route) => false,
              );
            }
          }
        } else {
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(userModel: user),
              ),
              (route) => false,
            );
          }
        }
      }
    }
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
                  "assets/images/login.svg",
                  height: 180,
                ),
                divider6(),
                const Text(
                  "Iniciar sesión",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                divider6(),
                TextFieldNormalWidget(
                  hintText: "Correo electrónico",
                  iconData: Icons.email,
                  controller: emailController,
                ),
                divider10(),
                TextFieldPasswordWidget(
                  controller: passwordController,
                ),
                divider6(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                divider6(),
                ButtonCustomWidget(
                  text: "Iniciar sesión",
                  color: kBrandPrimaryColor,
                  iconPath: "assets/icons/check.svg",
                  onPressed: () {
                    _login();
                  },
                ),
                divider10(),
                const Text(
                  "O inicia sesión con",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                divider10(),
                ButtonCustomWidget(
                  text: "Iniciar sesión con Google",
                  color: const Color(0xFFf84b2a),
                  iconPath: "assets/icons/google.svg",
                  onPressed: () {
                    _loginWithGoogle();
                  },
                ),
                divider6(),
                ButtonCustomWidget(
                  text: "Iniciar sesión con Facebook",
                  color: const Color(0xFF3b5998),
                  iconPath: "assets/icons/facebook.svg",
                  onPressed: () {
                    _loginWithFacebook();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿No tienes una cuenta?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Regístrate",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kBrandPrimaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
