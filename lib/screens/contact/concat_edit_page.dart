import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unilene_app/core/components/customButton.dart';
import 'package:unilene_app/core/components/customInputField.dart';
import 'package:unilene_app/core/components/customDropdown.dart';
import 'package:unilene_app/core/components/customDatePicker.dart';
import 'package:unilene_app/core/components/customMultilineInputField.dart';
import 'package:unilene_app/core/widgets/dialog_services.dart';
import 'package:unilene_app/services/contact/service_contact.dart';
import 'package:unilene_app/services/option/service_option.dart';

class ContactEdit extends StatefulWidget {
  final Map<String, dynamic> contact;
  const ContactEdit({super.key, required this.contact});

  @override
  State<ContactEdit> createState() => _ContactEditState();
}

class _ContactEditState extends State<ContactEdit> {
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
    _fetchDropdownData();

    print("3. EDITAR CONTACTO: ${widget.contact}");
    if (widget.contact.isNotEmpty) {
      _apellidoPatController.text = widget.contact["apellidoPaterno"] ?? '';
      _apellidoMatController.text = widget.contact["apellidoMaterno"] ?? '';
      _nombresController.text = widget.contact["nombre"] ?? '';
      _documentNumberController.text = widget.contact["numeroDocumento"] ?? '';
      _emailController.text = widget.contact["correo"] ?? '';
      _phoneController.text = widget.contact["celular"] ?? '';
      // _dayController.text = widget.contact["cumpleanios"] == "null"
      //     ? ''
      //     : widget.contact["cumpleanios"]!;
      _notaTextController.text = widget.contact["notas"] ?? '';
      _selectedTypeDocument = widget.contact["codTipoDocumento"];
      _selectedArea = widget.contact["codArea"];
      _selectedTypeArea = widget.contact["codTipoArea"];
      _selectedposition = widget.contact["codCargo"];
      _selectedGender = widget.contact["genero"];
    }
  }

  void _onDateChanged(int? day, int? month) {
    if (day != null && month != null) {
      _selectedDay = DateTime(DateTime.now().year, month, day);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Contacto"),
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
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Por favor ingresar Email';
                  //   }
                  //   final RegExp emailRegex = RegExp(
                  //     r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  //   );

                  //   // Valida el formato del correo
                  //   if (!emailRegex.hasMatch(value)) {
                  //     return 'Por favor ingresa un correo electrónico válido';
                  //   }
                  //   return null;
                  // },
                ),
                CustomInputField(
                  title: 'Telefono / Celular:',
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Por favor ingresar Telefono / Celular';
                  //   }
                  //   return null;
                  // },
                ),

                const SizedBox(height: 4),
                DayMonthPicker(
                    onDateChanged: _onDateChanged,
                    initialDate: widget.contact["cumpleanios"]),
                // CustomInputField(
                //   title: 'Cumpleaños:',
                //   controller: _dayController,
                //   keyboardType: TextInputType.text,
                //   // validator: (value) {
                //   //   if (value == null || value.isEmpty) {
                //   //     return 'Por favor ingresar Cumpleaños';
                //   //   }
                //   //   return null;
                //   // },
                // ),
                CustomMultilineInputField(
                  title: 'Notas:',
                  controller: _notaTextController,
                  labelText: 'Ingrese su comentario',
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Por favor ingrese notas';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 4),
                CustomButton(
                    label: 'Guardar',
                    type: 'success',
                    onPressed: () => {
                          saveContact(
                              _formKey,
                              context,
                              _apellidoPatController,
                              _apellidoMatController,
                              _nombresController,
                              _selectedTypeDocument,
                              _documentNumberController,
                              _selectedArea,
                              _selectedTypeArea,
                              _selectedposition,
                              _selectedGender,
                              _emailController,
                              _phoneController,
                              // _dayController,
                              _notaTextController,
                              widget.contact,
                              _itemsDoc,
                              _itemsArea,
                              _itemsTypeArea,
                              _itemsPosition,
                              _selectedDay)
                        } //saveContact
                    )
              ],
            ),
          )),
    );
  }
}

