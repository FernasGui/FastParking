import 'package:fastparking/menuPrincipal.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // GlobalKey para o Scaffold
  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("SUA_API_KEY");
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
      key: _scaffoldKey, // Atribuir o GlobalKey ao Scaffold
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Pesquisar localizações',
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search),
          ),
          onSubmitted: (String value) async {
            // ... seu código de pesquisa
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Usar o GlobalKey para abrir o Drawer
          },
        ),
      ),
      drawer: Drawer(
        child: MenuPrincipal(), // Certifique-se de que este é o nome correto da classe do seu menu
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
      floatingActionButtonLocation: FloatingActionButtonLocationCustom(
        FloatingActionButtonLocation.endFloat, // ou outra posição que você estiver usando
        84.0, // 3 cm em pixels. Pode precisar ajustar baseado na densidade de pixels do dispositivo.
      ),
      bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed, // Isso mantém os ícones centrados se você tiver mais de três itens
  items: [
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Image.asset('imagens/carro.png', width: 45, height: 45), // Tamanho ajustado para os ícones
      ),
      label: 'Carro',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Image.asset('imagens/mensagem.png', width: 45, height: 45), // Tamanho ajustado para os ícones
      ),
      label: 'Transporte',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Image.asset('imagens/qrcode.png', width: 60, height: 60), // Tamanho ajustado para os ícones
      ),
      label: 'QR Code',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Image.asset('imagens/Parque.png', width: 45, height: 45), // Tamanho ajustado para os ícones
      ),
      label: 'Parque',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0), // Ajuste este valor conforme necessário
        child: Image.asset('imagens/informação.png', width: 45, height: 45), // Tamanho ajustado para os ícones
      ),
      label: 'Informação',
    ),
  ],
  // Implementar a lógica de navegação
),

    );
  }
}
class FloatingActionButtonLocationCustom extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetY; // Offset negativo para subir o botão

  const FloatingActionButtonLocationCustom(this.location, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Obtém o Offset padrão para a localização dada
    final Offset standardOffset = location.getOffset(scaffoldGeometry);
    // Retorna um novo Offset, ajustando o Y com o valor negativo de offsetY
    return Offset(standardOffset.dx, standardOffset.dy - offsetY);
  }
}