//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jabber/Screens/Home.dart';
import 'package:jabber/Screens/register_screen.dart';
import 'package:jabber/main.dart';
import 'package:jabber/widgets/progressIndicator.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "LoginScreen";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          TextButton.icon(
            label: Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(Icons.login, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, RegistrationScreen.idScreen, (route) => false);
            },
          )
        ],
        title: Text("Login Rider", style: TextStyle(color: Colors.white)),
        elevation: 2.0,
        shadowColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Jabber Rider',
                    //     style: GoogleFonts.fascinate(
                    //         textStyle: TextStyle(
                    //       fontSize: 25,
                    //       fontWeight: FontWeight.bold,
                    //     ))),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Image(
                        image: AssetImage("assets/jabber.png"),
                        fit: BoxFit.scaleDown),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "email",
                              border: OutlineInputBorder()),
                          controller: emailTextEditingController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "password",
                              border: OutlineInputBorder()),
                          controller: passwordTextEditingController,
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              elevation: 2.0,
                              shadowColor: Colors.black),
                          onPressed: () {
                            loginAndAuthenticateUser(context);
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressIndi(
              message: "Please wait, finding your location",
            ));
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((err) {
      Navigator.pop(context);
      displayToastMessage("Error: ${err.toString()}", context);
    }))
        .user;

    if (firebaseUser != null) {
      //Save user info to database

      usersRef.child(firebaseUser.uid).once().then((DatabaseEvent snap) {
        if (snap.snapshot != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.idScreen, (route) => false);
          displayToastMessage("Welcome, You are now Signed in", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("Couldn't find user in our records", context);
        }
      });
    } else {
      //error occured - display error Msg
      Navigator.pop(context);
      displayToastMessage("Rider has not been created", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
