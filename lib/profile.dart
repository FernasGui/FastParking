import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
   Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {
  // ... your existing code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... your existing Scaffold code
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Michael A. Bogue"),
              accountEmail: Text("MichaelBogue@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "M",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Gestão de saldo'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Localização'),
              onTap: () {
                // Update the state of the app
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Definições'),
              onTap: () {
                // Update the state of the app
                // ...
                Navigator.pop(context);
              },
            ),
            // ... add the other items
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle user logout
                // ...
              },
            ),
          ],
        ),
      ),
      // ... the rest of your Scaffold code
    );
  }
  
  // ... the rest of your _MapScreenState code
}