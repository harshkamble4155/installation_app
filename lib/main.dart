import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installation_app/screens/adminScreen.dart';
import 'package:installation_app/screens/home_screen.dart';
import 'package:installation_app/screens/loginScreen.dart';
import 'package:installation_app/screens/newuserScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<int, Color> colorSwatch = const {
      50: Color.fromRGBO(21, 34, 56, .1),
      100: Color.fromRGBO(21, 34, 56, .2),
      200: Color.fromRGBO(21, 34, 56, .3),
      300: Color.fromRGBO(21, 34, 56, .4),
      400: Color.fromRGBO(21, 34, 56, .5),
      500: Color.fromRGBO(21, 34, 56, .6),
      600: Color.fromRGBO(21, 34, 56, .7),
      700: Color.fromRGBO(21, 34, 56, .8),
      800: Color.fromRGBO(21, 34, 56, .9),
      900: Color.fromRGBO(21, 34, 56, 1),
    };
    return MaterialApp(
      title: "Installation App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primaryColor: const Color(colorPrimary),
        // primarySwatch: MaterialColor(colorBackground, colorSwatch),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      routes: {
        '/loginScreen': (context) => const LoginScreen(),
        '/adminScreen': (context) => AdminScreen(),
        '/NewUser': (context) => NewUser(),
        '/HomeScreen': (context) => const HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') != null) {
      if (prefs.getBool("isLoggedIn")!) {
        if (prefs.getInt("Role")! == 1) {
          Future.delayed(
            const Duration(seconds: 3),
            () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (route) => false);
            },
          );
        }
        if (prefs.getInt("Role")! == 2) {
          Future.delayed(
            const Duration(seconds: 3),
            () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AdminScreen(),
                  ),
                  (route) => false);
            },
          );
        }
      } else {
        Future.delayed(
          const Duration(seconds: 3),
          () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(), // change here
                ),
                (route) => false);
          },
        );
      }
    } else {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(), // change here
              ),
              (route) => false);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
