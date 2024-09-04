class Product {
  final String item;
  final String descripcion;
  final double stockDisponible;
  final String fechaReposicion;

  Product(
      {required this.item,
      required this.descripcion,
      required this.stockDisponible,
      required this.fechaReposicion});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      item: json['item'],
      descripcion: json['descripcion'],
      stockDisponible: json['stockDisponible'],
      fechaReposicion: json['fechaReposicion'],
    );
  }
}

class PorAgrupador {
  final int codigoAgrupador;
  final String agrupador;
  final double presupuesto;
  final double ventas;
  final double avances;

  PorAgrupador(
      {required this.codigoAgrupador,
      required this.agrupador,
      required this.presupuesto,
      required this.ventas,
      required this.avances});

  factory PorAgrupador.fromJson(Map<String, dynamic> json) {
    return PorAgrupador(
        codigoAgrupador: json['codigoAgrupador'],
        agrupador: json['agrupador'],
        presupuesto: json['presupuesto'],
        ventas: json['ventas'],
        avances: json['avances']);
  }
}

class PorTipoCliente {
  final String tipoCliente;
  final double presupuesto;
  final double ventas;
  final double avances;

  PorTipoCliente(
      {required this.tipoCliente,
      required this.presupuesto,
      required this.ventas,
      required this.avances});

  factory PorTipoCliente.fromJson(Map<String, dynamic> json) {
    return PorTipoCliente(
        tipoCliente: json['tipoCliente'],
        presupuesto: json['presupuesto'],
        ventas: json['ventas'],
        avances: json['avances']);
  }
}

class DetallePresupuesto {
  final int codigoCliente;
  final String cliente;
  final double presupuesto;
  final double ventas;
  final double avance;

  DetallePresupuesto(
      {required this.codigoCliente,
      required this.cliente,
      required this.presupuesto,
      required this.ventas,
      required this.avance});

  factory DetallePresupuesto.fromJson(Map<String, dynamic> json) {
    return DetallePresupuesto(
        codigoCliente: json['codigoCliente'],
        cliente: json['cliente'],
        presupuesto: json['presupuesto'],
        ventas: json['ventas'],
        avance: json['avance']);
  }
}

class Usuario {
  final int codigo;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String nombre;
  final String correo;
  final String celular;

  Usuario(
      {required this.codigo,
      required this.apellidoPaterno,
      required this.apellidoMaterno,
      required this.nombre,
      required this.correo,
      required this.celular});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
        codigo: json['codigo'],
        apellidoPaterno: json['apellidoPaterno'],
        apellidoMaterno: json['apellidoMaterno'],
        nombre: json['nombre'],
        correo: json['correo'],
        celular: json['celular']);
  }
}

class DetalleCotizacion {
  final String numeroDocumento;
  final String itemCodigo;
  final String descripcion;
  final int cantidadPedida;
  final double precioUnitario;
  final double monto;
  final String estado;

  DetalleCotizacion(
      {required this.numeroDocumento,
      required this.itemCodigo,
      required this.descripcion,
      required this.cantidadPedida,
      required this.precioUnitario,
      required this.monto,
      required this.estado});

  factory DetalleCotizacion.fromJson(Map<String, dynamic> json) {
    return DetalleCotizacion(
      numeroDocumento: json['numeroDocumento'],
      itemCodigo: json['itemCodigo'],
      descripcion: json['descripcion'],
      cantidadPedida: json['cantidadPedida'],
      precioUnitario: double.parse(json['precioUnitario'].toString()),
      monto: double.parse(json['monto'].toString()),
      estado: json['estado'],
    );
  }
}

class GestionCotizacion {
  final int gestionId;
  final String numeroDocumento;
  final String fechaGestion;
  final String tipoGestion;
  final String tipoCanal;
  final String tipoResultado;
  final String tipoRiesgo;
  final String tipoMotivo;

  GestionCotizacion(
      {required this.gestionId,
      required this.numeroDocumento,
      required this.fechaGestion,
      required this.tipoGestion,
      required this.tipoCanal,
      required this.tipoResultado,
      required this.tipoRiesgo,
      required this.tipoMotivo});

  factory GestionCotizacion.fromJson(Map<String, dynamic> json) {
    return GestionCotizacion(
        gestionId: json['gestionId'],
        numeroDocumento: json['numeroDocumento'],
        fechaGestion: json['fechaGestion'],
        tipoGestion: json['tipoGestion'],
        tipoCanal: json['tipoCanal'],
        tipoResultado: json['tipoResultado'],
        tipoRiesgo: json['tipoRiesgo'],
        tipoMotivo: json['tipoMotivo']);
  }
}

class Registro {
  final int codeError;
  final String msj;

  Registro({
    required this.codeError,
    required this.msj,
  });

  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
      codeError: json['codeError'],
      msj: json['msj'],
    );
  }
}

class GestionCotizacionDetalle {
  final int gestionId;
  final String numeroDocumento;
  final String itemCodigo;

  GestionCotizacionDetalle(
      {required this.gestionId,
      required this.numeroDocumento,
      required this.itemCodigo});

  factory GestionCotizacionDetalle.fromJson(Map<String, dynamic> json) {
    return GestionCotizacionDetalle(
        gestionId: json['gestionId'],
        numeroDocumento: json['numeroDocumento'],
        itemCodigo: json['itemCodigo']);
  }
}

class ListadoCatalogo {
  final String codigo;
  final String descripcion;

  ListadoCatalogo({
    required this.codigo,
    required this.descripcion,
  });

  factory ListadoCatalogo.fromJson(Map<String, dynamic> json) {
    return ListadoCatalogo(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
    );
  }
}

class Notificaciones {
  final int notificacionId;
  final String tipoNotificacion;
  final String tituloNotificacion;
  final String cuerpoNotificacion;
  final String valor;
  final String estado;
  final DateTime fechaCreacion;

  Notificaciones(
      {required this.notificacionId,
      required this.tipoNotificacion,
      required this.tituloNotificacion,
      required this.cuerpoNotificacion,
      required this.valor,
      required this.estado,
      required this.fechaCreacion});

  factory Notificaciones.fromJson(Map<String, dynamic> json) {
    return Notificaciones(
        notificacionId: json['notificacionId'],
        tipoNotificacion: json['tipoNotificacion'],
        tituloNotificacion: json['tituloNotificacion'],
        cuerpoNotificacion: json['cuerpoNotificacion'],
        valor: json['valor'],
        estado: json['estado'],
        fechaCreacion: DateTime.parse(json['fechaCreacion']));
  }
}

class GroupedNotification {
  final DateTime date;
  final List<Notificaciones> notifications;

  GroupedNotification({required this.date, required this.notifications});
  List<Notificaciones> get getNotifications => notifications ?? [];
}
