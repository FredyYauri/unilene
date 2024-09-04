class OptionModel{
  final String codigo;
  final String descripcion;
  final String auxiliar;


  OptionModel({
    required this.codigo,
    required this.descripcion,
    required this.auxiliar,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      auxiliar: json['auxiliar'] ?? '',
      );
  }
}