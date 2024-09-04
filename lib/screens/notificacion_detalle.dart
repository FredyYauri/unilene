import 'package:flutter/material.dart';
import 'package:unilene_app/services/service_notificacion_update.dart';
import 'package:unilene_app/services/service_notificaciones.dart';

class DetailNotificacion extends StatefulWidget {
  final int id;
  final String fecha;
  final String titulo;
  final String notificacion;
  const DetailNotificacion(
      {Key? key,
      required this.id,
      required this.fecha,
      required this.titulo,
      required this.notificacion})
      : super(key: key);

  @override
  _DetailNotificacionState createState() => _DetailNotificacionState();
}

class _DetailNotificacionState extends State<DetailNotificacion> {
  Map<String, String> _datos = {};

  @override
  void initState() {
    super.initState();

    //Actualizar el estado de la notificacion
    int valor = widget.id;
    BackendActualizarNotificacion.getActualizarNotificacion(valor)
        .then((value) => setState(() {
              _datos = value as Map<String, String>;
              print('_datos usuario: $_datos');
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalle de Notificacion'),
        ),
        body: Stack(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fecha,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.titulo,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      widget.notificacion,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
