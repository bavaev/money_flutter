import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:personal_accounting/business/models/category.dart';
import 'package:personal_accounting/business/models/user.dart';

class RepositoryFirestore {
  final _authentificated = StreamController<UserApp?>();
  final _data = StreamController<List<Category>>();
  late String? userId;
  bool isLoading = false;

  final List<Category> _cache = <Category>[];

  Sink get _inAuth => _authentificated.sink;
  Stream<UserApp?> get authStateStream => _authentificated.stream;

  Sink get _inData => _data.sink;
  Stream<List<Category>> get dataStateStream => _data.stream;

  Future<String?> registration(String email, String password) async {
    if (email == 'test' || password == 'test') {
      return 'test successful!';
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    }
  }

  Future<String?> login(String email, String password) async {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser!.email;
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'email not found';
        } else if (e.code == 'wrong-password') {
          return 'wrong password';
        }
      }
    }
  }

  void auth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _inAuth.add(UserApp(id: user.uid, email: user.email));
        userId = user.uid;
      }
    });
  }

  String? getAvatar() {
    return FirebaseAuth.instance.currentUser!.photoURL;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    userId = null;
    dispose();
  }

  void data() async {
    await Firebase.initializeApp();
    if (userId != null) {
      FirebaseFirestore.instance.collection('accounting').where('owner', isEqualTo: userId).snapshots().listen((techniques) {
        _cache.clear();
        techniques.docs.forEach((category) {
          _cache.add(Category(
            id: category.id,
            category: category['category'],
            color: category['color'],
            expense: category['expense'],
            owner: category['owner'],
          ));
        });
        _inData.add(_cache);
      });
    }
  }

  void add(Category category) {
    FirebaseFirestore.instance.collection('accounting').add({
      'category': category.category,
      'color': category.color,
      'owner': category.owner,
      'expense': category.expense,
    });
  }

  void update(Category category) {
    if (category.owner != null) {
      FirebaseFirestore.instance.collection('accounting').doc(category.id).update({
        'category': category.category,
        'color': category.color,
        'owner': category.owner,
        'expense': category.expense,
      });
    }
  }

  void remove(String id) async {
    FirebaseFirestore.instance.collection('accounting').doc(id).delete();
  }

  Future deleteAllData() async {
    await FirebaseFirestore.instance.collection('accounting').where('owner', isEqualTo: userId).get().then(
          (value) => value.docs.forEach(
            (element) async {
              element.reference.delete();
            },
          ),
        );
  }

  void dispose() {
    _inAuth.close();
    _inData.close();
  }
}
