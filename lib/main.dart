import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockpedia/screens/about.dart';
import 'package:mockpedia/screens/authenticate.dart';
import 'package:mockpedia/screens/dashboard.dart';
import 'package:mockpedia/screens/givemock.dart';
import 'package:mockpedia/screens/makemock.dart';
import 'package:mockpedia/screens/mymock.dart';
import 'package:mockpedia/screens/profile.dart';
import 'package:mockpedia/services/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mock Pedia",
      theme: ThemeData(
        primarySwatch: Constants.primaryColor(),
      ),
      // home: Dashboard(),
      home: Authenticate(),
      routes: {
        '/Authenticate': (_) => Authenticate(),
        '/Dashboard': (_) => Dashboard(),
        '/MakeMock': (_) => MakeMock(),
        '/MyMock': (_) => MyMock(),
        '/GiveMock': (_) => GiveMock(),
        '/About': (_) => About(),
        '/Profile': (_) => UserProfile(),
      },
    );
  }
}
