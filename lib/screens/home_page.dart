import 'package:flutter/material.dart';
import 'package:unilene_app/screens/app_page.dart';
//import 'package:mi_app/screens/consult_screen.dart';
//import 'package:mi_app/screens/edit_screen.dart';
//import 'package:mi_app/screens/home_screen.dart';
//import 'package:mi_app/screens/search_screen.dart';
//import 'package:mi_app/screens/view_screen.dart';
import 'package:unilene_app/screens/home_screen.dart';
import 'package:unilene_app/screens/notificaciones.dart';
import 'package:unilene_app/screens/presupuesto_page.dart';
import 'package:unilene_app/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyPresupuestoPage(),
    //HomeScreen(),
    AppScreen(),
    //HomeScreen(),
    //HomeScreen()
    NotificationsScreen(),
    ProfilePage(),
    //SearchScreen(),
    //EditScreen(),
    //ConsultScreen(),
    //ViewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Estadisticas',
          ),
          */
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Aplicaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
