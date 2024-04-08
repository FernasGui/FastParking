import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SwipablePhotoCarousel extends StatelessWidget {
  final List<String> imagePaths;

  SwipablePhotoCarousel({required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    // Usando MediaQuery para obter as dimensões da tela
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return CarouselSlider.builder(
      itemCount: imagePaths.length,
      options: CarouselOptions(
        autoPlay: false,
        // Configura a altura do carrossel para usar toda a altura disponível
        // menos algum espaço para evitar a sobreposição com outros elementos como a AppBar
        height: screenHeight * 0.90, // Ajuste este valor conforme necessário
        enlargeCenterPage: true,
        viewportFraction: 0.90,
        aspectRatio: screenWidth / (screenHeight * 0.80),
        initialPage: 1,
      ),
      itemBuilder: (context, index, realIdx) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Image.asset(
            imagePaths[index],
            fit: BoxFit.contain, // Usa BoxFit.contain para evitar cortar a imagem
          ),
        );
      },
    );
  }
}
