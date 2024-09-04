class AccountsModel {
  final int codCliente;
  final String tipoDocumento;
  final String documento;
  final String razonSocial;
  final String tipoCliente;
  final int codVendedor;
  final String vendedor;
  final String promotor;
  final String? redAsistencial;

  AccountsModel({
    required this.codCliente,
    required this.tipoDocumento,
    required this.documento,
    required this.razonSocial,
    required this.tipoCliente,
    required this.codVendedor,
    required this.vendedor,
    required this.promotor,
    required this.redAsistencial
  });

  factory AccountsModel.fromJson(Map<String, dynamic> json) {
    return AccountsModel(
      codCliente: json['codCliente'],
      tipoDocumento: json['tipoDocumento'],
      documento: json['documento'],
      razonSocial: json['razonSocial'],
      tipoCliente: json['tipoCliente'],
      codVendedor: json['codVendedor'],
      vendedor: json['vendedor'],
      promotor: json['promotor'],
      redAsistencial: json['redAsistencial']
    );
  }
}
