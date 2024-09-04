class TuitionModel {
        final String tipoCodigo;
        final String codigo;
        final String apellidoPaterno;
        final String apellidoMaterno;
        final String nombres;
        final String especialidad;

  TuitionModel({
    required this.tipoCodigo,
    required this.codigo,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.nombres,
    required this.especialidad,
  });

  factory TuitionModel.fromJson(Map<String, dynamic> json) {
    return TuitionModel(
      tipoCodigo: json['tipoCodigo'] ?? '',
      codigo: json['codigo'] ?? '',
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      nombres: json['nombres'] ?? '',
      especialidad: json['especialidad'] ?? '',
    );
  }
}
