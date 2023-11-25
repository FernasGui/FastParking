import 'package:flutter/material.dart';
import 'package:fastparking/mapeamento.dart';

class MenuPrincipal extends StatefulWidget {
  MenuPrincipal({Key? key}) : super(key: key);
  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Guilherme Fernandes"),
            accountEmail: Text("guilhermefernandes@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "G",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.account_balance_wallet,
            text: 'Gestão de saldo',
            onTap: () {
              // Ação para Gestão de saldo
            },
          ),
          _buildDrawerItem(
            icon: Icons.location_on,
            text: 'Localização',
            onTap: () {
              // Ação para Localização
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
            text: 'Inserir matrícula',
            onTap: () {
              // Ação para Inserir matrícula
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
            onTap: () {
              // Ação para Logout
            },
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
