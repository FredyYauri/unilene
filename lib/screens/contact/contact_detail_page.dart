import 'package:flutter/material.dart';
import 'package:unilene_app/core/components/customButton.dart';
import 'package:unilene_app/screens/contact/concat_edit_page.dart';
import 'package:unilene_app/services/contact/service_contact.dart';

class DetailContact extends StatefulWidget {
  final Map<String, dynamic> contact;
  final VoidCallback onRecordSaved;
  const DetailContact(
      {super.key, required this.contact, required this.onRecordSaved});

  @override
  State<DetailContact> createState() => _DetailContactState();
}

class _DetailContactState extends State<DetailContact> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> item = widget.contact;
        print("2. PRIMER CONTACTO: $item");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Contacto'),
      ),
      backgroundColor: Colors.white, // Fondo transparente
      body: SingleChildScrollView(
        // Envolvemos el Column en un SingleChildScrollView
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildDetailItem('Cuenta:', '${item["cuentaDescripcion"]}'),
              _buildDetailItem('Nombres y Apellidos:',
                  '${item["nombre"]} ${item["apellidoPaterno"]} ${item["apellidoMaterno"]}'),
              _buildDetailItem(
                  '${item["tipoDocumento"] == '' ?'D.N.I.': item["tipoDocumento"]}:', '${item["numeroDocumento"]}'),
              _buildDetailItem('Área:', '${item["area"]}'),
              _buildDetailItem('T. Área:', '${item["tipoArea"]}'),
              _buildDetailItem('Cargo:', '${item["cargo"]}'),
              _buildDetailItem('E. Mail:', '${item["correo"]}'),
              _buildDetailItem('Telefono:', '${item["celular"]}'),
              _buildDetailItem('Cumpleaños:', '${item["cumpleanios"]}'),
              _buildDetailItem('Notas:', '${item["notas"]}'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: CustomButton(
                          type: 'warning',
                          label: "Editar",
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ContactEdit(contact: item),
                                    )).then((updatedContact) {
                                  widget.onRecordSaved();
                                  if (updatedContact != null) {
                                    setState(() {
                                      item = updatedContact;
                                    });
                                  }
                                }),
                              })),
                  const SizedBox(width: 16.0),
                  Expanded(
                      child: CustomButton(
                          type: 'danger',
                          label: "Eliminar",
                          onPressed: () => {
                                _showDeleteConfirmationDialog(
                                    context, item, widget.onRecordSaved)
                              }))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDetailItem(String title, String detail) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.topRight,
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            )),
            const SizedBox(width: 10),
            Expanded(
                child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                detail == "null" ? '' : detail,
                textAlign: TextAlign.right,
              ),
            )),
          ],
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

void _showDeleteConfirmationDialog(BuildContext context,
    Map<String, dynamic> item, VoidCallback onRecordSaved) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alerta'),
        content:
            const Text('¿Estás seguro de que deseas eliminar este contacto?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              item["estado"] = "I";
              // Aquí va la lógica para eliminar el elemento
              BackendContact.postUpdateContact(context, item).then((value) => {
                    onRecordSaved(),
                    if (value)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Contacto Eliminado Satisfactoriamente")),
                        ),
                      }
                    else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Error al Eliminar Contacto")),
                        ),
                      }
                  });
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}
