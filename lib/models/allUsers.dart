import 'package:firebase_database/firebase_database.dart';

class Users {
  String id;
  String email;
  String name;
  String phone;

  Users({this.id, this.email, this.name, this.phone});

  factory Users.fromSnapshot(Map<String, dynamic> data) {
    return Users(
        id: data['id'],
        email: data['email'],
        name: data['name'],
        phone: data['phone']);
  }

  // Users.fromSnapshot(DatabaseEvent dataSnapshot) {
  //   // id = dataSnapshot .key;
  //   // // email = dataSnapshot.value["email"];
  //   // email = dataSnapshot.priority["email"];
  //   // name = dataSnapshot.value["name"];
  //   // phone = dataSnapshot.value["phone"];

  //   id = dataSnapshot.snapshot.key;
  //   id = dataSnapshot.snapshot.value;
  //   email = dataSnapshot.snapshot.value;
  //   name = dataSnapshot.snapshot.value;
  //   phone = dataSnapshot.snapshot.value;
  // }
}
