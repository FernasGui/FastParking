import 'package:fastparking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'beginPage.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future <void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, );
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
