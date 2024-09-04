class ContactModel {
  final int codigo;
  final String nombre;
  final String? nombres;
  final String apellidoPaterno;
  final String? apellidoMaterno;
  final String? codTipoDocumento;
  final String? tipoDocumento;
  final String? numeroDocumento;
  final String? genero;
  final String? correo;
  final int cuenta;
  final String? cuentaDescripcion;
  final String? redAsistencial;
  final String? codArea;
  final String? area;
  final String? codTipoArea;
  final String? tipoArea;
  final String? codCargo;
  final String? cargo;
  final String? celular;
  final DateTime? cumpleanios;
  final String? notas;
  final String estado;

  ContactModel({
    required this.codigo,
    required this.nombre,
    this.nombres,
    required this.apellidoPaterno,
    this.apellidoMaterno,
    this.codTipoDocumento,
    this.tipoDocumento,
    required this.numeroDocumento,
    required this.genero,
    required this.correo,
    required this.cuenta,
    this.cuentaDescripcion,
    this.redAsistencial,
    required this.codArea,
     this.area,
    required this.codTipoArea,
     this.tipoArea,
    required this.codCargo,
     this.cargo,
     this.celular,
     this.cumpleanios,
     this.notas,
    required this.estado,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      codigo: json['codigo'],
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      codTipoDocumento: json['codTipoDocumento'],
      tipoDocumento: json['tipoDocumento'] ?? '',
      numeroDocumento: json['numeroDocumento'] ?? '',
      genero: json['genero'] ?? '',
      correo: json['correo'] ?? '',
      cuenta: json['cuenta'],
      cuentaDescripcion: json['cuentaDescripcion'] ?? '',
      redAsistencial: json['redAsistencial'] ?? '',
      codArea: json['codArea'] ?? '',
      area: json['area'] ?? '',
      codTipoArea: json['codTipoArea'] ?? '',
      tipoArea: json['tipoArea'] ?? '',
      codCargo: json['codCargo'] ?? '',
      cargo: json['cargo'] ?? '',
      celular: json['celular'] ?? '',
      cumpleanios: json['cumpleanios'], 
      notas: json['notas'] ?? '',
      estado: json['estado'] ?? '',
    );
  }
}
