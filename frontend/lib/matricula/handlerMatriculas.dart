class VehicleRegistration {
  final String descricao;
  final String matricula;
  final bool isPortuguese;
  final bool isElectric;

  VehicleRegistration({
    required this.descricao,
    required this.matricula,
    required this.isPortuguese,
    required this.isElectric,
  });

  Map<String, dynamic> toJson() {
    return {
      'descrição': descricao,
      'matricula': matricula,
      'matriculaPortuguesa': isPortuguese,
      'eletrico': isElectric,
    };
  }
}
