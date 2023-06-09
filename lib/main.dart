import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucy_assistance/controllers/auth_controller.dart';
import 'package:lucy_assistance/controllers/user_controller.dart';
import 'package:lucy_assistance/views/gps/position_page.dart';
import 'package:lucy_assistance/views/launch_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
        value: AuthController().user,
        initialData: null,
        child: MaterialApp(
          title: 'GPS Mobile by TAPS',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: const MyHomePage(title: 'GPS Mobile by TASP'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return const LaunchPage();
    } else {
      return StreamBuilder(
          stream: UserController().userById(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> users =
                  snapshot.data as List<QueryDocumentSnapshot>;
              if (users.length != 1) {
                UserController().setNewUser();
              }
              return const PositionPage();
            }
            return Scaffold(
              body: Container(),
            );
          });
    }
  }
}
/*
<service 
    android:name="${applicationName}"
    android:foregroundServiceType="location">
</service>*/