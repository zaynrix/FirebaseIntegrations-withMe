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
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
      print("In log;");
      //yahya.m.abunada@gmail.com
      //123456789
      userCredential = await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      setState(() {});
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(hintText: "Email"),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return "Write your Email";
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: password,
                decoration: const InputDecoration(hintText: "Password"),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return "Write Password";
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    print("Validate");
                    login();
                  }
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  logout();
                },
                child: const Text("LOGOUT"),
              ),
              TextButton(
                onPressed: () {
                  sendEmail();
                },
                child: const Text("Send Verifications Code"),
              ),
              Text("Is LoggedIn $isLogin"),
              const SizedBox(
                height: 20,
              ),
              Text("Hello ${auth.currentUser?.email}"),
            ],
          ),
        ),
      ),
    );
  }
}
