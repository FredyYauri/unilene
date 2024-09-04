import 'package:flutter/material.dart';
import 'package:unilene_app/services/contact/service_contact.dart';
import 'package:unilene_app/core/widgets/custom_font.dart';
import 'package:unilene_app/screens/contact/contact_detail_page.dart';

import 'concat_search_add_page.dart';

class ContactPage extends StatefulWidget {
  final String accountId;
  final String accountDescription;

  ContactPage({
    super.key,
    required this.accountId,
    required this.accountDescription,
  });

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _contacts = [];
  String _messageContact = "";

  void fetchData() {
    BackendContact.getDetalleContact(context, "", widget.accountId)
        .then((value) {
      setState(() {
        print("1. PRIMERA LISA: $value");
        if (value.isEmpty) {
          _messageContact = "No Se Encontraron Contactos";
          return;
        }
        _contacts = value;
      });
    });
  }

  void _onRecordSaved() {
    setState(() {
      print('Se llama al servicio luego de registrar.');
      fetchData(); // Actualiza los datos cuando se guarda el registro
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Inicialmente, carga los datos.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Vuelve a la pantalla de inicio
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(5.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        BackendContact.getDetalleContact(
                                context, value, widget.accountId)
                            .then((value) {
                          setState(() {
                            if (value.isEmpty) {
                              _messageContact = "No Se Encontraron Contactos";
                              return;
                            }
                            _contacts = value;
                          });
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Container(
            height: 50.0,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              widget.accountDescription,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: Color(0xFF000000),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          if (_contacts.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailContact(contact: contact, onRecordSaved: _onRecordSaved,),
                        ),
                      ).then((updatedContact) {
                        if (updatedContact != null) {
                          setState(() {
                            _contacts[index] = updatedContact;
                          });
                        }
                      });
                    },
                    child: Column(
                      children: [
                        const Divider(height: 1, color: Colors.grey),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 51.0,
                                color: Color(0xFF1E1E1E),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    fotmatTitleList(
                                      '${contact["nombre"]!} ${contact["apellidoPaterno"]!}',
                                    ),
                                    const SizedBox(height: 4.0),
                                    fotmatTextList(
                                      'Cargo: ${contact["cargo"]!}',
                                    ),
                                    fotmatTextList(
                                      'Area: ${contact["area"]!}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey),
                      ],
                    ),
                  );
                },
              ),
            ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [warningText(_messageContact)],
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactSearchAdd(
                      accountId: widget.accountId,
                      onRecordSaved: _onRecordSaved,
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
