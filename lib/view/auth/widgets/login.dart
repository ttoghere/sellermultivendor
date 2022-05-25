import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/global/global.dart';
import 'package:sellermultivendor/view/homeScreen/home_screen.dart';
import 'package:sellermultivendor/view/shared/error_dialog.dart';
import 'package:sellermultivendor/view/shared/loading_dialog.dart';

import '../../shared/custom_text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  formValidation() {
    if (emailControl.text.isNotEmpty && passwordControl.text.isNotEmpty) {
      //Login
      loginNow();
    } else {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          message: "Invalid email or password",
        ),
      );
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDialog(
        message: "Checking Credentials",
      ),
    );
    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailControl.text.trim(),
      password: passwordControl.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(error),
        ),
      );
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      var access = snapshot.data()!;
      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("email", access["sellerEmail"]);
      await sharedPreferences!.setString("name", access["sellerName"]);
      await sharedPreferences!.setString("photoUrl", access["sellerAvatarUrl"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "images/seller.png",
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  iconData: Icons.email,
                  textEditingController: emailControl,
                  hintText: "Email",
                  isObsecure: false,
                ),
                CustomTextField(
                  iconData: Icons.lock,
                  textEditingController: passwordControl,
                  hintText: "Password",
                  isObsecure: true,
                ),
                ElevatedButton(
                  onPressed: () {
                    formValidation();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 10,
                    ),
                    primary: Colors.black,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
