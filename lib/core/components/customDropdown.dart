import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<Map<String, String>> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final String title;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.title,
    this.selectedItem,
    required this.onChanged,
    this.hint,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final validSelectedItem = items.any((item) => item['codigo'] == selectedItem) ? selectedItem : null;
        print("4. EDITAR selected: ${title} - ${selectedItem}");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: validSelectedItem,
                hint: hint != null ? Text(hint!) : null,
                onChanged: onChanged,
                items: items.map((Map<String, String> item) {
                  return DropdownMenuItem<String>(
                    value: item['codigo'],
                    child: Text(item['descripcion'].toString()),
                  );
                }).toList(),
                isExpanded: true,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1E1E1E),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
