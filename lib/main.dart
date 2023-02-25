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
  User? user = FirebaseAuth.instance.currentUser;
  UserCredential? userCredential;
  bool isLogin = false;

  @override
  void initState() {
    auth.authStateChanges().listen((event) {
      if (event == null) {
        setState(() {});
        isLogin = false;
      } else {
        isLogin = true;
      }
    });
    super.initState();
  }

  login() async {
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: "yahya.m.abunada@gmail.com", password: "123456789");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint(e.code);
      } else if (e.code == 'wrong-password') {
        debugPrint(e.code);
      }
    }
  }

  sendEmail() async {
    if (!user!.emailVerified) {
      await user!.sendEmailVerification();
    }
  }

  logout() {
    auth.signOut();
    userCredential = null;
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
            },
            child: Text("LOGIN $userCredential"),
          ),
          TextButton(
            onPressed: () {
              logout();
            },
            child: const Text("LOGOUT "),
          ),
          TextButton(
            onPressed: () {
              sendEmail();
            },
            child: const Text("Send Verifications"),
          ),
          Text("Hello ${auth.currentUser?.email} $isLogin"),
        ],
      ),
    );
  }
}
