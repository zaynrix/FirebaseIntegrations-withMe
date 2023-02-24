import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var res;
  bool isLogin = false;
  @override
  void initState() {
    auth.authStateChanges().listen((event) {
      if (auth.currentUser == null) {
        setState(() {});
        isLogin = false;
      } else {
        isLogin = true;
      }
    });
    // TODO: implement initState
    super.initState();
  }

  UserCredential? ress;
  login() async {
    res = await auth.signInWithEmailAndPassword(
        email: "yahya@gmail.com", password: "123456789");

    setState(() {});
    ress = res;
    print("This user ${ress!.user!.email}");
  }

  logout() {
    auth.signOut();
    ress = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            login();
            // auth.signInWithCredential();
          },
          child: Text("LOGIN ${ress}"),
        ),
        TextButton(
          onPressed: () {
            logout();
            // auth.signInWithCredential();
          },
          child: Text("LOGOUT "),
        ),
        Text("Hello ${auth.currentUser?.email} $isLogin"),
      ],
    ));
  }
}
