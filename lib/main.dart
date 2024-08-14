import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:machinetest_totalx/View/LoginScreen/LoginScreen.dart';
import 'package:machinetest_totalx/View/UserList/userlistscreen.dart';
import 'package:machinetest_totalx/firebase_options.dart';

// import 'View/UserList/UserList.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
    
      home: UserListScreen()
    );
  }
}

