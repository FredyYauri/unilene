import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final String type;

  const CustomButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.type})
      : super(key: key);

  Color _getBackgroundColor() {
    switch (type) {
      case 'success':
        return const Color(0xFFB9E4C9);
      case 'warning':
        return const Color(0xFFFFE599);
      case 'danger':
        return const Color(0xFFFFB796);
      case 'info':
        return const Color(0xFFBFF2F2);
      default:
        return const Color(
            0xFF2C2C2C); // Color por defecto si no se pasa un tipo válido
    }
  }

  Color _getTextColor() {
    switch (type) {
      case 'success':
        return const Color(0xFF3D8A4D);
      case 'warning':
        return const Color(0xFFB58900);
      case 'danger':
        return const Color(0xFFCA3F04);
      case 'info':
        return const Color(0xFF00CCCC);
      default:
        return Colors.white;
      // Color del texto por defecto
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 373, // Ancho fijo
      height: 40, // Alto fijo
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(12), // Espaciado interno
          ),
          backgroundColor: MaterialStateProperty.all(_getBackgroundColor()),
          // overlayColor: MaterialStateProperty.all(), llenar en caso se quiera un color al interactuar
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Borde redondeado
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: _getTextColor()),
        ),
      ),
    );
  }
}
