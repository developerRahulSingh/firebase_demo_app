import 'package:FirebaseDemoApp/auth/firebase_auth.dart';
import 'package:FirebaseDemoApp/notifire/todo_notifire.dart';
import 'package:FirebaseDemoApp/screens/home_screen.dart';
import 'package:FirebaseDemoApp/screens/login/login_form.dart';
import 'package:FirebaseDemoApp/widgets/curved_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseCrashlytics.instance.crash();

//  FirebaseCrashlytics.instance.setCustomKey('str_key', 'hello');
//  FirebaseCrashlytics.instance.log("Higgs-Boson detected! Bailing out");
//  FirebaseCrashlytics.instance.setUserIdentifier("12345");
//  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  runApp(MultiProvider(
    providers: [
      Provider<FirebaseAuthService>(
        create: (_) => FirebaseAuthService(FirebaseAuth.instance),
      ),
      StreamProvider(
        create: (context) =>
            context.read<FirebaseAuthService>().authStateChanges,
        initialData: null,
      )
    ],
    child: new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new MyApp(),
    ),
  ));
//  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FirebaseAuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: ChangeNotifierProvider(
        create: (context) => TodoNotifier(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return HomeScreen();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xfff2cbd0), Color(0xfff4ced9)],
        )),
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              CurvedWidget(
                child: Container(
                  padding: const EdgeInsets.only(top: 100, left: 50),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white.withOpacity(0.4)],
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xff6a515e),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 230),
                child: LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
