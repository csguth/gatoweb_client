import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  User? user;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    user = credential.user;
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> register(String email, String password, String displayName) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(displayName);
    // Directly set user profile in Firestore
    await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      'displayName': displayName,
      'email': email,
    });
    user = credential.user;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data();
  }
}