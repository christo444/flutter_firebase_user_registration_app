// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_5/Core/core.dart';
import 'package:firebase_app_5/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> addUser(UserModel u)async{
  try {
    final UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: u.userEmail, 
      password: u.userPassword);
      if (userCredential!=null){
        final firebaseInstance=FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
          'user_name':u.userName,
          'user_email':u.userEmail,
          'user_gender':u.userGender,
          'user_addres':u.userAddress
        });
        return Future.value(true);
      }
      else{
        return Future.value(false);

      }
  } catch (e) {
     return Future.value(false);
    
  }
}

Future<bool> checkLogIn(UserModel u)async{
  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: u.userEmail, 
      password: u.userPassword);

      if (userCredential!=null){
        currentUser = userCredential.user!.uid;
        return Future.value(true);

      }
      else{
        return Future.value(false);
      }
  } catch (e) {
     return Future.value(false);
  }
}

Future<UserModel> loadUser()async{
  final firebaseInstance = await FirebaseFirestore.instance.collection("users").doc(currentUser).get();
  final userData=firebaseInstance.data();
  UserModel u =UserModel(
    currentUser, 
    userData!['user_name'], 
    userData['user_email'], 
    "", 
    userData['user_gender'], 
    userData['user_addres']
    );
    return Future.value(u);
}

Future<bool> editUser(UserModel u) async {
  try {
    await FirebaseFirestore.instance.collection("users").doc(currentUser).update({
      'user_name': u.userName,
      'user_email': u.userEmail,
      'user_gender': u.userGender,
      'user_addres': u.userAddress,
    });
    return Future.value(true);
  } catch (e) {
    return Future.value(false);
  }
}
