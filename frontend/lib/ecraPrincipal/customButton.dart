import 'package:flutter/material.dart';

class FloatingActionButtonCustom extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation location;
  final double offsetX; // Offset positivo para mover o botão para a direita
  final double offsetY; // Offset negativo para subir o botão

  const FloatingActionButtonCustom(this.location , this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Obtém o Offset padrão para a localização dada
    final Offset standardOffset = location.getOffset(scaffoldGeometry);
    // Retorna um novo Offset, ajustando o Y com o valor negativo de offsetY e X com offsetX
    return Offset(standardOffset.dx + offsetX, standardOffset.dy - offsetY);
  }
}
