import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jabber/Screens/Home.dart';
import 'package:jabber/auth/help.dart';
import 'package:jabber/main.dart';
import 'package:jabber/models/allUsers.dart';

class ProfileScreen extends StatefulWidget {
  static const String idScreen = "ProfileScreen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<Users> userList = [];

  Future getUserDetails() async {
    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child("users/${fireAuth.currentUser.uid}");

    final snapshot = await usersRef.get();
    if (snapshot.exists) {
      print(snapshot.value);

      Map snapMap = snapshot.value;
      userList = snapMap.entries
          .map((e) =>
              Users(id: e.value, email: e.value, name: e.value, phone: e.value))
          .toList();

      // snapMap.forEach((key, value) {
      //   userList.add(Users(id: value, email: value, name: value, phone: value));
      // });
      print(userList.length);
      setState(() {});
    } else {
      print('No data available.');
    }
    return snapshot.value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text("Edit Profile",
              style: GoogleFonts.domine(
                  fontSize: 23, fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 15),
            CircleAvatar(
              // maxRadius: 150,
              radius: 75,
              // minRadius: 100,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, size: 55),
            ),
            Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("us:", style: GoogleFonts.domine(fontSize: 18)),
                    textField(
                        controller: displayNameController,
                        hint: userList.isNotEmpty
                            ? userList.elementAt(1).name.toString()
                            : "User Name"),
                    Text("Email:", style: GoogleFonts.domine(fontSize: 18)),
                    textField(
                        controller: emailController,
                        hint: fireAuth.currentUser.email),
                    SizedBox(height: 15),
                    ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.only(top: 15, bottom: 15)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () async {
                          Map userMap = {
                            "name": displayNameController.text.trim(),
                            "email": emailController.text.trim()
                          };
                          await usersRef
                              .child(fireAuth.currentUser.uid)
                              .set(userMap)
                              .whenComplete(() => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      HomeScreen.idScreen, (route) => false));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            Text("Save",
                                style: GoogleFonts.domine(fontSize: 18))
                          ],
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget textField({TextEditingController controller, String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusColor: Colors.black,
        hintText: hint,
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
    );
  }
}
