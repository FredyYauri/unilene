import 'package:flutter/material.dart';
import 'package:unilene_app/core/components/customButton.dart';
import 'package:unilene_app/core/components/customInputField.dart';
import 'package:unilene_app/core/components/customDropdown.dart';
import 'package:unilene_app/screens/contact/concat_edit_page.dart';
import 'package:unilene_app/services/contact/service_contact.dart';
import 'package:unilene_app/services/option/service_option.dart';

import '../../core/components/customDatePicker.dart';
import '../../core/components/customMultilineInputField.dart';

class ContactAdd extends StatefulWidget {
  final String accountId;
  final VoidCallback onRecordSaved;
  final Map<String, dynamic>? searchObject;
  const ContactAdd(
      {super.key,
      required this.accountId,
      required this.onRecordSaved,
      this.searchObject});

  @override
  State<ContactAdd> createState() => _ContactAddState();
}

class _ContactAddState extends State<ContactAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _apellidoPatController = TextEditingController();
  final TextEditingController _apellidoMatController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _dayController = TextEditingController();
  final TextEditingController _notaTextController = TextEditingController();
  List<Map<String, String>> _itemsDoc = [];
  List<Map<String, String>> _itemsArea = [];
  List<Map<String, String>> _itemsTypeArea = [];
  List<Map<String, String>> _itemsPosition = [];
  final List<Map<String, String>> _itemsGender = [
    {'codigo': 'M', 'descripcion': 'Masculino', 'auxiliar': ''},
    {'codigo': 'F', 'descripcion': 'Femenino', 'auxiliar': ''}
  ];
  String? _selectedTypeDocument;
  String? _selectedArea;
  String? _selectedTypeArea;
  String? _selectedposition;
  String? _selectedGender;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _setDataContact();
    _fetchDropdownData();
  }

  void _setDataContact() {
    if (widget.searchObject != null) {
      print("widget.searchObject ${widget.searchObject}");
      _nombresController.text = widget.searchObject!["nombre"];
      _apellidoPatController.text = widget.searchObject!["apellidoPaterno"];
      _apellidoMatController.text = widget.searchObject!["apellidoMaterno"];
    }
  }

  bool showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    return false;
  }

  bool validateFields() {
    if (_selectedArea == null) {
      return showMessage('Por favor ingresar Area');
    }
    if (_selectedTypeArea == null) {
      return showMessage('Por favor ingresar Tipo Area');
    }
    if (_selectedposition == null) {
      return showMessage('Por favor ingresar Cargo');
    }
    if (_selectedGender == null) {
      return showMessage('Por favor ingresar Genero');
    }
    if (_phoneController.text.isEmpty && _emailController.text.isEmpty) {
      return showMessage('Por favor ingresar E-mail o Celular');
    }

    return true;
  }

  void saveContact() {
    if (_formKey.currentState!.validate() && validateFields()) {
      print("1. ENTRA");
      final Map<String, dynamic> contact = {
        "nombre": _nombresController.text,
        "apellidoPaterno": _apellidoPatController.text,
        "apellidoMaterno": _apellidoMatController.text,
        "tipoDocumento": _selectedTypeDocument,
        "numeroDocumento": _documentNumberController.text,
        "genero": _selectedGender!,
        "correo": _emailController.text,
        "cuenta": int.parse(widget.accountId),
        "redAsistencial": null,
        "area": _selectedArea!,
        "tipoArea": _selectedTypeArea!,
        "cargo": _selectedposition!,
        "celular": _phoneController.text,
        "cumpleanio": _selectedDay != null ? formatDate(_selectedDay) : null,
        "notas": _notaTextController.text,
        "estado": "A",
        "modificadoPor": "0",
      };
      print("2. CONTACT: $contact");
      BackendContact().postSaveContact(contact).then((value) {
        widget.onRecordSaved();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados exitosamente')),
        );
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, complete todos los campos obligatorios')),
      );
    }
  }

  Future<void> _fetchDropdownData() async {
    BackendOption.getOption(context, "tipodocumento").then((value) => {
          setState(() {
            _itemsDoc = value;
          })
        });
    BackendOption.getOption(context, "area").then((value) => {
          setState(() {
            _itemsArea = value;
          })
        });
    BackendOption.getOption(context, "tipoarea").then((value) => {
          setState(() {
            _itemsTypeArea = value;
          })
        });
    BackendOption.getOption(context, "cargo").then((value) => {
          setState(() {
            _itemsPosition = value;
          })
        });
  }

  void _onDateChanged(int? day, int? month) {
    if (day != null && month != null) {
      _selectedDay = DateTime(DateTime.now().year, month, day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Contacto"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Vuelve a la pantalla de inicio
          },
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInputField(
                  title: 'Apellido Paterno:',
                  controller: _apellidoPatController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresar Apellido Paterno';
                    }
                    return null;
                  },
                ),
                CustomInputField(
                  title: 'Apellido Materno:',
                  controller: _apellidoMatController,
                  keyboardType: TextInputType.text,
                ),
                CustomInputField(
                  title: 'Nombres:',
                  controller: _nombresController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresar Nombres';
                    }
                    return null;
                  },
                ),
                CustomDropdown(
                  title: "Tipo Documento:",
                  items: _itemsDoc,
                  selectedItem: _selectedTypeDocument,
                  onChanged: (value) {
                    setState(() {
                      _selectedTypeDocument = value;
                    });
                  },
                  hint: 'Seleccione',
                ),
                CustomInputField(
                  title: 'Número de Documento:',
                  controller: _documentNumberController,
                  keyboardType: TextInputType.number,
                ),
                CustomDropdown(
                  title: "Área:",
                  items: _itemsArea,
                  selectedItem: _selectedArea,
                  onChanged: (value) {
                    setState(() {
                      _selectedArea = value;
                    });
                  },
                  hint: 'Seleccione',
                ),
                CustomDropdown(
                  title: "Tipo Área:",
                  items: _itemsTypeArea,
                  selectedItem: _selectedTypeArea,
                  onChanged: (value) {
                    setState(() {
                      _selectedTypeArea = value;
                    });
                  },
                  hint: 'Seleccione',
                ),
                CustomDropdown(
                  title: "Cargo:",
                  items: _itemsPosition,
                  selectedItem: _selectedposition,
                  onChanged: (value) {
                    setState(() {
                      _selectedposition = value;
                    });
                  },
                  hint: 'Seleccione',
                ),
                CustomDropdown(
                  title: "Genero:",
                  items: _itemsGender,
                  selectedItem: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  hint: 'Seleccione',
                ),
                CustomInputField(
                  title: 'E-mail:',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomInputField(
                  title: 'Telefono / Celular:',
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 4),
                DayMonthPicker(onDateChanged: _onDateChanged),
                CustomMultilineInputField(
                  title: 'Notas:',
                  controller: _notaTextController,
                  labelText: 'Ingrese su comentario',
                ),
                const SizedBox(height: 4),
                CustomButton(
                    type: 'success', label: 'Guardar', onPressed: saveContact)
              ],
            ),
          )),
    );
  }
}