String formatDate(DateTime? date) {
  if (date == null) return 'No date selected';
  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // Formato deseado
  return formatter.format(date);
}

void saveContact(
    GlobalKey<FormState> formKey,
    BuildContext context,
    TextEditingController apellidoPatController,
    TextEditingController apellidoMatController,
    TextEditingController nombresController,
    String? selectedTypeDocument,
    TextEditingController documentNumberController,
    String? selectedArea,
    String? selectedTypeArea,
    String? selectedPosition,
    String? selectedGender,
    TextEditingController emailController,
    TextEditingController phoneController,
    // TextEditingController dayController,
    TextEditingController notaTextController,
    Map<String, dynamic> _contact,
    List<Map<String, String>> _itemsDoc,
    List<Map<String, String>> _itemsArea,
    List<Map<String, String>> _itemsTypeArea,
    List<Map<String, String>> _itemsPosition,
    DateTime? _selectedDay) {
  if (emailController.text.isEmpty && phoneController.text.isEmpty) {
    showCustomDialog(
        context, "Debe Ingresar Correo o Telefono", DialogType.warning);
    return;
  }
  print("Contacto guardado1: $_selectedDay");
  if (formKey.currentState!.validate()) {
    final Map<String, dynamic> contact = {
      "codigo": _contact['codigo']!,
      "nombre": nombresController.text,
      "apellidoPaterno": apellidoPatController.text,
      "apellidoMaterno": apellidoMatController.text,
      "tipoDocumento": selectedTypeDocument!,
      "numeroDocumento": documentNumberController.text,
      "genero": selectedGender!,
      "correo": emailController.text,
      "cuenta": _contact['cuenta']!,
      "redAsistencial": _contact['redAsistencial']!,
      "area": selectedArea!,
      "tipoArea": selectedTypeArea!,
      "cargo": selectedPosition!,
      "celular": phoneController.text,
      // "cumpleanio": dayController.text,
      "cumpleanio": _selectedDay != null ? formatDate(_selectedDay) : null,
      "notas": notaTextController.text,
      "estado": "A",
      "modificadoPor": "0",
    };

    print("Contacto guardado2: $contact");
    _contact["nombre"] = nombresController.text;
    _contact["apellidoPaterno"] = apellidoPatController.text;
    _contact["apellidoMaterno"] = apellidoMatController.text;
    _contact["codTipoDocumento"] = selectedTypeDocument;
    if (selectedTypeDocument.isNotEmpty) {
      _contact["tipoDocumento"] = _itemsDoc.firstWhere((element) =>
          element["codigo"] == selectedTypeDocument)["descripcion"];
    }
    _contact["numeroDocumento"] = documentNumberController.text;
    _contact["genero"] = selectedGender;
    _contact["correo"] = emailController.text;
    _contact["codArea"] = selectedArea;
    _contact["area"] = _itemsArea.firstWhere(
        (element) => element["codigo"] == selectedArea)["descripcion"]!;
    _contact["codTipoArea"] = selectedTypeArea;
    _contact["tipoArea"] = _itemsTypeArea.firstWhere(
        (element) => element["codigo"] == selectedTypeArea)["descripcion"]!;
    _contact["codCargo"] = selectedPosition;
    _contact["cargo"] = _itemsPosition.firstWhere(
        (element) => element["codigo"] == selectedPosition)["descripcion"]!;
    _contact["celular"] = phoneController.text;
    _contact["cumpleanios"] =
        _selectedDay != null ? formatDate(_selectedDay) : null;
    _contact["notas"] = notaTextController.text;
    _contact["estado"] = "A";

    // Lógica de guardado o envío de los datos
    print("Contacto _contact guardado3: $_contact");
    BackendContact.postUpdateContact(context, contact).then((value) => {
          if (value)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Se Guardo Correctamente")),
              ),
              Navigator.pop(context, _contact),
            }
          else
            {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("No Se Pudo Guardar Correctamente")),
              ),
            }
        });
  }
}
