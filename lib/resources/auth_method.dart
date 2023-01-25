import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone1/model/user.dart' as model;
import 'package:instagram_clone1/resources/storage_methods.dart';

class AuthMedthod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//get snapshot of current user data
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String fullName,
    required String username,
    required String password,
    required Uint8List profilePicture,
  }) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty ||
          fullName.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty) {
        //register user
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String photoURL = await StorageMethod()
            .uploadImageToStorage('ProfilePics', profilePicture, false);

        //upload userdata to database

        model.User user = model.User(
            email: email,
            uid: credential.user!.uid,
            fullName: fullName,
            username: username,
            password: password,
            followers: [],
            followings: [],
            photoURL: photoURL);
        await _firestore.collection('users').doc(credential.user!.uid).set(
              user.toJason(),
            );
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login user

  Future<String> signinUser(
      {required String email, required String password}) async {
    String res = "some error occured";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the field";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
