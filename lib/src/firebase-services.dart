import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import './models/user.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase().reference();

  Future<FirebaseUser> registerUserUsingEmainAndPassword(
      String email, String password, String firstName, String lastName) async {
    FirebaseUser user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ));

      print('User with $email created!');
    } catch (e) {
      print(e.toString());
    } finally {
      if (user != null) {
        //User Cerested
        User userObj = User(
          id: user.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          imageUrl: 'default',
        );
        _database.child('Users').child(user.uid).set(userObj.UserToMap());
      } else {
        Fluttertoast.showToast(
          msg: 'Some error occured, please try again!',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
    return user;
  }
}
