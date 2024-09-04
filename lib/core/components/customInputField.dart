import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomInputField({
    super.key,
    required this.title,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: Color(0xFF1E1E1E),
              )),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // Borde redondeado
                borderSide: const BorderSide(
                  color: Color(0xFFD9D9D9), // Color del borde
                  width: 1.0, // Ancho del borde
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.grey, // Color del borde cuando está habilitado
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.blue, // Color del borde cuando está en foco
                  width: 2.0,
                ),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
