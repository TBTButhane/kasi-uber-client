import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jabber/Data/appData.dart';
import 'package:jabber/Screens/Home.dart';
import 'package:jabber/Screens/Login_screen.dart';
import 'package:jabber/Screens/Profile.dart';
import 'package:jabber/Screens/register_screen.dart';
import 'package:jabber/Screens/searchScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference rideRequestRef =
    FirebaseDatabase.instance.ref().child("Ride Requests");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppData>(
          create: (context) => AppData(),
        ),
        // ChangeNotifierProvider<CardAssistace>(
        //   create: (context) => CardAssistace(),
        // ),
      ],
      child: MaterialApp(
          title: 'Jabber Rider',
          theme: ThemeData(
            // primarySwatch: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? LoginScreen.idScreen
              : HomeScreen.idScreen,
          // initialRoute: HomeScreen.idScreen,
          routes: {
            RegistrationScreen.idScreen: (context) => RegistrationScreen(),
            SearchScreen.idScreen: (context) => SearchScreen(),
            // AddPayMentScreen.idScreen: (context) => AddPayMentScreen(),
            LoginScreen.idScreen: (context) => LoginScreen(),
            HomeScreen.idScreen: (context) => HomeScreen(),
            ProfileScreen.idScreen: (context) => ProfileScreen()
          }),
    );
  }
}
