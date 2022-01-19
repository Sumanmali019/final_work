// ignore_for_file: unnecessary_null_comparison
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location_tracker/loginscreen/initializing.dart';
import 'package:location_tracker/loginscreen/loginin.dart';
import 'package:location_tracker/screens/camera_upload.dart';
import 'package:location_tracker/screens/homepage2.dart';
import 'package:location_tracker/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currenttheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: const InitializerWidget(),
    //   theme: CustomTheme.lightTheme,
    //   darkTheme: CustomTheme.darkTheme,
    //   themeMode: currenttheme.currenttheme,
    // );
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currenttheme.currenttheme,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const InitializerWidget(),
      ),
    ),
    GoRoute(
      path: '/logout',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const Loginscreen(),
      ),
    ),
    GoRoute(
      path: '/homepage',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const Homepage(),
      ),
    ),
    GoRoute(
      path: '/camera',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: CameraUpload(),
      ),
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  ),
);
