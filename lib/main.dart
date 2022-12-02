import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/AuthScreen.dart';
import 'package:flutter_app/screens/HomeScreen.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'screens/ProfileScreen.dart';
import 'screens/RidesScreen.dart';
import 'services/fakeDB.dart';
import 'package:flutter_app/screens/MyApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Welcome());
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
    );
  }
}
