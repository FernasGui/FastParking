import 'package:fastparking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'beginPage.dart';

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
      home: SplashScreen(), // Define SplashScreen como a tela inicial
      // Aqui você pode definir mais configurações do MaterialApp
    );
  }
}


class HomeScreenStateful extends StatefulWidget {
  const HomeScreenStateful({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenStateful> {
  // Adicione variáveis e métodos para gerenciar o estado aqui

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastParking'),
      ),
      body: Center(
        child: Text(
          'Bem-vindo ao FastParking',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
