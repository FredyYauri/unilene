import 'package:flutter/material.dart';
import 'package:unilene_app/core/components/customInputField.dart';
import 'package:unilene_app/core/components/customButton.dart';
import 'package:unilene_app/core/widgets/custom_font.dart';
import 'package:unilene_app/screens/contact/concat_add_page.dart';
import 'package:unilene_app/screens/contact/concat_edit_page.dart';

import '../../services/contact/service_tuition.dart';

class ContactSearchAdd extends StatefulWidget {
  final String accountId;
  final VoidCallback onRecordSaved;
  const ContactSearchAdd({
    super.key,
    required this.accountId,
    required this.onRecordSaved,
  });

  @override
  State<ContactSearchAdd> createState() => _ContactSearchAddState();
}

class _ContactSearchAddState extends State<ContactSearchAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  List<Map<String, String>> _resultSearch = [];
  String _textErrorResult = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Contacto')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInputField(
                  title: 'Ingresar N° Colegiatura:',
                  controller: numberController,
                  keyboardType: TextInputType.number,
                ),
                CustomInputField(
                  title: 'Ingresar Nombre y Apellido:',
                  controller: nameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        type: 'info',
                        label: 'Buscar',
                        onPressed: () {
                          if (nameController.text.isNotEmpty ||
                              numberController.text.isNotEmpty) {
                            setState(() {
                              _textErrorResult = "";
                            });
                            BackendTuition.getTuitionContact(context,
                                    nameController.text, numberController.text)
                                .then((value) => setState(() {
                                      if (value.isEmpty) {
                                        _textErrorResult =
                                            "No se encontraron resultados";
                                        return;
                                      }
                                      _resultSearch = [];
                                      for (var item in value) {
                                        _resultSearch.add({
                                          "apellidoPaterno":
                                              item["apellidoPaterno"] ?? '',
                                          "apellidoMaterno":
                                              item["apellidoMaterno"] ?? '',
                                          "nombre": item["nombres"] ?? '',
                                          "especialidad":
                                              item["especialidad"] ?? '',
                                        });
                                      }
                                    }));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cargando...')),
                            );
                          } else {
                            setState(() {
                              _textErrorResult =
                                  "Ingresar Nombres o N° Colegiatura";
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CustomButton(
                        type: 'success',
                        label: 'Nuevo',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactAdd(
                                  accountId: widget.accountId,
                                  onRecordSaved: widget.onRecordSaved,
                                ),
                              ));
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                warningText(_textErrorResult),
                Expanded(
                    child: ListView.builder(
                  itemCount: _resultSearch.length,
                  itemBuilder: (context, index) {
                    final result = _resultSearch[index];
                    return Column(
                      children: [
                        const Divider(height: 1, color: Colors.grey),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 8.0,
                          ),
                          child: Row(
                            children: [
                              // const Icon(
                              //   Icons.person,
                              //   size: 51.0,
                              //   color: Color(0xFF1E1E1E),
                              // ),
                              // const SizedBox(width: 8.0),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    fotmatTitleList(
                                        '${result["nombre"]!} ${result["apellidoPaterno"]!} ${result["apellidoMaterno"]!}'),
                                    const SizedBox(height: 4.0),
                                    fotmatTextList(
                                        'Especialidad: ${result["especialidad"]!}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CustomButton(
                                            type: 'warning',
                                            label: 'Editar',
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ContactAdd(
                                                      accountId:
                                                          widget.accountId,
                                                      onRecordSaved:
                                                          widget.onRecordSaved,
                                                          searchObject: result
                                                    ),
                                                  ));
                                            })
                                      ]))
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                    );
                  },
                ))
              ],
            ),
          )),
    );
  }
}
