import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastparking/customButton.dart';
import 'package:fastparking/gestaoEstacionamento.dart';
import 'package:fastparking/menuPrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fastparking/qrcode.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  GooglePlace? googlePlace;
  List<Marker> markers = [];
  LatLng? currentUserLocation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // GlobalKey para o Scaffold
  int _selectedIndex = 0;
  bool markersEnabled= false;
  
 void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index; // Atualiza o índice selecionado
  });

  if (index == 3) { // Se o índice for 3
    if (!markersEnabled) { // Se os marcadores não estão habilitados
      _addPredefinedMarkers();
      markersEnabled = true;
    } else { // Se os marcadores estão habilitados
      removePredefinedMarkers();
      markersEnabled = false;
    }
  }

    if (index == 2) { // Se o índice do QR Code for 2
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const QrCodePage(),
      ));
    }

    if (index == 0) { // Assumindo que o ícone do carro é o primeiro item
    final estacionamentoManager = EstacionamentoManager(context);
    estacionamentoManager.mostrarDetalhesEstacionamento();
  }
    // Adicione mais condições if-else para outros ícones se necessário
  }
  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyAlTFic1JbjdtOJj1_oz-igg8DwqFQXeX4");
    _determinePosition();
  }

   void _addMarkerAtPosition(LatLng position, String markerId, String title, String snippet) {
  final marker = Marker(
    markerId: MarkerId(markerId),
    position: position,
    infoWindow: InfoWindow(title: title, snippet: snippet),
  );

  setState(() {
    markers.add(marker);
  });
}
void removePredefinedMarkers() {
  setState(() {
    markers.clear();
  });
}

  void _addPredefinedMarkers() {
  // Adicionar um marcador no Google Plex, por exemplo
  _addMarkerAtPosition(
    const LatLng(38.750623, -9.155030),
    'parque_cidadeUniversitaria',
    'Parque Estacionamento Cidade Universitária ',
    'Lotação: 400/400',
  );

      _addMarkerAtPosition(
      const LatLng(38.7502099, -9.1594531),
      'parque_estadioUniversitario',
      'Parque Estacionamento Saba Estádio Universitário',
      'Lotação: 172/200',
    );

    _addMarkerAtPosition(
      const LatLng(38.7559056, -9.1514876),
      'parque_campoGrande',
      'Parque Estacionamento Campo Grande ',
      'Lotação: 65/150',
    );
  }

  Stream<DocumentSnapshot> getUserSaldoStream() {
  User? user = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance.collection('Users').doc(user?.uid).snapshots();
}



  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar se o serviço de localização está ativado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Se não estiver ativado, solicite ao usuário para ativar.
      return Future.error('Serviços de localização desativados. Por favor ative para continuar.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissões negadas
        return Future.error('Permissões de localização recusadas');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissões negadas permanentemente
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // Quando temos permissão, obtemos a localização atual do usuário
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentUserLocation = LatLng(position.latitude, position.longitude);
      _moveCameraToUserLocation();
    });
  }

  void _moveCameraToUserLocation() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentUserLocation!,
          zoom: 14.0,
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _moveCameraToUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Stream<DocumentSnapshot> userSaldoStream = FirebaseFirestore.instance.collection('Users').doc(user?.uid).snapshots();

   return Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: TextField(
        decoration: InputDecoration(
          hintText: 'Pesquisar localizações',
          border: InputBorder.none,
          suffixIcon: Icon(Icons.search),
        ),
        onSubmitted: (value) async {
                  var result = await googlePlace!.search.getTextSearch(value);
                  if (result != null && result.results != null && mounted) {
                    setState(() {
                      markers.clear();
                      for (var place in result.results!) {
                        if (place.geometry != null && place.geometry!.location != null) {
                          markers.add(
                            Marker(
                              markerId: MarkerId(place.placeId!),
                              position: LatLng(
                                place.geometry!.location!.lat!,
                                place.geometry!.location!.lng!,
                              ),
                              infoWindow: InfoWindow(title: place.name),
                            ),
                          );
                        }
                      }
                    });
                  }
               },
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    ),
    drawer: Drawer(
      child: MenuPrincipal(), // Substitua pelo seu menu principal
    ),
    body: Column(
      children: [
        if (user != null)
          StreamBuilder<DocumentSnapshot>(
            stream: userSaldoStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                double saldo = data['saldo'] ?? 0.0;
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  margin: EdgeInsets.only(bottom: 8), // Distância do visor para o mapa
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)],
                  ),
                  child: Text(
                    'Saldo: ${saldo.toStringAsFixed(2)}€',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        Expanded(
          child: GoogleMap(
            onMapCreated: onMapCreated,
            markers: Set.from(markers),
            initialCameraPosition: CameraPosition(
              target: currentUserLocation ?? LatLng(38.7478, -9.1534), // Localização inicial
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // Desativa o botão de retorno à localização atual
            
          ),
        ),
      ],
    ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.place),
        backgroundColor: const Color.fromRGBO(163, 53, 101, 1), // Cor de fundo do botão
        foregroundColor: Colors.white,
        onPressed: () {
           _moveCameraToUserLocation();
        },
      ),
      floatingActionButtonLocation: const FloatingActionButtonCustom(
        FloatingActionButtonLocation.endFloat, 
        10.0,
        88.0,  // 3 cm em pixels. Pode precisar ajustar baseado na densidade de pixels do dispositivo.
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Usa a variável _selectedIndex
        onTap: _onItemTapped, // Define o método _onItemTapped
        items:  [
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Icon(Icons.directions_car_filled_sharp,  size: 50, color:Color.fromRGBO(163, 53, 101, 1))
        //Image.asset('imagens/carro.png', width: 45, height: 45), // Tamanho ajustado para os ícones
      ),
      label: 'Carro',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Image.asset('imagens/Chat.png', width: 50, height: 50), // Tamanho ajustado para os ícones
      ),
      label: 'Chat', 
    ),
    BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Icon(Icons.qr_code_scanner_rounded,  size: 65, color:Color.fromRGBO(163, 53, 101, 1))
            ),
            label: 'QR Code',
          ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Image.asset('imagens/Parking.png', width: 50, height: 50), // Tamanho ajustado para os ícones
      ),
      label: 'Parque',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Icon(Icons.info,  size: 50, color:Color.fromRGBO(163, 53, 101, 1))
        //Image.asset('imagens/informação.png', width: 45, height: 45), // Tamanho ajustado para os ícones
      ),
      label: 'Informação',
    ),
  ],
  // Implementar a lógica de navegação
),

    );
  }
}
          
       


