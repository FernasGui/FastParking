import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'profile.dart'; // Certifique-se de que 'profile.dart' é o caminho correto do seu arquivo de perfil

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



  void onMapCreated(GoogleMapController controller) {
  _mapController = controller;
  _moveCameraToUserLocation();
}

  @override
  void initState() {
    super.initState();
    // Substitua 'SUA_CHAVE_API' pela sua chave da API
    googlePlace = GooglePlace("AIzaSyAlTFic1JbjdtOJj1_oz-igg8DwqFQXeX4");
    _determinePosition();
  }


  // Restante do código do método initState...

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: TextField(
        // Restante do código do AppBar...
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profile(), // Usando o nome 'Profile' para a página de perfil
          ));
        },
      ),
    ),
   body: currentUserLocation == null
  ? Center(child: const CircularProgressIndicator())
  : GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: currentUserLocation!, // Garantindo que o currentUserLocation não é nulo aqui.
        zoom: 14.0,
      ),
      markers: Set.from(markers),
      // Adicione mais propriedades conforme necessário
    ),
floatingActionButton: FloatingActionButton(
  child: Icon(Icons.place),
  onPressed: () {
    _moveCameraToUserLocation(); // Por exemplo, pode recentralizar o mapa na localização do usuário
  },
),
    bottomNavigationBar: BottomNavigationBar(
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: 'Mapa',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.directions_car),
      label: 'Carro',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.directions_transit),
      label: 'Transporte',
    ),
    // Adicione mais itens conforme necessário
  ],
  // Implementar a lógica de navegação
  onTap: (index) {
    // Aqui você pode usar o index para controlar a navegação.
  },
),

    drawer: Drawer(
      child: Profile(), // Usando o nome 'Profile' para a página de perfil
    ),
  );
  }

  void _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Verificar se o serviço de localização está ativado
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Se não estiver ativado, solicite ao usuário para ativar.
    // Aqui, você pode mostrar um diálogo ou uma mensagem pedindo que o usuário ative a localização.
    return Future.error('Serviços de localização desativados. Por favor ative para continuar.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissões negadas. Aqui também, você pode informar o usuário de forma adequada.
      return Future.error('Permissões de localização recusadas.');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissões negadas permanentemente
    // Você pode direcionar o usuário para as configurações do app para alterar manualmente as permissões.
    return Future.error('Permissões de localização negadas permanentemente. Altere nas configurações do app.');
  } 

  // Quando temos permissão, obtemos a localização atual do usuário
  try {
    Position position = await Geolocator.getCurrentPosition();
      setState(() {
      currentUserLocation = LatLng(position.latitude, position.longitude);
      _moveCameraToUserLocation();
    });
  } catch (e) {
    // Tratamento de erro caso a obtenção da localização falhe.
    return Future.error('Erro ao obter localização: $e');
  }
}

void _moveCameraToUserLocation() {
  if (currentUserLocation == null || _mapController == null) {
    // Se a localização do usuário ou o controlador do mapa não estiverem disponíveis, não faça nada.
    // Você pode mostrar um erro ou tentar novamente após um intervalo.
    return;
  }

  _mapController?.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: currentUserLocation!,
        zoom: 14.0,
      ),
    ),
  );
}
}