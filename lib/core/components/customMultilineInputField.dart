import 'package:flutter/material.dart';

class CustomMultilineInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final String title;

  const CustomMultilineInputField({
    Key? key,
    required this.controller,
    required this.title,
    this.labelText,
    this.validator,
    this.maxLines = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
            minLines: 3,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labelText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            validator: validator,
          )
        ]));
  }
}
