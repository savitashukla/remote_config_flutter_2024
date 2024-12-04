import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyALazV2i3SrYKLEYEKajp5aR3issYZ5t0U",
          appId: "1:911153864978:android:75b0411e1ceed30a3f13cb",
          messagingSenderId: "911153864978",
          projectId: "remoteconfigflutter-977f0"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

