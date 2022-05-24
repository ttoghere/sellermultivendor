import 'package:flutter/material.dart';
import 'package:sellermultivendor/view/auth/widgets/login.dart';
import 'package:sellermultivendor/view/auth/widgets/sign_up.dart';
import '../shared/app_gradient.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("SellersApp"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: appGradient(),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Login",
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                text: "SignUp",
              ),
            ],
            indicatorColor: Colors.orange,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: appGradient(),
          ),
          child: TabBarView(children: [
            Login(),
            SignUp(),
          ]),
        ),
      ),
    );
  }
}
