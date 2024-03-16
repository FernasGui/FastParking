import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastparking/dialogoUtil.dart';
import 'package:fastparking/ecraPrincipal/customButton.dart';
import 'package:fastparking/ecraPrincipal/menuPrincipal.dart';
import 'package:fastparking/estacionamento/gestaoEstacionamento.dart';
import 'package:fastparking/informacoes/info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  double saldo = 0.0;
  bool markersEnabled = false;
  bool _showQrCode = false; // Adicionado para controlar a visibilidade do QR Code

   final List<Map<String, dynamic>> veiculos = [];
  StreamSubscription<DocumentSnapshot>? matriculasSubscription;

//Barra inferior
  void _onItemTapped(int index) {
    if (index == 2) {
      if (saldo > 0.0) {
        setState(() {
          _showQrCode = !_showQrCode;
        });
    } else {
      // Aqui chamamos a função exibirJanelaInformativa
      DialogoUtil.exibirJanelaInformativa(
        context, 'Saldo Insuficiente',
        ' Confirma que tens saldo positivo antes de entrar no parque.',
      );
    }
  }  else {
      setState(() {
        _selectedIndex = index;
        _showQrCode = false; // Esconder o QR Code se outro índice for selecionado.
      });
    }

    if (index == 3) { // Se o índice for 3
      if (!markersEnabled) { // Se os marcadores não estão habilitados
        _addPredefinedMarkers();
        markersEnabled = true;
      } else { // Se os marcadores estão habilitados
        removePredefinedMarkers();
        markersEnabled = false;
      }
    }

    if (index == 0) { // Assumindo que o ícone do carro é o primeiro item
    final estacionamentoManager = EstacionamentoManager(context);
    estacionamentoManager.mostrarDetalhesEstacionamento();
  }

    if (index == 4){
       Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InfoPage(),
              ));
    }
    // Adicione mais condições if-else para outros ícones se necessário
  }
  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyAlTFic1JbjdtOJj1_oz-igg8DwqFQXeX4");
    _determinePosition();
    _iniciarListenerMatriculas();
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
          'Permissões de localização permanentemente recusadas, ative as permissões de localização.');
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

    if (user == null) {
      return Center(child: Text('Usuário não está logado.'));
    }

    // Aqui você pode adicionar mais dados se necessário
    final agora = DateTime.now();

// Formata a data no formato 'yyyy-MM-dd'.
final data = DateFormat('yyyy-MM-dd').format(agora);

// Formata a hora no formato 'HH:mm'.
final hora = DateFormat('HH:mm').format(agora);

final dadosQRCode = {
  'userId': user.uid,
  'Data': data,
  'Hora': hora,
  
};

    final String dadosCodificados = jsonEncode(dadosQRCode);

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
    body:  Stack(
        children: <Widget>[
    Column(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: userSaldoStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
               saldo = data['saldo'] ?? 0.0;
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
         if (_showQrCode ) ...[
          
           _buildOverlay(),
            _buildQrCode(dadosCodificados),
         ], // O QR Code só será mostrado quando _showQrCode for true
            
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
      bottomNavigationBar: 
      
      BottomNavigationBar(
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

  void _iniciarListenerMatriculas() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      matriculasSubscription = FirebaseFirestore.instance
          .collection('Matriculas')
          .doc(user.uid)
          .snapshots()
          .listen((docSnapshot) {
        if (docSnapshot.exists) {
          Map<String, dynamic> data = docSnapshot.data()!;
          if (data['veiculos'] != null) {
            setState(() {
              veiculos.clear();
              veiculos.addAll(List<Map<String, dynamic>>.from(data['veiculos']));
            });
          }
        }
      });
    }
  }

void _mostrarSelecaoMatricula() {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        child: Wrap(
          children: veiculos.map((veiculo) {
            return ListTile(
              title: Text(veiculo['matricula']), // Assumindo que cada veículo tem uma chave 'matricula'
              onTap: () {
                // Atualiza a matrícula selecionada para o QR Code
                _atualizarDadosQrCode(veiculo['matricula']);
                Navigator.of(context).pop(); // Fecha o modal após a seleção
              },
            );
          }).toList(),
        ),
      );
    },
  );
}

void _atualizarDadosQrCode(String matriculaSelecionada) {
  setState(() {
    // Atualizar os dados do QR Code aqui
    final dadosQRCode = {
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'Data': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'Hora': DateFormat('HH:mm').format(DateTime.now()),
      'Matricula': matriculaSelecionada,
    };

    // Codifica os novos dados em uma string JSON
    final String dadosCodificados = jsonEncode(dadosQRCode);

  });
}


//QR Code
   Widget _buildOverlay() {
    // Constrói o fundo escuro quando o QR Code é exibido.
    return Container(
      color: Colors.black.withOpacity(0.5),
    );
  }

  Widget _buildQrCode(String dadosCodificados) {
    // Constrói o widget do QR Code.
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.70,
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20.0,
              spreadRadius: 15.0,
            ),
          ],
        ),
        child: QrImageView(
          data: dadosCodificados,
          version: QrVersions.auto,
          size: 150.0,
        ),
      ),
    );
  }
}