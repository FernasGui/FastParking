import 'package:fastparking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'beginPage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Se estiver usando o App Check, ative-o aqui.
await FirebaseAppCheck.instance.activate();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastParking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: SplashScreen(), // Define SplashScreen como a tela inicial
      // Aqui você pode definir mais configurações do MaterialApp
    );
  }
}
