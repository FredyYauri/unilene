import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;
  const CustomCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // Usamos el callback pasado como parámetro
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color), // Icono configurable
                const SizedBox(height: 5),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color), // Texto configurable
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}