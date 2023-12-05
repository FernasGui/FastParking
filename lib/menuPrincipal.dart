import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastparking/gestaoMatricula.dart';
import 'package:fastparking/registarEstacionamento';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fastparking/gestaoPagamento.dart';
import 'package:fastparking/loginPage.dart';

class MenuPrincipal extends StatefulWidget {
  MenuPrincipal({Key? key}) : super(key: key);

  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName = 'Usuário Anônimo';
  String _userEmail = 'No Email';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

 void _getUserInfo() async {
  User? user = _auth.currentUser;
  if (user != null) {
    // Busca o documento do usuário na coleção 'Users' pelo UID
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

    // Verifica se o documento existe e possui dados
    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      // Atualiza a UI com o nome e o email do usuário
      setState(() {
        _userName = userData?['nome'] ?? 'Usuário Anônimo'; // Substitua 'name' pela chave real usada para o nome na Firestore
        _userEmail = user.email ?? 'No Email';
      });
    }
  }
}

  void _logout() async {
    await _auth.signOut(); // Efetua o logout no Firebase
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Redireciona para a tela de login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF69285f),
            ),
            accountName: Text(_userName),
            accountEmail: Text(_userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _userName.isNotEmpty ? _userName[0] : "U",
                style: TextStyle(fontSize: 40.0, color: Color.fromRGBO(221, 67, 106, 1),
              ),
            ),
          ), ),
          _buildDrawerItem(
            icon: Icons.account_balance_wallet,
            text: 'Gestão de saldo',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GestaoPagamento(),
              ));
            },
          ),
           _buildDrawerItem(
            icon: Icons.location_on,
            text: 'Localização',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegistarEstacionamento(),
              ));
            },
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'Histórico',
            onTap: () {
              // Ação para Histórico
            },
          ),
          _buildDrawerItem(
            icon: Icons.drive_eta,
            text: 'Gestão de matrículas',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GestaoMatricula()));
            },
          ),
          _buildDrawerItem(
            icon: Icons.star,
            text: 'Premium',
            onTap: () {
              // Ação para Premium
            },
          ),
          _buildDrawerItem(
            icon: Icons.local_offer,
            text: 'Ofertas',
            onTap: () {
              // Ação para Ofertas
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Definições',
            onTap: () {
              // Ação para Definições
            },
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
