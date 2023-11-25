import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyAlTFic1JbjdtOJj1_oz-igg8DwqFQXeX4");
     _determinePosition();
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
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: TextField(
        decoration: const InputDecoration(
          hintText: 'Pesquisar localizações',
          border: InputBorder.none,
          suffixIcon: Icon(Icons.search),
        ),
          onSubmitted: (String value) async {
          var result = await googlePlace!.search.getTextSearch(value);
          if (result != null && result.results != null && mounted) {
            setState(() {
              markers.clear();
              for (var place in result.results!) {
                if (place.geometry != null && place.geometry!.location != null) {
                  markers.add(
                    Marker(
                      markerId: MarkerId(place.placeId!),
                      
                      position: LatLng( place.geometry?.location?.lat ?? 0, place.geometry?.location?.lng ?? 0, // Usar ? após location
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
          // Implementar abertura do drawer menu
        },
      ),
    ),
    body: currentUserLocation == null
      ? Center(child: CircularProgressIndicator())
      : GoogleMap(
          onMapCreated: onMapCreated,
          markers: Set.from(markers),
          initialCameraPosition: CameraPosition(
            target: currentUserLocation ?? LatLng(0, 0), 
            zoom: 14.0,
          ),
        ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.place),
      onPressed: () {
        // Implementar adição dos marcadores personalizados
      },
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Carro'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_transit), label: 'Transporte'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_walk), label: 'Caminhada'),
        // Adicione mais itens conforme necessário
      ],
      // Implementar a lógica de navegação
    ),
    drawer: Drawer(
      // Implementar o conteúdo do menu
    ),
  );
  }
}