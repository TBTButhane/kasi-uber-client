import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jabber/Screens/Login_screen.dart';
import 'package:jabber/Screens/Profile.dart';

import 'package:jabber/auth/help.dart';

class DrawerWidget extends StatelessWidget {
  DateTime timeOfTheDay = DateTime(DateTime.now().day);
  // showTime() {
  //   if (ti)
  // }
  @override
  Widget build(BuildContext context) {
    print(timeOfTheDay);
    return Drawer(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 100,
                  padding: EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(color: Colors.white),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Text(
                        "T",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 40.0,
                            color: Colors.white),
                      ),
                    ),
                    subtitle: Text(firebaseUser.email,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    title: Text("Good Morning",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]))),
                  )),
              Divider(),
              // GestureDetector(
              //     onTap: () {
              //       Navigator.pop(context);
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (BuildContext context) => AddPayMentScreen(
              //                 name: firebaseUser.displayName,
              //               )));
              //     },
              //     child: ListTile(
              //       leading: Icon(Icons.attach_money),
              //       title: Text("Add Payment Method",
              //           style: TextStyle(
              //               fontSize: 18, fontWeight: FontWeight.bold)),
              //     )),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Profile",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
              Divider(),
              GestureDetector(
                  child: ListTile(
                leading: Icon(Icons.directions_car),
                title: Text("Ride History",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )),
              Divider(),
              GestureDetector(
                  child: ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )),
              Divider(),
              GestureDetector(
                  child: ListTile(
                leading: Icon(Icons.info),
                title: Text("about",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )),
              Divider(),
              GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app_outlined),
                    title: Text("Log out",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            ],
          ),
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 5.5),
            child: Text("Created by HostTree",
                style: GoogleFonts.bahianita(
                    textStyle: TextStyle(color: Colors.grey, fontSize: 18))),
          )
        ],
      ),
    );
  }
}
