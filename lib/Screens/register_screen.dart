import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jabber/Screens/Home.dart';
import 'package:jabber/Screens/Login_screen.dart';
import 'package:jabber/Screens/Profile.dart';
import 'package:jabber/auth/auth.dart';
import 'package:jabber/main.dart';
import 'package:jabber/widgets/progressIndicator.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "RegisterScreen";
  Auth registerAuth = Auth();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          TextButton.icon(
            label: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(Icons.login, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.idScreen, (route) => false);
            },
          )
        ],
        title: Text("Register Rider", style: TextStyle(color: Colors.white)),
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
                              prefixIcon: Icon(Icons.person),
                              hintText: "name",
                              border: OutlineInputBorder()),
                          controller: userNameTextEditingController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              hintText: "email",
                              border: OutlineInputBorder()),
                          controller: emailTextEditingController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              hintText: "phone",
                              border: OutlineInputBorder()),
                          controller: phoneTextEditingController,
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
                            if (userNameTextEditingController.text.length < 3) {
                              displayToastMessage(
                                  "User Name must atleast 4 charectors long",
                                  context);
                            } else if (!emailTextEditingController.text
                                .contains("@")) {
                              displayToastMessage(
                                  "Invalid Email Address", context);
                            } else if (phoneTextEditingController.text.length <=
                                    10 &&
                                phoneTextEditingController.text.isEmpty) {
                              displayToastMessage(
                                  "Invalid Phone Number, number has to have 10 digits",
                                  context);
                            } else if (passwordTextEditingController
                                        .text.length <=
                                    8 &&
                                passwordTextEditingController.text.isEmpty) {
                              displayToastMessage(
                                  "Password must have 8 or more charactors ",
                                  context);
                            } else {
                              registerRequest(context);
                            }
                          },
                          child: Text(
                            "Sign up",
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
  registerRequest(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressIndi(
              message: "Please wait, Registering new rider",
            ));
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((err) {
      Navigator.pop(context);
      displayToastMessage("Error: ${err.toString()}", context);
    }))
        .user;

    if (firebaseUser != null) {
      //Save user info to database
      Map userDataMap = {
        "name": userNameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage(
          "Congartulations ${userNameTextEditingController.text}, you are now a rider",
          context);

      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.idScreen, (route) => false);
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ProfileScreen(
      //               displayName: userNameTextEditingController.text,
      //             )),
      //     (route) => false);
    } else {
      //error occured - display error Msg
      Navigator.pop(context);
      displayToastMessage("Rider has not been created", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  // registerRider(BuildContext context, String email, String password) async {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => ProgressIndi(
  //             message: "Registering new rider, Please wait...",
  //           ));
  //   var regNewUser =
  //       await registerAuth.signUpWithEmailAndPassword(email, password);
  //   User user = regNewUser;
  //   return user;
  // }
}
